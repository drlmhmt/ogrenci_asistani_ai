import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../theme/profile_palette.dart';
import '../../theme/theme_controller_scope.dart';
import '../../utils/display_name.dart';
import '../premium_paywall_page.dart';
import 'profile_personal_info_page.dart';
import 'profile_security_page.dart';

/// Profil ekranı — Figma (node 2474-4997) renk ve tipografi değerleri.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _inAppNotifications = true;
  bool _emailNewsletter = false;

  PackageInfo? _packageInfo;

  static const _primary = Color(0xFF0D6EFD);
  static const _destructive = Color(0xFFFFB4AB);

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final p = ProfilePalette.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const tabBarHeight = 76.0;
    final scrollBottomPadding = 28 + tabBarHeight + bottomInset + 14;

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, scrollBottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(p),
              const SizedBox(height: 40),
              _buildPremiumCard(context, p),
              const SizedBox(height: 40),
              _buildSettingsSections(context, p),
              const SizedBox(height: 40),
              _buildFooter(p),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProfilePalette p) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, authSnap) {
        final u = authSnap.data ?? user;
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(u.uid).snapshots(),
          builder: (context, docSnap) {
            final fs = docSnap.data?.data();
            final fsName = fs?['displayName'] as String?;
            final displayName = (fsName != null && fsName.trim().isNotEmpty)
                ? fsName.trim()
                : displayNameFromUser(u);

            return Column(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0D6EFD), Color(0xFF34466D)],
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.4),
                          child: Container(
                            color: p.avatarPlaceholder,
                            child: Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: p.textPrimary.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          width: 23,
                          height: 22.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB1C5FF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Color(0xFF002C70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: ProfileTypography.jakarta(p, 24, FontWeight.w800, height: 32, letterSpacing: -0.6),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumCard(BuildContext context, ProfilePalette p) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0D6EFD), Color(0xFF232A38)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.diamond_outlined,
                size: 120,
                color: p.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    'PREMIUM ÜYELİK',
                    style: ProfileTypography.manrope(10, FontWeight.w700, Colors.white, height: 15).copyWith(
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Yapay Zekayı Serbest Bırakın',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 28 / 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tüm ders özetleri ve kişiselleştirilmiş AI asistanına sınırsız erişim sağlayın.',
                  style: ProfileTypography.manrope(14, FontWeight.w400, const Color(0xCCDBEAFE), height: 20),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _primary,
                    elevation: 0,
                    padding: const EdgeInsets.fromLTRB(24, 13, 24, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PremiumPaywallPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Şimdi Yükselt',
                    style: ProfileTypography.manrope(14, FontWeight.w700, _primary, height: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSections(BuildContext context, ProfilePalette p) {
    final themeController = ThemeControllerScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel(p, 'HESAP'),
        const SizedBox(height: 16),
        _surfaceCard(
          p,
          radius: 32,
          child: Column(
            children: [
              _navTile(
                p,
                icon: Icons.person_outline_rounded,
                iconColor: p.iconAccent,
                label: 'Kişisel Bilgiler',
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfilePersonalInfoPage(),
                    ),
                  );
                },
              ),
              Divider(height: 1, thickness: 1, color: p.divider),
              _navTile(
                p,
                icon: Icons.shield_outlined,
                iconColor: p.iconAccent,
                label: 'Şifre ve Güvenlik',
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileSecurityPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _sectionLabel(p, 'BİLDİRİMLER'),
        const SizedBox(height: 16),
        _surfaceCard(
          p,
          radius: 32,
          child: Column(
            children: [
              _toggleTile(
                p,
                icon: Icons.notifications_none_rounded,
                iconColor: p.iconAccent2,
                label: 'Uygulama İçi Bildirimler',
                value: _inAppNotifications,
                onChanged: (v) => setState(() => _inAppNotifications = v),
              ),
              Divider(height: 1, thickness: 1, color: p.divider),
              _toggleTile(
                p,
                icon: Icons.mail_outline_rounded,
                iconColor: p.iconAccent2,
                label: 'E-posta Bülteni',
                value: _emailNewsletter,
                onChanged: (v) => setState(() => _emailNewsletter = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _sectionLabel(p, 'UYGULAMA TERCİHLERİ'),
        const SizedBox(height: 16),
        _surfaceCard(
          p,
          radius: 32,
          child: Column(
            children: [
              _toggleTile(
                p,
                icon: Icons.dark_mode_outlined,
                iconColor: p.iconGlobe,
                label: 'Karanlık Mod',
                value: themeController.isDarkMode,
                onChanged: (v) => themeController.setDarkMode(v),
              ),
              Divider(height: 1, thickness: 1, color: p.divider),
              _languageTile(context, p),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _sectionLabel(p, 'DESTEK'),
        const SizedBox(height: 16),
        _surfaceCard(
          p,
          radius: 48,
          child: Column(
            children: [
              _navTile(
                p,
                icon: Icons.help_outline_rounded,
                iconColor: p.textMuted,
                label: 'Yardım Merkezi',
                onTap: () {},
              ),
              Divider(height: 1, thickness: 1, color: p.divider),
              _navTile(
                p,
                icon: Icons.feedback_outlined,
                iconColor: p.textMuted,
                label: 'Geri Bildirim Gönder',
                onTap: () {},
              ),
              Divider(height: 1, thickness: 1, color: p.divider),
              _logoutTile(context, p),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(ProfilePalette p, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: ProfileTypography.manrope(12, FontWeight.w700, p.textMuted, height: 16).copyWith(
          letterSpacing: 2.4,
        ),
      ),
    );
  }

  Widget _surfaceCard(ProfilePalette p, {required double radius, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: p.isDark ? 0.05 : 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _navTile(
    ProfilePalette p, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: ProfileTypography.manrope(14, FontWeight.w600, p.textPrimary, height: 20),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: p.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleTile(
    ProfilePalette p, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: ProfileTypography.manrope(14, FontWeight.w600, p.textPrimary, height: 20),
            ),
          ),
          _figmaSwitch(p, value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _figmaSwitch(
    ProfilePalette p, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return p.toggleOffThumb;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _primary;
            return p.toggleOffTrack;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _languageTile(BuildContext context, ProfilePalette p) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLanguageSheet(context, p),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.language_rounded, size: 20, color: p.iconGlobe),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Dil Seçimi',
                  style: ProfileTypography.manrope(14, FontWeight.w600, p.textPrimary, height: 20),
                ),
              ),
              Text(
                'Türkçe',
                style: ProfileTypography.manrope(12, FontWeight.w400, p.textMuted, height: 16),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: p.textMuted, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, ProfilePalette p) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Türkçe', style: ProfileTypography.manrope(16, FontWeight.w600, p.textPrimary, height: 22)),
                  trailing: const Icon(Icons.check_rounded, color: _primary),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  title: Text('English', style: ProfileTypography.manrope(16, FontWeight.w500, p.textMuted, height: 22)),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _logoutTile(BuildContext context, ProfilePalette p) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final go = await showDialog<bool>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor: p.surface,
                title: Text('Oturumu kapat', style: ProfileTypography.jakarta(p, 18, FontWeight.w700)),
                content: Text(
                  'Çıkış yapmak istediğinize emin misiniz?',
                  style: ProfileTypography.manrope(14, FontWeight.w500, p.textMuted, height: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('İptal', style: ProfileTypography.manrope(14, FontWeight.w600, p.textMuted, height: 20)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('Çıkış', style: ProfileTypography.manrope(14, FontWeight.w700, _destructive, height: 20)),
                  ),
                ],
              );
            },
          );
          if (go == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Oturum kapatma yakında bağlanacak.')),
            );
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 18, color: _destructive),
              const SizedBox(width: 16),
              Text(
                'Oturumu Kapat',
                style: ProfileTypography.manrope(14, FontWeight.w700, _destructive, height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ProfilePalette p) {
    final muted = p.textMuted.withValues(alpha: 0.5);
    final small = GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      height: 15 / 10,
      letterSpacing: 1,
      color: muted,
    );
    final versionLine = _packageInfo == null
        ? '…'
        : 'VERSİYON ${_packageInfo!.version} (BUILD ${_packageInfo!.buildNumber})';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 32),
      child: Column(
        children: [
          Text(versionLine, textAlign: TextAlign.center, style: small),
          const SizedBox(height: 8),
          Text('© 2024 ZEKA KATMANI INC.', textAlign: TextAlign.center, style: small),
        ],
      ),
    );
  }
}
