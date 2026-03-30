import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/profile_palette.dart';
import '../../widgets/top_alert.dart';
import '../forgot_password_page.dart';

/// Şifre ve güvenlik — e-posta hesapları için şifre değişimi, sıfırlama bağlantısı.
class ProfileSecurityPage extends StatefulWidget {
  const ProfileSecurityPage({super.key});

  @override
  State<ProfileSecurityPage> createState() => _ProfileSecurityPageState();
}

class _ProfileSecurityPageState extends State<ProfileSecurityPage> {
  final _authService = AuthService();
  final _current = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _newPass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _hasPasswordProvider(User user) {
    return user.providerData.any((p) => p.providerId == 'password');
  }

  Future<void> _updatePassword() async {
    final cur = _current.text;
    final nw = _newPass.text;
    final cf = _confirm.text;
    if (nw.length < 6) {
      TopAlert.show(context, message: 'Yeni şifre en az 6 karakter olmalı.', type: TopAlertType.warning);
      return;
    }
    if (nw != cf) {
      TopAlert.show(context, message: 'Yeni şifreler eşleşmiyor.', type: TopAlertType.warning);
      return;
    }
    setState(() => _saving = true);
    try {
      await _authService.updatePassword(currentPassword: cur, newPassword: nw);
      if (!mounted) return;
      _current.clear();
      _newPass.clear();
      _confirm.clear();
      TopAlert.show(context, message: 'Şifreniz güncellendi.', type: TopAlertType.success);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      TopAlert.show(context, message: _mapPwdError(e), type: TopAlertType.error);
    } catch (_) {
      if (!mounted) return;
      TopAlert.show(context, message: 'İşlem tamamlanamadı.', type: TopAlertType.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _mapPwdError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Mevcut şifre hatalı.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'requires-recent-login':
        return 'Güvenlik için çıkış yapıp tekrar giriş yapın.';
      default:
        return e.message ?? 'Şifre güncellenemedi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ProfilePalette.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.textPrimary,
        elevation: 0,
        title: Text(
          'Şifre ve Güvenlik',
          style: ProfileTypography.jakarta(p, 18, FontWeight.w700, height: 24),
        ),
      ),
      body: user == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _hasPasswordProvider(user)
                  ? _buildEmailPasswordForm(p, user)
                  : _buildSocialOnly(p, user),
            ),
    );
  }

  Widget _buildSocialOnly(ProfilePalette p, User user) {
    final providers = user.providerData.map((e) => e.providerId).toList();
    final labels = <String>[];
    if (providers.contains('google.com')) labels.add('Google');
    if (providers.contains('apple.com')) labels.add('Apple');
    final joined = labels.isEmpty ? 'sosyal hesap' : labels.join(' ve ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: p.isDark ? 0.05 : 0.06),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline_rounded, color: p.iconAccent, size: 28),
              const SizedBox(height: 12),
              Text(
                'Hesabın $joined ile bağlı.',
                style: ProfileTypography.manrope(16, FontWeight.w600, p.textPrimary, height: 22),
              ),
              const SizedBox(height: 8),
              Text(
                'Şifre bu giriş yöntemi için kullanılmaz. Güvenlik ayarlarını ilgili sağlayıcı üzerinden yönetebilirsin.',
                style: ProfileTypography.manrope(14, FontWeight.w500, p.textMuted, height: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailPasswordForm(ProfilePalette p, User user) {
    final email = user.email ?? '';

    Widget field({
      required TextEditingController controller,
      required String label,
      required bool obscure,
      required VoidCallback toggle,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: p.isDark ? 0.05 : 0.06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: ProfileTypography.manrope(15, FontWeight.w600, p.textPrimary, height: 22),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: ProfileTypography.manrope(13, FontWeight.w500, p.textMuted, height: 18),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: p.textMuted),
              onPressed: toggle,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (email.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              email,
              style: ProfileTypography.manrope(13, FontWeight.w500, p.textMuted, height: 18),
            ),
          ),
        field(
          controller: _current,
          label: 'Mevcut şifre',
          obscure: _obscureCurrent,
          toggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
        ),
        field(
          controller: _newPass,
          label: 'Yeni şifre',
          obscure: _obscureNew,
          toggle: () => setState(() => _obscureNew = !_obscureNew),
        ),
        field(
          controller: _confirm,
          label: 'Yeni şifre (tekrar)',
          obscure: _obscureConfirm,
          toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _saving ? null : _updatePassword,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EFD),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          child: _saving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  'Şifreyi güncelle',
                  style: ProfileTypography.manrope(16, FontWeight.w700, Colors.white, height: 22),
                ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: email.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ForgotPasswordPage(initialEmail: email),
                    ),
                  );
                },
          child: Text(
            'Şifremi unuttum — sıfırlama e-postası gönder',
            textAlign: TextAlign.center,
            style: ProfileTypography.manrope(14, FontWeight.w600, const Color(0xFF0D6EFD), height: 20),
          ),
        ),
      ],
    );
  }
}
