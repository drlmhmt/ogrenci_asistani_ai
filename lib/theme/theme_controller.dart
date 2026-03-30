import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeModeKey = 'app_theme_mode';

/// Karanlık / açık tema tercihini tutar ve [SharedPreferences] ile kalıcı saklar.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final raw = _prefs.getString(_kThemeModeKey);
    _themeMode = switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark,
    };
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode != ThemeMode.light && mode != ThemeMode.dark) return;
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString(
      _kThemeModeKey,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
    notifyListeners();
  }

  /// Profil anahtarı: açık = karanlık tema.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setDarkMode(bool dark) =>
      setThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
}
