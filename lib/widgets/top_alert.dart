import 'dart:async';
import 'package:flutter/material.dart';

enum TopAlertType { error, warning, success }

/// Üstten çıkan, renkli, kapatılabilir mini alert.
/// UI'ları bozmamak için Overlay ile çalışır (SnackBar yerine).
class TopAlert {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    TopAlertType type = TopAlertType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    hide();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final (bg, border, icon) = _theme(type);

    _entry = OverlayEntry(
      builder: (_) => _TopAlertView(
        message: message,
        background: bg,
        border: border,
        icon: icon,
      ),
    );

    overlay.insert(_entry!);
    _timer = Timer(duration, hide);
  }

static void hide() {
    _timer?.cancel();
    _timer = null;
    if (_entry != null) {
      _entry!.remove(); // Sadece entry null değilse kaldır
      _entry = null;
    }
  }

  static (Color, Color, IconData) _theme(TopAlertType type) {
    switch (type) {
      case TopAlertType.success:
        return (
          const Color(0xFF1E5BFF), // mavi
          const Color(0xFF9DB8FF),
          Icons.check_circle
        );
      case TopAlertType.warning:
        return (
          const Color(0xFFFFC107), // sarı
          const Color(0xFFFFE082),
          Icons.warning_rounded
        );
      case TopAlertType.error:
      default:
        return (
          const Color(0xFFE53935), // kırmızı
          const Color(0xFFFFCDD2),
          Icons.error_rounded
        );
    }
  }
}

class _TopAlertView extends StatefulWidget {
  const _TopAlertView({
    required this.message,
    required this.background,
    required this.border,
    required this.icon,
  });

  final String message;
  final Color background;
  final Color border;
  final IconData icon;

  @override
  State<_TopAlertView> createState() => _TopAlertViewState();
}

class _TopAlertViewState extends State<_TopAlertView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();

  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, -1),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Positioned(
      left: 14,
      right: 14,
      top: top + 10,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: widget.background.withOpacity(0.92),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.border.withOpacity(0.9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: TopAlert.hide,
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}