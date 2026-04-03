import 'package:flutter/material.dart';

class ViewPlanPage extends StatefulWidget {
  const ViewPlanPage({super.key});

  @override
  State<ViewPlanPage> createState() => _ViewPlanPageState();
}

class _ViewPlanPageState extends State<ViewPlanPage> {
  int _selectedDayIndex = 2; // Çarşamba seçili başlangıçta
  bool _isListView = true;

  static const _bgColor = Color(0xFF061022);
  static const _cardColor = Color(0xFF0D1B2E);
  static const _accentBlue = Color(0xFF3B6FF0);
  static const _textPrimary = Color(0xFFE6EDFF);
  static const _textSecondary = Color(0xFF7A8DAA);

  // Haftanın günleri: PZT 14, SAL 15, ÇAR 16, PER 17
  final List<_DayData> _days = [
    _DayData(label: 'PZT', number: 14),
    _DayData(label: 'SAL', number: 15),
    _DayData(label: 'ÇAR', number: 16),
    _DayData(label: 'PER', number: 17),
    _DayData(label: 'CUM', number: 18),
  ];

  final List<_LessonData> _lessons = [
    _LessonData(
      time: '09:00 - 10:30',
      title: 'İleri Matematik II',
      topic: 'Konu: İntegral ve Uygulamaları',
      isNow: false,
    ),
    _LessonData(
      time: '11:00 - 12:30',
      title: 'Veri Yapıları ve Algoritmalar',
      topic: 'Konu: Hash Tabloları',
      isNow: true,
    ),
    _LessonData(
      time: '14:00 - 15:30',
      title: 'Akademik İngilizce',
      topic: 'Konu: Teknik Rapor Yazımı',
      isNow: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          const _PlanBackground(),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Planı Görüntüle',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Yapay zeka bugün için en verimli rotayı çizdi.',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildWeeklyFlow(),
                      const SizedBox(height: 30),
                      _buildDailyLessonsSection(),
                      const SizedBox(height: 28),
                      _buildAiSuggestionCard(),
                      const SizedBox(height: 28),
                      _buildDayFocusSection(),
                      const SizedBox(height: 28),
                      _buildUpcomingExamsSection(),
                      const SizedBox(height: 28),
                      _buildCourseMaterialsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1D35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E3050),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Zeki Asistan',
            style: TextStyle(
              color: _accentBlue,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF12243D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_horiz_rounded,
              color: _textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Haftalık Akış',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: () {
                if (_selectedDayIndex > 0) {
                  setState(() => _selectedDayIndex--);
                }
              },
            ),
            const SizedBox(width: 8),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () {
                if (_selectedDayIndex < _days.length - 1) {
                  setState(() => _selectedDayIndex++);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_days.length, (i) {
            final day = _days[i];
            final isSelected = i == _selectedDayIndex;
            return _DayChip(
              day: day,
              isSelected: isSelected,
              hasEvent: i == 2,
              onTap: () => setState(() => _selectedDayIndex = i),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDailyLessonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Günlük Ders\nSaatleri',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  height: 1.15,
                ),
              ),
            ),
            _PillToggle(
              label: _isListView ? 'Görüntüle: Liste' : 'Görüntüle: Takvim',
              onTap: () => setState(() => _isListView = !_isListView),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _LessonTimeline(lessons: _lessons),
      ],
    );
  }

  Widget _buildAiSuggestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102040), Color(0xFF0D1830)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1A2E50), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _accentBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Yapay Zeka Önerisi',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: _textSecondary,
                fontSize: 15,
                height: 1.55,
              ),
              children: [
                TextSpan(text: 'Bugün saat 16:00 - 18:00 arası '),
                TextSpan(
                  text: 'Matematik',
                  style: TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      ' tekrarı için en yüksek bilişsel kapasiteye sahip olacağın zaman dilimi. Bu aralığı boş bırakmanı öneririm.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Planı Optimize Et',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayFocusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Günün Odağı',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF162035), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tamamlanan Görevler',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    '3 / 5',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 3 / 5,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF1A2E50),
                  valueColor: const AlwaysStoppedAnimation<Color>(_accentBlue),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: _textSecondary,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tahmini bitiş: 19:30',
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingExamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yaklaşan Sınavlar',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF162035), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF162035),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '12',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'GÜN',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Veri Yapıları Final',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Önem Seviyesi: Kritik',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Kritik',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseMaterialsSection() {
    const materials = [
      _MaterialData(
        icon: Icons.description_outlined,
        type: 'Notlar',
        name: 'Analiz-I.pdf',
        color: Color(0xFF1A3A5C),
        iconColor: Color(0xFF5B9BD5),
      ),
      _MaterialData(
        icon: Icons.play_circle_outline_rounded,
        type: 'Video',
        name: 'Hashing Intro',
        color: Color(0xFF3B1A1A),
        iconColor: Color(0xFFE05252),
      ),
      _MaterialData(
        icon: Icons.quiz_outlined,
        type: 'Test',
        name: 'Quiz Denemesi',
        color: Color(0xFF1A2E50),
        iconColor: Color(0xFF3B6FF0),
      ),
      _MaterialData(
        icon: Icons.folder_shared_outlined,
        type: 'Paylaşılan',
        name: 'Grup Projesi',
        color: Color(0xFF1A2A1A),
        iconColor: Color(0xFF4CAF50),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ders Materyalleri',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: materials
              .map((m) => _MaterialCard(data: m))
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class _DayData {
  const _DayData({required this.label, required this.number});
  final String label;
  final int number;
}

class _LessonData {
  const _LessonData({
    required this.time,
    required this.title,
    required this.topic,
    required this.isNow,
  });
  final String time;
  final String title;
  final String topic;
  final bool isNow;
}

class _MaterialData {
  const _MaterialData({
    required this.icon,
    required this.type,
    required this.name,
    required this.color,
    required this.iconColor,
  });
  final IconData icon;
  final String type;
  final String name;
  final Color color;
  final Color iconColor;
}

// ─────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────

class _PlanBackground extends StatelessWidget {
  const _PlanBackground();

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
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Container(),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1D35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1A2E50), width: 1),
        ),
        child: Icon(icon, color: const Color(0xFFE6EDFF), size: 20),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.hasEvent,
    required this.onTap,
  });
  final _DayData day;
  final bool isSelected;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B6FF0) : const Color(0xFF0D1B2E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B6FF0)
                : const Color(0xFF1A2E50),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFF7A8DAA),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.number}',
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFE6EDFF),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : (hasEvent
                        ? const Color(0xFF3B6FF0)
                        : Colors.transparent),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  const _PillToggle({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1A2E50), width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBFD0FF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LessonTimeline extends StatelessWidget {
  const _LessonTimeline({required this.lessons});
  final List<_LessonData> lessons;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(lessons.length, (i) {
        final lesson = lessons[i];
        final isLast = i == lessons.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 14),
                      decoration: BoxDecoration(
                        color: lesson.isNow
                            ? const Color(0xFF3B6FF0)
                            : const Color(0xFF1A2E50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: lesson.isNow
                              ? const Color(0xFF6B9AFF)
                              : const Color(0xFF2A3E60),
                          width: 2,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFF1A2E50),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                  child: _LessonCard(lesson: lesson),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson});
  final _LessonData lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lesson.isNow
            ? const Color(0xFF102040)
            : const Color(0xFF0D1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lesson.isNow
              ? const Color(0xFF2A4A80)
              : const Color(0xFF162035),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                lesson.time,
                style: const TextStyle(
                  color: Color(0xFF7A8DAA),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (lesson.isNow) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B6FF0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ŞİMDİ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            lesson.title,
            style: const TextStyle(
              color: Color(0xFFE6EDFF),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lesson.topic,
            style: const TextStyle(
              color: Color(0xFF7A8DAA),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({required this.data});
  final _MaterialData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF162035), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 20),
          ),
          const Spacer(),
          Text(
            data.type,
            style: const TextStyle(
              color: Color(0xFF7A8DAA),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.name,
            style: const TextStyle(
              color: Color(0xFFE6EDFF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
