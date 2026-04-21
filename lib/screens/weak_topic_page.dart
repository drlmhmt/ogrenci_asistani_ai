import 'package:flutter/material.dart';

import 'add_question_page.dart';
import 'add_task_page.dart';

class WeakTopicPage extends StatelessWidget {
  const WeakTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WeakTopicView();
  }
}

class _WeakTopicView extends StatelessWidget {
  const _WeakTopicView();

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081224),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111C34), Color(0xFF091224), Color(0xFF070D18)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Row(
                  children: [
                    _TopIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Zayıf Konu Analizi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFEAF1FF),
                          fontSize: 22,
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
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _AiInsightCard(),
                      const SizedBox(height: 22),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Zayıf Olduğun Konular',
                          style: TextStyle(
                            color: Color(0xFFE7EEFF),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _WeakTopicCard(
                        category: 'MATEMATİK',
                        title: 'Trigonometri II',
                        success: '%34 Başarı',
                        score: 34,
                        accent: const Color(0xFFFF6C7A),
                        primaryLabel: 'Tekrar Et',
                        secondaryLabel: 'Soru Çöz',
                        onPrimaryTap: () {},
                        onSecondaryTap: () => _openPage(context, const AddQuestionPage()),
                      ),
                      const SizedBox(height: 12),
                      _WeakTopicCard(
                        category: 'FİZİK',
                        title: 'Elektriksel Kuvvet',
                        success: '%42 Başarı',
                        score: 42,
                        accent: const Color(0xFFFFB85C),
                        primaryLabel: 'Tekrar Et',
                        secondaryLabel: 'Soru Çöz',
                        onPrimaryTap: () {},
                        onSecondaryTap: () => _openPage(context, const AddQuestionPage()),
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Hata Analizi',
                          style: TextStyle(
                            color: Color(0xFFE7EEFF),
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _ErrorAnalysisCard(),
                      const SizedBox(height: 14),
                      _DailyAdviceCard(
                        onAddPlanTap: () => _openPage(context, const AddTaskPage()),
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
            gradient: const LinearGradient(
              colors: [Color(0xFF202B44), Color(0xFF131C2F)],
            ),
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

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2566E8), Color(0xFF153B8E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2566E8).withValues(alpha: 0.26),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_alt_rounded, color: Color(0xFFDCE6FF), size: 15),
              SizedBox(width: 6),
              Text(
                'YAPAY ZEKA ANALİZİ',
                style: TextStyle(
                  color: Color(0xFFDCE6FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Gelişim Alanlarını\nKeşfet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              height: 1.02,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Son 30 gündeki deneme sonuçlarını analiz ettim. Özellikle Logaritma ve Modern Fizik konularında net artış potansiyelin yüksek görünüyor.',
            style: TextStyle(
              color: Color(0xFFD4E0FF),
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeakTopicCard extends StatelessWidget {
  const _WeakTopicCard({
    required this.category,
    required this.title,
    required this.success,
    required this.score,
    required this.accent,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final String category;
  final String title;
  final String success;
  final int score;
  final Color accent;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A243A), Color(0xFF101827)],
        ),
        border: Border.all(color: const Color(0xFF202D46)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF7F90B2),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFF4F7FF),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                success,
                style: TextStyle(
                  color: accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: const Color(0xFF344059)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (score / 100).clamp(0.0, 1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: accent),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: primaryLabel,
                  icon: Icons.refresh_rounded,
                  selected: true,
                  onTap: onPrimaryTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillButton(
                  label: secondaryLabel,
                  icon: Icons.chat_bubble_outline_rounded,
                  selected: false,
                  onTap: onSecondaryTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected
                ? const LinearGradient(colors: [Color(0xFF2F87FF), Color(0xFF215CE0)])
                : null,
            color: selected ? null : const Color(0xFF1A2234),
            border: Border.all(
              color: selected ? Colors.transparent : const Color(0xFF2C3954),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: selected ? 0.95 : 0.74),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: selected ? 0.95 : 0.74),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorAnalysisCard extends StatelessWidget {
  const _ErrorAnalysisCard();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Hata Dalgası Etkisi', '%65'),
      ('Bilgi Eksikliği', '%70'),
      ('Dikkat Hatası', '%30'),
      ('Zaman Yönetimi', '%55'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A243A), Color(0xFF101827)],
        ),
        border: Border.all(color: const Color(0xFF202D46)),
      ),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFF9DB1DB), size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    row.$1,
                    style: const TextStyle(
                      color: Color(0xFFEAF0FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  row.$2,
                  style: const TextStyle(
                    color: Color(0xFF94A8D5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DailyAdviceCard extends StatelessWidget {
  const _DailyAdviceCard({
    required this.onAddPlanTap,
  });

  final VoidCallback onAddPlanTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF182641), Color(0xFF111A2A)],
        ),
        border: Border.all(color: const Color(0xFF233150)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFD5E1FF), size: 16),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Günlük Tavsiye',
                  style: TextStyle(
                    color: Color(0xFFEAF1FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.auto_awesome_rounded,
                color: const Color(0xFFD5E1FF).withValues(alpha: 0.72),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '"Bugün Matematik testine başlamadan önce 10 dakika formül tekrarı yapman, Trigonometri sorularındaki işaret hatalarını %25 azaltabilir."',
            style: TextStyle(
              color: Color(0xFFB8C7E8),
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAddPlanTap,
                borderRadius: BorderRadius.circular(999),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF8FAFF), Color(0xFFDCE5FF)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Planıma Ekle',
                      style: TextStyle(
                        color: Color(0xFF16274A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

