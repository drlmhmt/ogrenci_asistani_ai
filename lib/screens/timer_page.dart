import 'dart:async';

import 'package:flutter/material.dart';

import 'main_tab_scaffold.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

enum _Mode { deep, pomodoro, breakTime }

class _TimerPageState extends State<TimerPage> {
  final _modes = const {
    _Mode.deep: ('Derin Çalışma', 'Kesintisiz 50 dakika odaklanma', Icons.bolt_rounded, Color(0xFF6C63FF)),
    _Mode.pomodoro: ('Pomodoro', '25 dk + 5 dk mola', Icons.timer_outlined, Color(0xFFFF8A5B)),
    _Mode.breakTime: ('Kısa Mola', '5-10 dakika nefes al', Icons.free_breakfast_outlined, Color(0xFF18C29C)),
  };

  _Mode _selected = _Mode.deep;
  Timer? _timer;
  DateTime? _endsAt;
  Duration _remaining = const Duration(minutes: 45);
  double _configuredMinutes = 45;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _select(_selected);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _select(_Mode mode) {
    const defaults = {_Mode.deep: 45, _Mode.pomodoro: 25, _Mode.breakTime: 10};
    _timer?.cancel();
    setState(() {
      _selected = mode;
      _configuredMinutes = defaults[mode]!.toDouble();
      _remaining = Duration(minutes: defaults[mode]!);
      _running = false;
      _endsAt = null;
    });
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() {
        _running = false;
        _endsAt = null;
      });
      return;
    }
    if (_remaining <= Duration.zero) {
      _remaining = Duration(minutes: _configuredMinutes.round());
    }
    _endsAt = DateTime.now().add(_remaining);
    _running = true;
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final end = _endsAt;
      if (end == null) return;
      final diff = end.difference(DateTime.now());
      final secondsLeft = (diff.inMilliseconds / 1000).ceil();
      if (secondsLeft <= 0) {
        _timer?.cancel();
        if (!mounted) return;
        setState(() {
          _remaining = Duration.zero;
          _running = false;
          _endsAt = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Oturum tamamlandı.'),
          ),
        );
        return;
      }
      if (!mounted) return;
      setState(() => _remaining = Duration(seconds: secondsLeft));
    });
    setState(() {});
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remaining = Duration(minutes: _configuredMinutes.round());
      _running = false;
      _endsAt = null;
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainTabScaffold()),
    );
  }

  void _showTapFeedback(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        content: Text('$label butonu etkin.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final mm = _remaining.inMinutes.toString().padLeft(2, '0');
    final ss = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFF081224),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1A32), Color(0xFF091225), Color(0xFF060C17)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                child: Row(
                  children: [
                    _TopIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: _goHome,
                    ),
                    const Expanded(
                      child: Text(
                        'Zamanlayıcı',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFEAF1FF),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 24 + bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _QuoteCard(),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Çalışma Modu',
                          style: TextStyle(
                            color: Color(0xFFE5ECFB),
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ModeCard(
                        title: _modes[_Mode.deep]!.$1,
                        subtitle: _modes[_Mode.deep]!.$2,
                        icon: _modes[_Mode.deep]!.$3,
                        color: _modes[_Mode.deep]!.$4,
                        selected: _selected == _Mode.deep,
                        onTap: () => _select(_Mode.deep),
                        large: true,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ModeCard(
                              title: _modes[_Mode.pomodoro]!.$1,
                              subtitle: _modes[_Mode.pomodoro]!.$2,
                              icon: _modes[_Mode.pomodoro]!.$3,
                              color: _modes[_Mode.pomodoro]!.$4,
                              selected: _selected == _Mode.pomodoro,
                              onTap: () => _select(_Mode.pomodoro),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ModeCard(
                              title: _modes[_Mode.breakTime]!.$1,
                              subtitle: _modes[_Mode.breakTime]!.$2,
                              icon: _modes[_Mode.breakTime]!.$3,
                              color: _modes[_Mode.breakTime]!.$4,
                              selected: _selected == _Mode.breakTime,
                              onTap: () => _select(_Mode.breakTime),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      _TimerCard(
                        minutes: _configuredMinutes,
                        mm: mm,
                        ss: ss,
                        running: _running,
                        onChanged: (v) => setState(() {
                          _configuredMinutes = v.roundToDouble();
                          _remaining = Duration(minutes: v.round());
                        }),
                      ),
                      const SizedBox(height: 18),
                      _ActionButton(
                        label: _running ? 'Odağı Duraklat' : 'Odağı Başlat',
                        icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        colors: const [Color(0xFFB59CFF), Color(0xFF6B63FF)],
                        border: null,
                        shadowColor: const Color(0xFF6B63FF),
                        onTap: _toggle,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          _running
                              ? 'Zamanlayıcı çalışıyor. Dilersen duraklatabilirsin.'
                              : 'Oturum başladığında "Rahatsız Etme" modunu açman önerilir.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF53617D), fontSize: 10),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ActionButton(
                        label: 'Sıfırla',
                        icon: Icons.restart_alt_rounded,
                        colors: const [Color(0xFF243554), Color(0xFF16223A)],
                        border: Border.all(color: const Color(0xFF31456F)),
                        shadowColor: null,
                        onTap: _reset,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(colors: [Color(0xFF202B44), Color(0xFF131C2F)]),
            border: Border.all(color: const Color(0xFF33425E)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFFE3EBFF), size: 16),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(colors: [Color(0xFF151F35), Color(0xFF0B1324)]),
        border: Border.all(color: const Color(0xFF6177A7).withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            left: -14,
            child: _orb(88, const Color(0xFF8196FF).withValues(alpha: 0.07)),
          ),
          Positioned(
            right: -18,
            bottom: -20,
            child: _orb(108, const Color(0xFF243D70).withValues(alpha: 0.14)),
          ),
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GÜNLÜK İLHAM',
                      style: TextStyle(color: Color(0xFF91A2C5), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '"Gelecek, bugünden\nona hazırlananlara\naittir."',
                      style: TextStyle(color: Color(0xFFF1F5FF), fontSize: 18, height: 1.28, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 10),
                    Text('- Malcolm X', style: TextStyle(color: Color(0xFF6E7A93), fontSize: 11)),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _FutureIllustration(),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.minutes,
    required this.mm,
    required this.ss,
    required this.running,
    required this.onChanged,
  });

  final double minutes;
  final String mm;
  final String ss;
  final bool running;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFF1B2640), Color(0xFF121A2D)]),
        border: Border.all(color: const Color(0xFF536895).withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -12,
            child: _orb(104, const Color(0xFF7A70FF).withValues(alpha: 0.10)),
          ),
          Column(
            children: [
              const Text(
                'SÜRE AYARLA',
                style: TextStyle(color: Color(0xFF6F7D97), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: mm, style: const TextStyle(color: Color(0xFFF3F6FF), fontSize: 66, fontWeight: FontWeight.w800)),
                    const TextSpan(text: ' : ', style: TextStyle(color: Color(0xFFAAB7D3), fontSize: 52, fontWeight: FontWeight.w700)),
                    TextSpan(text: ss, style: const TextStyle(color: Color(0xFF9EADC9), fontSize: 52, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('Dakika', style: TextStyle(color: Color(0xFF9AA8C7), fontSize: 13)),
              const SizedBox(height: 18),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  thumbColor: const Color(0xFFF4F7FF),
                  overlayColor: const Color(0xFFB59CFF),
                  activeTrackColor: const Color(0xFFD0D9FF),
                  inactiveTrackColor: const Color(0xFF344059),
                ),
                child: Slider(
                  value: minutes,
                  min: 5,
                  max: 90,
                  divisions: 17,
                  onChanged: running ? null : onChanged,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) {
                  const labels = ['5 DK', '30 DK', '60 DK', '90 DK'];
                  const values = [5, 30, 60, 90];
                  final active = minutes.round() == values[i];
                  return Text(
                    labels[i],
                    style: TextStyle(
                      color: active ? const Color(0xFFE0E7FF) : const Color(0xFF57647D),
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.large = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool large;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.fromLTRB(large ? 18 : 16, 16, 14, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: selected
                  ? [color, Color.lerp(color, Colors.black, 0.35)!]
                  : const [Color(0xFF151E32), Color(0xFF101726)],
            ),
            border: Border.all(color: selected ? Colors.white.withValues(alpha: 0.22) : const Color(0xFF1B263C)),
            boxShadow: selected
                ? [BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 20, offset: const Offset(0, 12))]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!large)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Icon(icon, color: const Color(0xFFF2F5FF), size: 16),
                ),
              if (!large) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(color: Colors.white, fontSize: large ? 24 : 15, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: selected ? 0.78 : 0.58), fontSize: 11)),
                      ],
                    ),
                  ),
                  if (large)
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.14)),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.colors,
    required this.border,
    required this.shadowColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final BoxBorder? border;
  final Color? shadowColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(colors: colors),
          border: border,
          boxShadow: shadowColor == null
              ? null
              : [
                  BoxShadow(
                    color: shadowColor!.withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FutureIllustration extends StatelessWidget {
  const _FutureIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF293E67).withValues(alpha: 0.36),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 46,
              color: const Color(0xFFBED0FF),
              shadows: [
                Shadow(
                  color: const Color(0xFF6B63FF).withValues(alpha: 0.55),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 22,
            child: Container(
              width: 10,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFD36F), Color(0xFFFF8A5B)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 54,
            left: 12,
            child: _star(),
          ),
          Positioned(
            top: 36,
            right: 12,
            child: _star(small: true),
          ),
          Positioned(
            bottom: 18,
            right: 18,
            child: _star(small: true),
          ),
        ],
      ),
    );
  }

  Widget _star({bool small = false}) {
    return Icon(
      Icons.auto_awesome_rounded,
      size: small ? 12 : 16,
      color: const Color(0xFFE7EEFF),
    );
  }
}

Widget _orb(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
