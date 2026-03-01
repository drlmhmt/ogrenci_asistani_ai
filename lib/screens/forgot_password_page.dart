import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/top_alert.dart'; // TopAlert import edildi
import 'mail_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _authService = AuthService();
  late final TextEditingController _emailController;
  bool _isLoading = false;

  bool get _isEmailValid {
    final value = _emailController.text.trim();
    return value.isNotEmpty && value.contains('@');
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _handleContinue() async {
    final email = _emailController.text.trim();
    
    // Basit doğrulama kontrolü
    if (email.isEmpty || !email.contains('@')) {
      TopAlert.show(context, message: 'Lütfen geçerli bir email girin.', type: TopAlertType.warning);
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Önce bu mailin kayıtlı olup olmadığını kontrol etmek iyi bir pratiktir
      // Ancak Firebase gizlilik gereği 'user-not-found' hatasını bazen döndürmez
      await _authService.sendPasswordResetEmail(email);
      
      if (!mounted) return;
      
      // Başarı mesajı
      TopAlert.show(
        context, 
        message: 'Sıfırlama bağlantısı gönderildi!', 
        type: TopAlertType.success
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MailVerificationPage(
            email: email,
            flow: MailVerificationFlow.passwordReset,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // Hata mesajını TopAlert ile gösteriyoruz
      TopAlert.show(context, message: _mapError(e), type: TopAlertType.error);
    } catch (e) {
      if (!mounted) return;
      TopAlert.show(context, message: 'Beklenmedik bir hata oluştu.', type: TopAlertType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapError(FirebaseAuthException e) {
    // Debug için terminale hatayı yazdıralım, gerçek sebebi görebilmen için
    debugPrint("Firebase Reset Error: ${e.code} - ${e.message}");
    
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'user-not-found':
        return 'Bu email ile kayıtlı kullanıcı bulunamadı.';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptın. Lütfen biraz bekle.';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin.';
      case 'internal-error':
        return 'Firebase servisinde bir sorun oluştu.';
      default:
        return 'İşlem başarısız (Kod: ${e.code})';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _isEmailValid && !_isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF00184B),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Dekoratif Daireler
            _buildBackgroundCircle(top: -40, right: -30, size: 180, alpha: 0.35),
            _buildBackgroundCircle(bottom: 90, left: -50, size: 170, alpha: 0.20),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),
                    const SizedBox(height: 18),
                    const Center(
                      child: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Kayıtlı mailini gir, sana sıfırlama kodu gönderelim.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.62), fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildEmailField(),
                    const Spacer(),
                    _buildSubmitButton(isEnabled),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Metotları ---

  Widget _buildBackgroundCircle({double? top, double? right, double? bottom, double? left, required double size, required double alpha}) {
    return Positioned(
      top: top, right: right, bottom: bottom, left: left,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [const Color(0xFF5A84D9).withValues(alpha: alpha), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.20), Colors.white.withValues(alpha: 0.10)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pop(context),
          child: const SizedBox(
            width: 42, height: 42,
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: Color(0xFFB7C8EA)),
        filled: true,
        fillColor: const Color(0xFF6C88C4).withValues(alpha: 0.3), // Daha şık bir görünüm için alpha ekledim
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSubmitButton(bool isEnabled) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF7B7D84),
          foregroundColor: const Color(0xFF111315),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('İleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}