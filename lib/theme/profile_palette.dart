import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Profil ve alt sayfalar için Figma uyumlu renkler.
class ProfilePalette {
  const ProfilePalette._({
    required this.bg,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.divider,
    required this.iconAccent,
    required this.iconAccent2,
    required this.toggleOffTrack,
    required this.toggleOffThumb,
    required this.avatarPlaceholder,
    required this.iconGlobe,
    required this.isDark,
  });

  final Color bg;
  final Color surface;
  final Color textPrimary;
  final Color textMuted;
  final Color divider;
  final Color iconAccent;
  final Color iconAccent2;
  final Color toggleOffTrack;
  final Color toggleOffThumb;
  final Color avatarPlaceholder;
  final Color iconGlobe;
  final bool isDark;

  static ProfilePalette of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? ProfilePalette.dark : ProfilePalette.light;
  }

  static const dark = ProfilePalette._(
    bg: Color(0xFF0D1321),
    surface: Color(0xFF151C29),
    textPrimary: Color(0xFFDCE2F5),
    textMuted: Color(0xFFC2C6D8),
    divider: Color.fromRGBO(66, 70, 85, 0.1),
    iconAccent: Color(0xFFB1C5FF),
    iconAccent2: Color(0xFFA9C7FF),
    toggleOffTrack: Color(0xFF2E3543),
    toggleOffThumb: Color(0xFFC2C6D8),
    avatarPlaceholder: Color(0xFF1E293B),
    iconGlobe: Color(0xFFB4C6F4),
    isDark: true,
  );

  static const light = ProfilePalette._(
    bg: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1B2433),
    textMuted: Color(0xFF64748B),
    divider: Color.fromRGBO(15, 23, 42, 0.08),
    iconAccent: Color(0xFF2563EB),
    iconAccent2: Color(0xFF3B82F6),
    toggleOffTrack: Color(0xFFE2E8F0),
    toggleOffThumb: Color(0xFF94A3B8),
    avatarPlaceholder: Color(0xFFE2E8F0),
    iconGlobe: Color(0xFF2563EB),
    isDark: false,
  );
}

class ProfileTypography {
  static TextStyle jakarta(
    ProfilePalette p,
    double size,
    FontWeight w, {
    double height = 1.2,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: w,
      height: height / size,
      letterSpacing: letterSpacing,
      color: p.textPrimary,
    );
  }

  static TextStyle manrope(double size, FontWeight w, Color color, {double height = 1.2}) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: w,
      height: height / size,
      color: color,
    );
  }
}
