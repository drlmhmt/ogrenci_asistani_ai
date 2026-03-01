import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/top_alert.dart';
import 'ana_ekran.dart';
import 'forgot_password_page.dart';
import 'mail_verification_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _obscurePassword = true;

  bool get _isAnyLoading =>
      _isEmailLoading || _isGoogleLoading || _isAppleLoading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      TopAlert.show(context, message: 'Email zorunlu.');
      return;
    }
    if (!email.contains('@')) {
      TopAlert.show(context, message: 'Geçerli bir email girin.');
      return;
    }
    if (password.isEmpty) {
      TopAlert.show(context, message: 'Şifre zorunlu.');
      return;
    }

    setState(() => _isEmailLoading = true);
    try {
      final cred = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );
      final user = cred?.user;
// LoginPage içindeki ilgili kısım:
if (user != null && !user.emailVerified) {
  // pushReplacement yerine normal push kullanıyoruz
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MailVerificationPage(
        email: user.email ?? email,
        flow: MailVerificationFlow.registerEmail,
      ),
    ),
  );
  return;
}
       
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('Giriş hatası: code=${e.code}, message=${e.message}');
      TopAlert.show(context, message: _mapLoginError(e));
    } catch (e, st) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('Giriş hatası (beklenmeyen): $e\n$st');
      TopAlert.show(context, message: 'Giriş yapılamadı. Tekrar dene.');
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
      if (!mounted) return;
      if (kDebugMode) debugPrint('Google giriş hatası: code=${e.code}, message=${e.message}');
      TopAlert.show(context, message: _mapSocialError(e, provider: 'Google'));
    } catch (e, st) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('Google giriş hatası (beklenmeyen): $e\n$st');
      TopAlert.show(context, message: 'Google ile giriş yapılamadı.');
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
      if (!mounted) return;
      if (kDebugMode) debugPrint('Apple giriş hatası: code=${e.code}, message=${e.message}');
      TopAlert.show(context, message: _mapSocialError(e, provider: 'Apple'));
    } catch (e, st) {
      if (!mounted) return;
      if (kDebugMode) debugPrint('Apple giriş hatası (beklenmeyen): $e\n$st');
      TopAlert.show(context, message: 'Apple ile giriş yapılamadı.');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ForgotPasswordPage(initialEmail: _emailController.text.trim()),
      ),
    );
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AnaEkran()),
      (route) => false,
    );
  }

  String _mapLoginError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email veya şifre hatalı.';
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptın. Lütfen daha sonra tekrar dene.';
      default:
        return 'Giriş işlemi başarısız oldu.';
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
            final panelTop = screenHeight * 0.30;
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
                  left: 26 * scale,
                  top: topPadding + (16 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Text(
                        "Öğrenci Asistanı'na Hoşgeldin",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.58),
                          fontSize: 14 * scale,
                        ),
                      ),
                    ],
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
                          'Giriş Yap',
                          style: TextStyle(
                            color: const Color(0xFF00184B),
                            fontSize: 22 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 18 * scale),
                        _AuthField(
                          controller: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          height: 56,
                        ),
                        SizedBox(height: 12 * scale),
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
                        SizedBox(height: 2 * scale),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isAnyLoading ? null : _forgotPassword,
                            child: Text(
                              'Şifremi Unuttum',
                              style: TextStyle(
                                color: const Color(0xFF001BD8),
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6 * scale),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isAnyLoading ? null : _loginWithEmail,
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
                                    'Giriş Yap',
                                    style: TextStyle(
                                      fontSize: 17 * scale,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 18 * scale),
                        const _AuthDivider(),
                        SizedBox(height: 16 * scale),
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
                        SizedBox(height: 14 * scale),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Henüz hesabın yok mu? ',
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
                                            builder: (_) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                child: Text(
                                  'Kayıt ol',
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
                Positioned(
                  right: 14 * scale,
                  top: panelTop - (78 * scale),
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/CheckList.png',
                      width: (140 * scale).clamp(112.0, 152.0),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
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