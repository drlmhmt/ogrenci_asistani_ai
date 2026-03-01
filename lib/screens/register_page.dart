import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'ana_ekran.dart';
import 'login_page.dart';
import 'mail_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isAnyLoading =>
      _isEmailLoading || _isGoogleLoading || _isAppleLoading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty) {
      _showError('Email zorunlu.');
      return;
    }
    if (!email.contains('@')) {
      _showError('Geçerli bir email girin.');
      return;
    }
    if (password.isEmpty) {
      _showError('Şifre zorunlu.');
      return;
    }
    if (password.length < 6) {
      _showError('Şifre en az 6 karakter olmalı.');
      return;
    }
    if (confirm != password) {
      _showError('Şifreler eşleşmiyor.');
      return;
    }

    setState(() => _isEmailLoading = true);
    try {
      final cred = await _authService.registerWithEmailPassword(
        email: email,
        password: password,
      );
      final user = cred?.user;
      if (user == null) {
        _showError('Kayıt tamamlanamadı. Tekrar dene.');
        return;
      }

      await user.sendEmailVerification();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MailVerificationPage(
            email: user.email ?? email,
            flow: MailVerificationFlow.registerEmail,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) debugPrint('Kayıt hatası: code=${e.code}, message=${e.message}');
      _showError(_mapRegisterError(e));
    } catch (e, st) {
      if (kDebugMode) debugPrint('Kayıt hatası (beklenmeyen): $e\n$st');
      _showError('Beklenmeyen bir hata oluştu. Tekrar dene.');
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final cred = await _authService.signInWithGoogle();
      if (cred == null) return;
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) debugPrint('Google giriş hatası: code=${e.code}, message=${e.message}');
      _showError(_mapSocialError(e, provider: 'Google'));
    } catch (e, st) {
      if (kDebugMode) debugPrint('Google giriş hatası (beklenmeyen): $e\n$st');
      _showError('Google ile giriş yapılamadı.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _loginWithApple() async {
    setState(() => _isAppleLoading = true);
    try {
      final cred = await _authService.signInWithApple();
      if (cred == null) return;
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) debugPrint('Apple giriş hatası: code=${e.code}, message=${e.message}');
      _showError(_mapSocialError(e, provider: 'Apple'));
    } catch (e, st) {
      if (kDebugMode) debugPrint('Apple giriş hatası (beklenmeyen): $e\n$st');
      _showError('Apple ile giriş yapılamadı.');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AnaEkran()),
      (route) => false,
    );
  }

  String _mapRegisterError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Bu email zaten kullanımda.';
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'weak-password':
        return 'Şifre en az 6 karakter olmalı.';
      case 'operation-not-allowed':
        return 'Email/şifre kaydı Firebase tarafında aktif değil. Firebase Console > Authentication > Sign-in method bölümünden etkinleştir.';
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen daha sonra tekrar dene.';
      case 'network-request-failed':
        return 'İnternet bağlantısını kontrol et ve tekrar dene.';
      default:
        return kDebugMode
            ? 'Kayıt hatası: ${e.code} - ${e.message ?? ""}'
            : 'Kayıt işlemi başarısız oldu.';
    }
  }

  String _mapSocialError(FirebaseAuthException e, {required String provider}) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Bu email farklı bir yöntem ile kayıtlı.';
      case 'operation-not-allowed':
        return '$provider girişi Firebase Console > Authentication > Sign-in method bölümünden etkinleştir. Android için SHA-1 parmak izini ekle.';
      case 'network-request-failed':
        return 'İnternet bağlantısını kontrol et ve tekrar dene.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Giriş iptal edildi.';
      default:
        return kDebugMode
            ? '$provider hatası: ${e.code} - ${e.message ?? ""}'
            : '$provider ile giriş yapılamadı.';
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00184B),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final scale = (screenHeight / 860).clamp(0.82, 1.0);
            final topPadding = MediaQuery.of(context).padding.top;
            final bottomPadding = MediaQuery.of(context).padding.bottom;
            final panelTop = screenHeight * 0.24;
            final panelHeight = screenHeight - panelTop;

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/LoginBackground.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: const Color(0xFF00184B)),
                  ),
                ),
                Positioned(
                  top: topPadding + 16 * scale,
                  right: -40 * scale,
                  child: Container(
                    width: 148 * scale,
                    height: 148 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF77A4FF).withValues(alpha: 0.42),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: topPadding + 28 * scale,
                  child: IgnorePointer(
                    child: SizedBox(
                      height: (panelTop - topPadding - 28 * scale).clamp(
                        108.0,
                        188.0,
                      ),
                      child: _TopRegisterAnimation(scale: scale),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: panelHeight,
                    padding: EdgeInsets.fromLTRB(
                      24 * scale,
                      30 * scale,
                      24 * scale,
                      (bottomPadding > 0 ? bottomPadding : 8) + 8 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F68A1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(44 * scale),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            color: const Color(0xFF00184B),
                            fontSize: 22 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6 * scale),
                        Text(
                          'Hesabını birkaç adımda oluştur.',
                          style: TextStyle(
                            color: const Color(
                              0xFF00184B,
                            ).withValues(alpha: 0.6),
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 22 * scale),
                        _AuthField(
                          controller: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          height: 56,
                        ),
                        SizedBox(height: 14 * scale),
                        _AuthField(
                          controller: _passwordController,
                          hintText: 'Şifre',
                          obscureText: _obscurePassword,
                          height: 56,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFA6B3CC),
                              size: 20 * scale,
                            ),
                          ),
                        ),
                        SizedBox(height: 14 * scale),
                        _AuthField(
                          controller: _confirmPasswordController,
                          hintText: 'Şifreyi Onayla',
                          obscureText: _obscureConfirmPassword,
                          height: 56,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFA6B3CC),
                              size: 20 * scale,
                            ),
                          ),
                        ),
                        SizedBox(height: 18 * scale),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isAnyLoading
                                ? null
                                : _registerWithEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF151515),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32 * scale),
                              ),
                              elevation: 0,
                            ),
                            child: _isEmailLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Kayıt Ol',
                                    style: TextStyle(
                                      fontSize: 17 * scale,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 22 * scale),
                        const _AuthDivider(),
                        SizedBox(height: 18 * scale),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialCircleButton(
                                assetPath: 'assets/LoginGoogle.png',
                                loading: _isGoogleLoading,
                                iconSize: 20,
                                size: 64,
                                onTap: _isAnyLoading ? null : _loginWithGoogle,
                              ),
                              SizedBox(width: 24 * scale),
                              _SocialCircleButton(
                                assetPath: 'assets/LoginApple.png',
                                loading: _isAppleLoading,
                                iconSize: 20,
                                size: 64,
                                onTap: _isAnyLoading ? null : _loginWithApple,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Zaten bir hesabın var mı? ',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 14 * scale,
                                ),
                              ),
                              GestureDetector(
                                onTap: _isAnyLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginPage(),
                                          ),
                                        );
                                      },
                                child: Text(
                                  'Giriş Yap',
                                  style: TextStyle(
                                    color: const Color(0xFF001BD8),
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hintText,
    required this.height,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final double height;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFA3AFC8), fontSize: 15),
          filled: true,
          fillColor: const Color(0xFF001644),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    const lineColor = Color(0xFF1C356E);
    return Row(
      children: [
        Expanded(child: Container(height: 1.3, color: lineColor)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'YA DA',
            style: TextStyle(
              color: Color(0xFF102C66),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Container(height: 1.3, color: lineColor)),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  const _SocialCircleButton({
    required this.assetPath,
    required this.loading,
    required this.size,
    required this.iconSize,
    required this.onTap,
  });

  final String assetPath;
  final bool loading;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Ink(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset(
                    assetPath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person_outline, color: Colors.black54),
                  ),
          ),
        ),
      ),
    );
  }
}

class _TopRegisterAnimation extends StatefulWidget {
  const _TopRegisterAnimation({required this.scale});

  final double scale;

  @override
  State<_TopRegisterAnimation> createState() => _TopRegisterAnimationState();
}

class _TopRegisterAnimationState extends State<_TopRegisterAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final floatY = math.sin(t * 2 * math.pi) * 8 * widget.scale;
        final tilt = math.sin(t * 2 * math.pi) * 0.035;
        final pulse = 0.9 + (math.sin(t * 2 * math.pi) + 1) * 0.06;

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: pulse,
              child: Container(
                width: 140 * widget.scale,
                height: 140 * widget.scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8FC5FF).withValues(alpha: 0.30),
                      const Color(0xFF8FC5FF).withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, floatY),
              child: Transform.rotate(
                angle: tilt,
                child: Container(
                  width: 144 * widget.scale,
                  height: 90 * widget.scale,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14 * widget.scale,
                    vertical: 10 * widget.scale,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFDDEBFF), Color(0xFFC8DDFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0B2D6C).withValues(alpha: 0.28),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _CheckDot(active: true, scale: widget.scale),
                          SizedBox(width: 8 * widget.scale),
                          Expanded(
                            child: Container(
                              height: 7 * widget.scale,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6A8BC7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _CheckDot(active: true, scale: widget.scale),
                          SizedBox(width: 8 * widget.scale),
                          Expanded(
                            child: Container(
                              height: 7 * widget.scale,
                              decoration: BoxDecoration(
                                color: const Color(0xFF88A3D4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _CheckDot(active: false, scale: widget.scale),
                          SizedBox(width: 8 * widget.scale),
                          Expanded(
                            child: Container(
                              height: 7 * widget.scale,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA2B7DB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18 * widget.scale,
              top: 16 * widget.scale,
              child: Transform.scale(
                scale: 0.9 + (math.cos(t * 2 * math.pi) + 1) * 0.08,
                child: Icon(
                  Icons.auto_awesome,
                  size: 18 * widget.scale,
                  color: const Color(0xFFE5F1FF),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CheckDot extends StatelessWidget {
  const _CheckDot({required this.active, required this.scale});

  final bool active;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14 * scale,
      height: 14 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF3A6EE8) : const Color(0xFFB7C9EA),
      ),
      child: Icon(
        active ? Icons.check : Icons.circle,
        size: active ? 10 * scale : 6 * scale,
        color: Colors.white,
      ),
    );
  }
}
