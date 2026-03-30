import 'package:flutter/material.dart';

import 'theme_controller.dart';

class ThemeControllerScope extends InheritedWidget {
  const ThemeControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ThemeController controller;

  /// Bağımlılık kurmaz; test veya üstte scope yoksa `null` döner.
  static ThemeController? maybeOf(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ThemeControllerScope>();
    return scope?.controller;
  }

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    if (scope == null) {
      throw FlutterError(
        'ThemeControllerScope bulunamadı. '
        'BilgiAIApp içinde MaterialApp, ThemeControllerScope ile sarılmalı.',
      );
    }
    return scope.controller;
  }

  @override
  bool updateShouldNotify(covariant ThemeControllerScope oldWidget) =>
      oldWidget.controller != controller;
}
