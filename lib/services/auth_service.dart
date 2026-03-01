import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'onboarding_state_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final OnboardingStateService _onboardingStateService =
      OnboardingStateService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- Giriş ve Kayıt Metotları (Değişmedi) ---

  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _saveUserToFirestore(
          uid: user.uid,
          email: user.email ?? email.trim(),
          displayName: user.displayName,
        );
        await _syncOnboardingSelectionToFirestore(uid: user.uid);
      }
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

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
        await _syncOnboardingSelectionToFirestore(uid: user.uid);
      }
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // --- Sosyal Girişler (Değişmedi) ---

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..setCustomParameters({'prompt': 'select_account'});
      final cred = await _signInWithProvider(provider);
      final user = cred.user;
      if (user != null) {
        await _saveUserToFirestore(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        );
        await _syncOnboardingSelectionToFirestore(uid: user.uid);
      }
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final provider = AppleAuthProvider()..addScope('email');
      final cred = await _signInWithProvider(provider);
      final user = cred.user;
      if (user != null) {
        await _saveUserToFirestore(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        );
        await _syncOnboardingSelectionToFirestore(uid: user.uid);
      }
      return cred;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> _signInWithProvider(AuthProvider provider) {
    if (kIsWeb) {
      return _auth.signInWithPopup(provider);
    }
    return _auth.signInWithProvider(provider);
  }

  // --- E-posta İşlemleri (ActionCodeSettings eklendi) ---

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null || user.emailVerified) return;

    // Link tıklandığında uygulamanın açılmasını sağlayan ayarlar
    final settings = ActionCodeSettings(
      url: 'https://ogrenci-asistani-60eda.firebaseapp.com', // Firebase Console'da tanımlı domain
      handleCodeInApp: true,
      androidPackageName: 'com.ogrenci.asistani', // build.gradle'daki applicationId
      androidInstallApp: true,
      androidMinimumVersion: '12',
      iOSBundleId: 'com.ogrenci.asistani', // Xcode'daki Bundle Identifier
    );

    await user.sendEmailVerification(settings);
  }

  Future<void> sendPasswordResetEmail(String email) {
    final settings = ActionCodeSettings(
      url: 'https://ogrenci-asistani-60eda.firebaseapp.com',
      handleCodeInApp: true,
      androidPackageName: 'com.ogrenci.asistani',
      iOSBundleId: 'com.ogrenci.asistani',
    );
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
      actionCodeSettings: settings,
    );
  }

  // --- Şifre ve Doğrulama Yardımcıları (Değişmedi) ---

  Future<void> verifyPasswordResetCode(String code) {
    return _auth.verifyPasswordResetCode(code.trim());
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) {
    return _auth.confirmPasswordReset(
      code: code.trim(),
      newPassword: newPassword,
    );
  }

  // --- Firestore ve Onboarding İşlemleri (Derleme hatası düzeltildi) ---

  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      await _firestore.collection('users').doc(uid).set({
        'email': email.trim(),
        'emailLower': normalizedEmail,
        'displayName': displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isEmailRegistered(String email) async {
    final rawEmail = email.trim();
    final normalizedEmail = rawEmail.toLowerCase();
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) return false;

    try {
      final lowerQuery = await _firestore
          .collection('users')
          .where('emailLower', isEqualTo: normalizedEmail)
          .limit(1)
          .get();
      if (lowerQuery.docs.isNotEmpty) return true;

      final exactRawQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: rawEmail)
          .limit(1)
          .get();
      if (exactRawQuery.docs.isNotEmpty) return true;

      final exactLowerQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();
      return exactLowerQuery.docs.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Onboarding seçimlerini mevcut kullanıcı için senkronize eder.
  /// (onboarding_screen.dart içindeki hatayı çözen metot)
  Future<void> syncOnboardingSelectionForCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;
    await _syncOnboardingSelectionToFirestore(uid: currentUser.uid);
  }

  Future<void> _syncOnboardingSelectionToFirestore({
    required String uid,
  }) async {
    final selection = await _onboardingStateService.getSelection();
    if (selection == null) return;

    try {
      await _firestore.collection('users').doc(uid).set({
        'onboardingSeen': true,
        'onboardingGoalIndex': selection.goalIndex,
        'onboardingGoalText': selection.goalText,
        'onboardingUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }
}