import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/top_alert.dart'; // TopAlert dosyanın yolu
import 'ana_ekran.dart';
import 'login_page.dart';
import 'reset_password_page.dart';

enum MailVerificationFlow { registerEmail, passwordReset }

class MailVerificationPage extends StatefulWidget {
  const MailVerificationPage({
    super.key,
    required this.email,
    required this.flow,
  });

  final String email;
  final MailVerificationFlow flow;

  @override
  State<MailVerificationPage> createState() => _MailVerificationPageState();
}

class _MailVerificationPageState extends State<MailVerificationPage>
    with WidgetsBindingObserver {
  final _authService = AuthService();
  final _appLinks = AppLinks();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenDeepLink();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerification(isManual: false);
    }
  }

  void _listenDeepLink() {
    _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri);
    });
  }

  Future<void> _handleLink(Uri uri) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      if (widget.flow == MailVerificationFlow.passwordReset) {
        final code = uri.queryParameters['oobCode'];
        if (code != null && code.isNotEmpty) {
          await _authService.verifyPasswordResetCode(code);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordPage(
                oobCode: code,
                email: widget.email,
              ),
            ),
          );
        }
      } else {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified == true) {
          _goToHome();
        }
      }
    } catch (e) {
      TopAlert.show(context, message: 'Link geçersiz veya süresi dolmuş.', type: TopAlertType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkVerification({bool isManual = true}) async {
    if (widget.flow != MailVerificationFlow.registerEmail) return;
    
    if (isManual) setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == true) {
        _goToHome();
      } else if (isManual) {
        // SnackBar yerine TopAlert kullanımı
        TopAlert.show(
          context, 
          message: 'Henüz doğrulanmamış. Lütfen mailinizdeki linke tıklayın.',
          type: TopAlertType.warning
        );
      }
    } catch (e) {
      if (isManual) {
        TopAlert.show(context, message: 'Doğrulama durumu kontrol edilemedi.', type: TopAlertType.error);
      }
    } finally {
      if (mounted && isManual) setState(() => _isLoading = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    try {
      if (widget.flow == MailVerificationFlow.registerEmail) {
        await _authService.sendVerificationEmail();
      } else {
        await _authService.sendPasswordResetEmail(widget.email);
      }
      if (!mounted) return;
      
      // Başarı mesajı için TopAlert
      TopAlert.show(
        context, 
        message: 'Mail tekrar gönderildi. Lütfen kutunuza bakın.', 
        type: TopAlertType.success
      );

    } on FirebaseAuthException catch (e) {
      TopAlert.show(context, message: _mapError(e), type: TopAlertType.error);
    } finally {
      if (mounted) setState(() => _isResending = false);
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

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen biraz bekle.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      default:
        return 'Bir hata oluştu, tekrar dene.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.flow == MailVerificationFlow.registerEmail;

    return Scaffold(
      backgroundColor: const Color(0xFF00184B),
      body: Stack(
        children: [
          // Arka plan dekoratif daireler
          Positioned(top: -56, right: -30, child: _buildCircle(188, 0.36)),
          Positioned(bottom: 120, left: -55, child: _buildCircle(174, 0.20)),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 48),
                  
                  Center(
                    child: Column(
                      children: [
                        _buildEmailIcon(),
                        const SizedBox(height: 28),
                        Text(
                          isRegister ? 'Maili Doğrula' : 'Şifreni Sıfırla',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isRegister
                              ? 'Doğrulama maili gönderildi.\nMailindeki bağlantıya tıkla, uygulama\notomatik olarak devam edecek.'
                              : 'Şifre sıfırlama maili gönderildi.\nMailindeki bağlantıya tıkla, uygulama\notomatik olarak devam edecek.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            color: Color(0xFF45A2FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  
                  // "Doğruladım" Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _checkVerification(isManual: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF111315),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Doğruladım',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResendSection(),
                  const SizedBox(height: 8),
                  _buildLoginRedirect(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Builder Metodları ---
  Widget _buildCircle(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [const Color(0xFF5A84D9).withValues(alpha: alpha), Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
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
          onTap: () => Navigator.maybePop(context),
          child: const SizedBox(
            width: 42,
            height: 42,
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
      ),
      child: const Icon(Icons.mark_email_unread_outlined, color: Colors.white, size: 38),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          Text(
            'Mail gelmediyse',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 14),
          ),
          TextButton(
            onPressed: _isResending ? null : _resend,
            child: _isResending
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Yeniden Gönder',
                    style: TextStyle(color: Color(0xFF45A2FF), fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        child: Text(
          'Giriş sayfasına dön',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
        ),
      ),
    );
  }
}