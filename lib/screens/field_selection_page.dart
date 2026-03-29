import 'package:flutter/material.dart';

import '../services/onboarding_state_service.dart';
import 'exams_page.dart';
import 'login_page.dart';

class FieldSelectionPage extends StatefulWidget {
  const FieldSelectionPage({super.key, required this.exam});

  final ExamOption exam;

  @override
  State<FieldSelectionPage> createState() => _FieldSelectionPageState();
}

class _FieldSelectionPageState extends State<FieldSelectionPage> {
  final TextEditingController _targetScoreController = TextEditingController();
  final OnboardingStateService _onboardingStateService =
      OnboardingStateService();

  ExamField? _selectedField;
  String? _scoreError;
  bool _isSaving = false;

  @override
  void dispose() {
    _targetScoreController.dispose();
    super.dispose();
  }

  double? get _parsedTargetScore {
    final rawText = _targetScoreController.text.trim().replaceAll(',', '.');
    return double.tryParse(rawText);
  }

  String get _scoreHint {
    final min = widget.exam.minScore.toStringAsFixed(0);
    final max = widget.exam.maxScore.toStringAsFixed(0);
    return 'Örn: $min - $max';
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    final targetScore = _parsedTargetScore;

    if (_selectedField == null) {
      setState(() => _scoreError = 'Devam etmek için bir alan seç.');
      return;
    }

    if (targetScore == null) {
      setState(
        () => _scoreError = 'Hedef puanını sayısal bir değer olarak gir.',
      );
      return;
    }

    if (targetScore < widget.exam.minScore || targetScore > widget.exam.maxScore) {
      setState(
        () => _scoreError =
            'Bu sınav için hedef puan ${widget.exam.minScore.toStringAsFixed(0)} ile ${widget.exam.maxScore.toStringAsFixed(0)} arasında olmalı.',
      );
      return;
    }

    setState(() {
      _scoreError = null;
      _isSaving = true;
    });

    final selectedField = _selectedField!;
    final fieldIndex = widget.exam.fields.indexWhere(
      (field) => field.key == selectedField.key,
    );
    final formattedScore = targetScore.toStringAsFixed(
      targetScore.truncateToDouble() == targetScore ? 0 : 1,
    );

    await _onboardingStateService.setCompleted(
      goalIndex: fieldIndex < 0 ? 0 : fieldIndex,
      goalText:
          '${widget.exam.title} - ${selectedField.title} - $formattedScore ${widget.exam.scoreUnit}',
      examKey: widget.exam.key,
      examTitle: widget.exam.title,
      fieldKey: selectedField.key,
      fieldTitle: selectedField.title,
      targetScore: targetScore,
    );

    if (!mounted) {
      return;
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;
    final targetScore = _parsedTargetScore;
    final scoreInsight = _buildScoreInsight(exam, targetScore);

    return Scaffold(
      backgroundColor: const Color(0xFF08111F),
      body: Stack(
        children: [
          const _FieldBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTag(color: exam.accentA),
                  const SizedBox(height: 18),
                  _SelectedExamSummary(exam: exam),
                  const SizedBox(height: 22),
                  const Text(
                    'Alan Seçimi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...exam.fields.map(
                            (field) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _FieldCard(
                                field: field,
                                exam: exam,
                                isSelected: field.key == _selectedField?.key,
                                onTap: () {
                                  setState(() {
                                    _selectedField = field;
                                    _scoreError = null;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Hedef Puan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: const Color(0xFF0B1628),
                              border: Border.all(
                                color: _scoreError == null
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : const Color(0xFFFF6D7D),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _targetScoreController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: _scoreHint,
                                        hintStyle: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.22,
                                          ),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onChanged: (_) {
                                        final value = _parsedTargetScore;
                                        setState(() {
                                          if (value != null &&
                                              value > widget.exam.maxScore) {
                                            _scoreError =
                                                'Bu sınavda en yüksek puan ${widget.exam.maxScore.toStringAsFixed(0)} olabilir.';
                                          } else {
                                            _scoreError = null;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        exam.scoreUnit.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.46,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Icon(
                                        Icons.track_changes_rounded,
                                        color: exam.accentA,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_scoreError != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _scoreError!,
                              style: const TextStyle(
                                color: Color(0xFFFF8E9A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          _InsightCard(
                            exam: exam,
                            message: scoreInsight,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _FlowActionButton(
                    label: _isSaving ? 'Kaydediliyor...' : 'İlerle',
                    startColor: exam.accentA,
                    endColor: exam.accentB,
                    onTap: _isSaving ? () {} : _continue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildScoreInsight(ExamOption exam, double? targetScore) {
    if (_selectedField == null) {
      return 'Önce bir alan seç. Sonra hedef puanına göre plan yoğunluğu ve konu öncelikleri belirlenecek.';
    }

    if (targetScore == null) {
      return exam.guidance;
    }

    final normalized = ((targetScore - exam.minScore) /
            (exam.maxScore - exam.minScore))
        .clamp(0.0, 1.0);
    final percentage = (normalized * 100).round();

    String intensity;
    if (percentage >= 85) {
      intensity = 'üst seviye rekabet';
    } else if (percentage >= 65) {
      intensity = 'güçlü hedef';
    } else if (percentage >= 45) {
      intensity = 'dengeli hedef';
    } else {
      intensity = 'temel güçlendirme';
    }

    final formattedScore = targetScore.toStringAsFixed(
      targetScore.truncateToDouble() == targetScore ? 0 : 1,
    );

    return '${_selectedField!.title} alanında $formattedScore ${exam.scoreUnit} hedefi, ${exam.title} ölçeğinde yaklaşık %$percentage seviyesinde $intensity anlamına gelir. Program bu tempoya göre şekillenecek.';
  }
}

class _SectionTag extends StatelessWidget {
  const _SectionTag({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: color.withValues(alpha: 0.9), width: 2),
        ),
      ),
      child: Text(
        'SEÇİLEN SINAV',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SelectedExamSummary extends StatelessWidget {
  const _SelectedExamSummary({required this.exam});

  final ExamOption exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: exam.surfaceColor.withValues(alpha: 0.92),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(colors: [exam.accentA, exam.accentB]),
            ),
            child: Icon(exam.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${exam.title} ${exam.yearLabel}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exam.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Değiştir',
              style: TextStyle(
                color: exam.accentA,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.field,
    required this.exam,
    required this.isSelected,
    required this.onTap,
  });

  final ExamField field;
  final ExamOption exam;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isSelected
            ? exam.accentB.withValues(alpha: 0.18)
            : const Color(0xFF121C2C),
        border: Border.all(
          color: isSelected
              ? exam.accentA
              : Colors.white.withValues(alpha: 0.04),
          width: 1.4,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: exam.accentB.withValues(alpha: 0.22),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withValues(alpha: isSelected ? 0.14 : 0.07),
                  ),
                  child: Icon(
                    field.icon,
                    color: isSelected ? exam.accentA : Colors.white70,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        field.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? exam.accentA
                      : Colors.white.withValues(alpha: 0.28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.exam, required this.message});

  final ExamOption exam;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF151F31),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: exam.accentA.withValues(alpha: 0.16),
            ),
            child: Icon(Icons.tips_and_updates_rounded, color: exam.accentA),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.76),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldBackground extends StatelessWidget {
  const _FieldBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF216BF0),
                  Color(0xFF103C98),
                  Color(0xFF0A235C),
                  Color(0xFF07152E),
                ],
                stops: [0, 0.24, 0.58, 1],
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7BC3FF).withValues(alpha: 0.36),
                      const Color(0xFF7BC3FF).withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.36, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -70,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3B7BFF).withValues(alpha: 0.2),
                      const Color(0xFF3B7BFF).withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.4, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1EA7FF).withValues(alpha: 0.16),
                      const Color(0xFF1EA7FF).withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.42, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.04),
                      Colors.transparent,
                      const Color(0xFF69BBFF).withValues(alpha: 0.025),
                    ],
                    stops: const [0, 0.45, 1],
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF08111F).withValues(alpha: 0.18),
                  const Color(0xFF08111F),
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowActionButton extends StatelessWidget {
  const _FlowActionButton({
    required this.label,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  final String label;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(colors: [startColor, endColor]),
          boxShadow: [
            BoxShadow(
              color: endColor.withValues(alpha: 0.34),
              blurRadius: 34,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
