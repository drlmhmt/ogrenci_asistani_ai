import 'package:flutter/material.dart';

/// Uygulama geneli [ThemeData]; [ThemeMode] ile açık/koyu seçilir.
abstract final class AppThemes {
  static const _primary = Color(0xFF0D6EFD);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F7FA),
        foregroundColor: Color(0xFF1B2433),
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(backgroundColor: scheme.surface),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF061022),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF061022),
        foregroundColor: Color(0xFFE6EDFF),
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF151C29)),
    );
  }
}
