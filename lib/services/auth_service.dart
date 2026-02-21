import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Giriş ve kayıt işlemleri Firebase Auth + Firestore ile yapılır.
/// Firebase Console → Authentication → Sign-in method → E-posta/Parola'yı etkinleştirmen gerekir.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// E-posta ve parola ile giriş
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Tek seferlik kayıt: Auth hesabı oluşturur, Firestore'da kullanıcı belgesi tutar
  Future<UserCredential?> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user != null && displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }
      if (user != null) {
        await _saveUserToFirestore(
          uid: user.uid,
          email: user.email ?? email.trim(),
          displayName: displayName ?? user.displayName,
        );
      }
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Kayıtlı kullanıcıyı Firestore'da users koleksiyonuna yazar
  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'displayName': displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  /// Çıkış
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
