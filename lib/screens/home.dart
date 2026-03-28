import 'package:flutter/material.dart';

import 'add_question_page.dart';
import 'add_task_page.dart';
import 'exam_result_page.dart';
import 'full_analysis_page.dart';
import 'premium_paywall_page.dart';
import 'timer_page.dart';
import 'view_plan_page.dart';
import 'weak_topic_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _dailyProgress = 0.67;
  int _selectedDayIndex = 2;

  void _openQuickAction(_QuickActionType type) {
    Widget page;
    switch (type) {
      case _QuickActionType.addQuestion:
        page = const AddQuestionPage();
      case _QuickActionType.examResult:
        page = const ExamResultPage();
      case _QuickActionType.timer:
        page = const TimerPage();
      case _QuickActionType.addTask:
        page = const AddTaskPage();
      case _QuickActionType.viewPlan:
        page = const ViewPlanPage();
      case _QuickActionType.weakTopic:
        page = const WeakTopicPage();
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = _HomeBackground();
    final weekDays = _buildWeekDays(DateTime.now());
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const tabBarHeight = 90.0;
    final scrollBottomPadding = 28 + tabBarHeight + bottomInset + 14;

    return Scaffold(
      backgroundColor: const Color(0xFF061022),
      body: Stack(
        children: [
          background,
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 18, 24, scrollBottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(
                    title: 'Öğrenci Asistanı',
                    onPremiumTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PremiumPaywallPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Text(
                    _formatHeaderDate(DateTime.now()),
                    style: const TextStyle(
                      color: Color(0xFF9AA8C7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Bugün, 2 Matematik konusu\nseni bekliyor",
                    style: TextStyle(
                      color: Color(0xFFE6EDFF),
                      fontSize: 30,
                      height: 1.08,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"İlerleme sessizdir, ama istikrarlıdır."',
                    style: TextStyle(
                      color: Color(0xFF9FB0D5),
                      fontSize: 15,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _DailyProgressCard(
                    progress: _dailyProgress,
                    studyTimeLabel: '4s 20d',
                    completedLabel: '8/12',
                    solvedLabel: '45',
                    onStartTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ViewPlanPage()),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Bu Hafta',
                          style: TextStyle(
                            color: Color(0xFFE6EDFF),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      _WeekBadge(
                        label: 'HAFTA ${_weekNumber(DateTime.now())}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemSize = (constraints.maxWidth / weekDays.length)
                          .clamp(52.0, 64.0)
                          .toDouble();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(weekDays.length, (index) {
                          final day = weekDays[index];
                          return _WeekDayItem(
                            day: day,
                            size: itemSize,
                            selected: index == _selectedDayIndex,
                            onTap: () =>
                                setState(() => _selectedDayIndex = index),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _QuickActionsGrid(onTap: _openQuickAction),
                  const SizedBox(height: 24),
                  const _AiRecommendationCard(),
                  const SizedBox(height: 26),
                  const Text(
                    'Odak Alanları',
                    style: TextStyle(
                      color: Color(0xFFE6EDFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _FocusAreasRow(),
                  const SizedBox(height: 18),
                  const _StreakCard(
                    days: 5,
                    subtitle: 'Harikasın! Böyle devam.',
                  ),
                  const SizedBox(height: 14),
                  _LastExamSummaryCard(
                    onViewAnalysis: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FullAnalysisPage()),
                    ),
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
    required this.onPremiumTap,
  });

  final String title;
  final VoidCallback onPremiumTap;

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
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkResponse(
          onTap: onPremiumTap,
          radius: 28,
          child: const Icon(
            Icons.workspace_premium_outlined,
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
    return SizedBox(
      height: 270,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          fit: StackFit.expand,
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
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
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
                              'GÜNLÜK İLERLEME',
                              style: TextStyle(
                                color: Color(0xFFB6C3E4),
                                fontSize: 11,
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
                                    fontSize: 48,
                                    height: 0.95,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.4,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Text(
                                      'Bitti',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFFB6C3E4),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                              color: _withAlpha(
                                const Color(0xFF9DB2FF),
                                0.22,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: _ProgressRing(
                          value: progress.clamp(0.0, 1.0).toDouble(),
                          size: 92,
                          strokeWidth: 10,
                          backgroundColor:
                              _withAlpha(const Color(0xFF9DB2FF), 0.14),
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
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'SÜRE',
                          value: studyTimeLabel,
                        ),
                      ),
                      Expanded(
                        child: _Metric(
                          label: 'TAMAM',
                          value: completedLabel,
                        ),
                      ),
                      Expanded(
                        child: _Metric(
                          label: 'ÇÖZÜLEN',
                          value: solvedLabel,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _StartButton(
                    label: 'Bugünün Planına Başla',
                    onTap: onStartTap,
                  ),
                ],
              ),
            ),
          ],
        ),
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
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE6EDFF),
            fontSize: 22,
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
      height: 60,
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
                  fontSize: 17,
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
          fontSize: 10,
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
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final _WeekDay day;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = (size / 64).clamp(0.82, 1.0).toDouble();
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
        width: size,
        height: size,
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
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 6 * scale),
              Text(
                '${day.dayOfMonth}',
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFE6EDFF)
                      : const Color(0xFF9FB0D5),
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              if (selected) ...[
                SizedBox(height: 6 * scale),
                Container(
                  width: 4.5 * scale,
                  height: 4.5 * scale,
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

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.onTap});

  final ValueChanged<_QuickActionType> onTap;

  static const List<_QuickAction> _actions = [
    _QuickAction(
      type: _QuickActionType.addQuestion,
      icon: Icons.add_circle_outline_rounded,
      label: 'Soru\nEkle',
      accent: Color(0xFF9BB6FF),
    ),
    _QuickAction(
      type: _QuickActionType.examResult,
      icon: Icons.task_alt_rounded,
      label: 'Sınav\nSonucu',
      accent: Color(0xFFFFB56A),
    ),
    _QuickAction(
      type: _QuickActionType.timer,
      icon: Icons.timer_outlined,
      label: 'Süre\nTut',
      accent: Color(0xFF7FE7FF),
    ),
    _QuickAction(
      type: _QuickActionType.addTask,
      icon: Icons.edit_note_rounded,
      label: 'Görev\nEkle',
      accent: Color(0xFFBFD0FF),
    ),
    _QuickAction(
      type: _QuickActionType.viewPlan,
      icon: Icons.view_agenda_outlined,
      label: 'Planı\nGör',
      accent: Color(0xFFFFA36A),
    ),
    _QuickAction(
      type: _QuickActionType.weakTopic,
      icon: Icons.priority_high_rounded,
      label: 'Zayıf\nKonu',
      accent: Color(0xFFFF7A9E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) => _QuickActionTile(
        action: _actions[index],
        onTap: () => onTap(_actions[index].type),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    required this.onTap,
  });

  final _QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final iconWrap = (size * 0.34).clamp(36.0, 52.0);
        final iconSize = (size * 0.20).clamp(20.0, 28.0);

        return ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.35, -0.35),
                    radius: 1.1,
                    colors: [
                      _withAlpha(const Color(0xFF142950), 0.86),
                      _withAlpha(const Color(0xFF0B1731), 0.62),
                    ],
                  ),
                  border: Border.all(
                    color: _withAlpha(const Color(0xFF93A8D8), 0.18),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size * 0.14,
                    vertical: size * 0.11,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: iconWrap,
                        height: iconWrap,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _withAlpha(action.accent, 0.16),
                          border: Border.all(
                            color: _withAlpha(action.accent, 0.22),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          action.icon,
                          size: iconSize,
                          color: action.accent,
                        ),
                      ),
                      SizedBox(height: size * 0.08),
                      Text(
                        action.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFE6EDFF).withValues(alpha: 0.92),
                          fontSize: (size * 0.115).clamp(10.0, 12.0),
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.type,
    required this.icon,
    required this.label,
    required this.accent,
  });

  final _QuickActionType type;
  final IconData icon;
  final String label;
  final Color accent;
}

enum _QuickActionType {
  addQuestion,
  examResult,
  timer,
  addTask,
  viewPlan,
  weakTopic,
}

class _AiRecommendationCard extends StatelessWidget {
  const _AiRecommendationCard();

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFFB56A);
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _withAlpha(const Color(0xFF223458), 0.64),
              _withAlpha(const Color(0xFF0B1731), 0.86),
            ],
          ),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: _withAlpha(const Color(0xFF93A8D8), 0.14),
          ),
          boxShadow: [
            BoxShadow(
              color: _withAlpha(Colors.black, 0.34),
              blurRadius: 28,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _withAlpha(const Color(0xFF0B1E3A), 0.42),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _withAlpha(const Color(0xFF93A8D8), 0.22),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: Color(0xFFBFD0FF),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'YZ ÖNERİSİ',
                        style: TextStyle(
                          color: Color(0xFFB6C3E4),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          '"Matematik problem çözümüyle başla,\nokuma pratiğiyle devam et,\ngece ',
                    ),
                    const TextSpan(
                      text: 'Biyoloji',
                      style: TextStyle(color: accent),
                    ),
                    const TextSpan(text: ' tekrar et."'),
                  ],
                ),
                style: const TextStyle(
                  color: Color(0xFFE6EDFF),
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const _MiniTag(label: 'MAT', color: Color(0xFF7EA2FF)),
                  const SizedBox(width: 8),
                  const _MiniTag(label: 'OKU', color: Color(0xFF7C879F)),
                  const SizedBox(width: 8),
                  const _MiniTag(label: 'BIO', color: accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '21:00 odak zirven için kişiselleştirildi.',
                      style: TextStyle(
                        color: const Color(0xFFE6EDFF).withValues(alpha: 0.62),
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _withAlpha(color, 0.22),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE6EDFF),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _FocusAreasRow extends StatelessWidget {
  const _FocusAreasRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _FocusAreaCard(
            title: 'Fizik',
            subtitle: 'Tekrar için 4 bölüm kaldı',
            progress: 0.36,
            accent: Color(0xFFFFA6A6),
            trendText: '-4%',
            trendIcon: Icons.trending_down_rounded,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _FocusAreaCard(
            title: 'Tarih',
            subtitle: 'Modern Çağ tamamlandı',
            progress: 0.92,
            accent: Color(0xFFBFD0FF),
          ),
        ),
      ],
    );
  }
}

class _FocusAreaCard extends StatelessWidget {
  const _FocusAreaCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.accent,
    this.trendText,
    this.trendIcon,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Color accent;
  final String? trendText;
  final IconData? trendIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _withAlpha(const Color(0xFF1A2A4D), 0.62),
              _withAlpha(const Color(0xFF0B1731), 0.86),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _withAlpha(const Color(0xFF93A8D8), 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFE6EDFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (trendText != null && trendIcon != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendIcon,
                        size: 14,
                        color: _withAlpha(accent, 0.85),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trendText!,
                        style: TextStyle(
                          color: _withAlpha(accent, 0.88),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: _withAlpha(const Color(0xFF2A3C63), 0.55),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _withAlpha(accent, 0.95),
                              _withAlpha(accent, 0.62),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFFE6EDFF).withValues(alpha: 0.62),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.days,
    required this.subtitle,
  });

  final int days;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _withAlpha(const Color(0xFF223458), 0.60),
              _withAlpha(const Color(0xFF0B1731), 0.88),
            ],
          ),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: _withAlpha(const Color(0xFF93A8D8), 0.14),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _withAlpha(const Color(0xFFFFB56A), 0.18),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFFB56A),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$days Gün Serisi',
                    style: const TextStyle(
                      color: Color(0xFFE6EDFF),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFFE6EDFF).withValues(alpha: 0.62),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(
                days,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB56A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastExamSummaryCard extends StatelessWidget {
  const _LastExamSummaryCard({
    required this.onViewAnalysis,
  });

  final VoidCallback onViewAnalysis;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _withAlpha(const Color(0xFF223458), 0.62),
              _withAlpha(const Color(0xFF0B1731), 0.90),
            ],
          ),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: _withAlpha(const Color(0xFF93A8D8), 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'SON SINAV ÖZETİ',
                    style: TextStyle(
                      color: Color(0xFFB6C3E4),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.auto_graph_rounded,
                  size: 18,
                  color: _withAlpha(const Color(0xFFBFD0FF), 0.9),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Net Puan',
                  style: TextStyle(
                    color: Color(0xFFE6EDFF),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _withAlpha(const Color(0xFF8EA5FF), 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _withAlpha(const Color(0xFF8EA5FF), 0.22),
                    ),
                  ),
                  child: const Text(
                    '+12%',
                    style: TextStyle(
                      color: Color(0xFFBFD0FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Expanded(
                  child: _ExamPill(
                    label: 'EN İYİ',
                    value: 'Matematik (%98)',
                    accent: Color(0xFF7EA2FF),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ExamPill(
                    label: 'EN ZAYIF',
                    value: 'Fizik (%54)',
                    accent: Color(0xFFFF7A9E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onViewAnalysis,
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      'Tüm Analizi Gör',
                      style: TextStyle(
                        color:
                            _withAlpha(const Color(0xFFBFD0FF), 0.92),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamPill extends StatelessWidget {
  const _ExamPill({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _withAlpha(const Color(0xFF0B1E3A), 0.45),
              _withAlpha(const Color(0xFF07122A), 0.72),
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _withAlpha(const Color(0xFF93A8D8), 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: _withAlpha(accent, 0.9),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFE6EDFF),
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
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
  const names = ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT'];
  return List.generate(6, (index) {
    final date = monday.add(Duration(days: index));
    return _WeekDay(shortName: names[index], date: date);
  });
}

String _formatHeaderDate(DateTime date) {
  const months = [
    'OCAK',
    'ŞUBAT',
    'MART',
    'NİSAN',
    'MAYIS',
    'HAZİRAN',
    'TEMMUZ',
    'AĞUSTOS',
    'EYLÜL',
    'EKİM',
    'KASIM',
    'ARALIK',
  ];
  final month = months[date.month - 1];
  return '${date.day} $month ${date.year}';
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
