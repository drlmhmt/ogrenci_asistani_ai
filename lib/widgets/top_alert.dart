import 'package:flutter/material.dart';

enum TopAlertType { success, warning, error, info }

class TopAlert {
  static void show(
    BuildContext context, {
    required String message,
    TopAlertType type = TopAlertType.info,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _colorFor(type),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Color _colorFor(TopAlertType type) {
    switch (type) {
      case TopAlertType.success:
        return const Color(0xFF166534);
      case TopAlertType.warning:
        return const Color(0xFFB45309);
      case TopAlertType.error:
        return const Color(0xFFB91C1C);
      case TopAlertType.info:
        return const Color(0xFF1D4ED8);
    }
  }
}
