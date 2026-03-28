import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _dailyProgress = 0.67;
  int _selectedDayIndex = 2;

  @override
  Widget build(BuildContext context) {
    const background = _HomeBackground();
    final weekDays = _buildWeekDays(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF061022),
      body: Stack(
        children: [
          background,
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(
                    title: 'The Atelier',
                    onNotificationsTap: () {},
                  ),
                  const SizedBox(height: 26),
                  Text(
                    _formatHeaderDate(DateTime.now()),
                    style: const TextStyle(
                      color: Color(0xFF9AA8C7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Today, 2 Math topics\nare waiting for you",
                    style: TextStyle(
                      color: Color(0xFFE6EDFF),
                      fontSize: 34,
                      height: 1.08,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"Progress is quiet, but steady."',
                    style: TextStyle(
                      color: Color(0xFF9FB0D5),
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _DailyProgressCard(
                    progress: _dailyProgress,
                    studyTimeLabel: '4h 20m',
                    completedLabel: '8/12',
                    solvedLabel: '45',
                    onStartTap: () {},
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your Week',
                          style: TextStyle(
                            color: Color(0xFFE6EDFF),
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      _WeekBadge(
                        label: 'WEEK ${_weekNumber(DateTime.now())}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(weekDays.length, (index) {
                      final day = weekDays[index];
                      return _WeekDayItem(
                        day: day,
                        selected: index == _selectedDayIndex,
                        onTap: () => setState(() => _selectedDayIndex = index),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B1E3A),
            Color(0xFF07122A),
            Color(0xFF061022),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Container(),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onNotificationsTap,
  });

  final String title;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _withAlpha(const Color(0xFF273D66), 0.6)),
            boxShadow: [
              BoxShadow(
                color: _withAlpha(Colors.black, 0.22),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0B1E3A),
            backgroundImage: AssetImage('assets/Logo.png'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFBFD0FF),
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
        ),
        InkResponse(
          onTap: onNotificationsTap,
          radius: 28,
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 28,
            color: Color(0xFFC9D4FF),
          ),
        ),
      ],
    );
  }
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    required this.progress,
    required this.studyTimeLabel,
    required this.completedLabel,
    required this.solvedLabel,
    required this.onStartTap,
  });

  final double progress;
  final String studyTimeLabel;
  final String completedLabel;
  final String solvedLabel;
  final VoidCallback onStartTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _withAlpha(const Color(0xFF2A3C63), 0.62),
                  _withAlpha(const Color(0xFF0D1B34), 0.78),
                ],
              ),
              border: Border.all(
                color: _withAlpha(const Color(0xFF7C93C8), 0.12),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: _withAlpha(Colors.black, 0.38),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: const SizedBox(height: 270),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _withAlpha(Colors.white, 0.08),
                    Colors.transparent,
                    _withAlpha(Colors.black, 0.06),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DAILY PROGRESS',
                            style: TextStyle(
                              color: Color(0xFFB6C3E4),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Color(0xFFE6EDFF),
                                  fontSize: 54,
                                  height: 0.95,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.4,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Color(0xFFB6C3E4),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _withAlpha(const Color(0xFF9DB2FF), 0.22),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: _ProgressRing(
                        value: progress.clamp(0.0, 1.0).toDouble(),
                        size: 92,
                        strokeWidth: 10,
                        backgroundColor: _withAlpha(const Color(0xFF9DB2FF), 0.14),
                        gradient: const SweepGradient(
                          colors: [
                            Color(0xFFBFD0FF),
                            Color(0xFF9DB2FF),
                            Color(0xFFBFD0FF),
                          ],
                        ),
                        child: Image.asset(
                          'assets/stars.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          color: const Color(0xFFDBE3FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _Metric(
                        label: 'STUDYTIME',
                        value: studyTimeLabel,
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        label: 'COMPLETED',
                        value: completedLabel,
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        label: 'SOLVED',
                        value: solvedLabel,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _StartButton(
                  label: "Start Today's Plan",
                  onTap: onStartTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8FA2C9),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE6EDFF),
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB3C2FF),
              Color(0xFF738EDE),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _withAlpha(const Color(0xFF9DB2FF), 0.22),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF122D5F),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.size,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.gradient,
    required this.child,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Gradient gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ProgressRingPainter(
        value: value,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
        gradient: gradient,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(child: child),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.value,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.gradient,
  });

  final double value;
  final double strokeWidth;
  final Color backgroundColor;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, basePaint);

    if (value <= 0) return;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    const startAngle = -1.5707963267948966; // -pi / 2
    final sweepAngle = 6.283185307179586 * value; // 2pi
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient;
  }
}

class _WeekBadge extends StatelessWidget {
  const _WeekBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _withAlpha(const Color(0xFF0B1E3A), 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _withAlpha(const Color(0xFF93A8D8), 0.35),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFB6C3E4),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _WeekDayItem extends StatelessWidget {
  const _WeekDayItem({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final _WeekDay day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outer = selected
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8EA5FF),
              Color(0xFF2D3F6A),
            ],
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(1.4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: outer,
          border: selected
              ? null
              : Border.all(
                  color: _withAlpha(const Color(0xFF2D3F6A), 0.6),
                ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? _withAlpha(const Color(0xFF0F2244), 0.85)
                : _withAlpha(const Color(0xFF0B1E3A), 0.4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.shortName,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFE6EDFF)
                      : const Color(0xFF8FA2C9),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${day.dayOfMonth}',
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFE6EDFF)
                      : const Color(0xFF9FB0D5),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              if (selected) ...[
                const SizedBox(height: 6),
                Container(
                  width: 4.5,
                  height: 4.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6EDFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDay {
  const _WeekDay({
    required this.shortName,
    required this.date,
  });

  final String shortName;
  final DateTime date;

  int get dayOfMonth => date.day;
}

List<_WeekDay> _buildWeekDays(DateTime now) {
  final weekday = now.weekday; // 1 = Mon ... 7 = Sun
  final monday = now.subtract(Duration(days: weekday - DateTime.monday));
  const names = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  return List.generate(6, (index) {
    final date = monday.add(Duration(days: index));
    return _WeekDay(shortName: names[index], date: date);
  });
}

String _formatHeaderDate(DateTime date) {
  const months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];
  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

int _weekNumber(DateTime date) {
  // Simple ISO-ish week calculation (good enough for UI badge).
  final thursday = date.add(Duration(days: 4 - (date.weekday == 7 ? 7 : date.weekday)));
  final firstThursday = DateTime(thursday.year, 1, 4);
  final diff = thursday.difference(firstThursday);
  return 1 + (diff.inDays / 7).floor();
}

Color _withAlpha(Color color, double opacity) {
  return color.withValues(alpha: opacity);
}
