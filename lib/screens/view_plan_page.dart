import 'package:flutter/material.dart';

class ViewPlanPage extends StatefulWidget {
  const ViewPlanPage({super.key});

  @override
  State<ViewPlanPage> createState() => _ViewPlanPageState();
}

class _ViewPlanPageState extends State<ViewPlanPage> {
  // Hafta başlangıcı (Pazartesi bazlı)
  DateTime _weekStart = _mondayOf(DateTime.now());
  int _selectedDayIndex = _todayIndexInWeek(DateTime.now());
  bool _isListView = true;

  static const _bgColor = Color(0xFF061022);
  static const _cardColor = Color(0xFF0D1B2E);
  static const _accentBlue = Color(0xFF3B6FF0);
  static const _textPrimary = Color(0xFFE6EDFF);
  static const _textSecondary = Color(0xFF7A8DAA);

  static DateTime _mondayOf(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static int _todayIndexInWeek(DateTime date) {
    final idx = date.weekday - 1; // 0=Pzt
    return idx.clamp(0, 6);
  }

  List<_DayData> get _days {
    const labels = ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT', 'PAZ'];
    return List.generate(7, (i) {
      final date = _weekStart.add(Duration(days: i));
      return _DayData(label: labels[i], number: date.day, date: date);
    });
  }

  void _prevWeek() => setState(() {
        _weekStart = _weekStart.subtract(const Duration(days: 7));
        _selectedDayIndex = 0;
      });

  void _nextWeek() => setState(() {
        _weekStart = _weekStart.add(const Duration(days: 7));
        _selectedDayIndex = 0;
      });

  String get _weekRangeLabel {
    final end = _weekStart.add(const Duration(days: 6));
    return '${_weekStart.day} ${_monthName(_weekStart.month)} – ${end.day} ${_monthName(end.month)} ${end.year}';
  }

  static String _monthName(int m) {
    const names = [
      '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    return names[m];
  }

  final List<_LessonData> _lessons = [
    _LessonData(
      time: '09:00 - 10:30',
      title: 'İleri Matematik II',
      topic: 'Konu: İntegral ve Uygulamaları',
      isNow: false,
      color: Color(0xFF1A3A5C),
    ),
    _LessonData(
      time: '11:00 - 12:30',
      title: 'Veri Yapıları ve Algoritmalar',
      topic: 'Konu: Hash Tabloları',
      isNow: true,
      color: Color(0xFF1A2E50),
    ),
    _LessonData(
      time: '14:00 - 15:30',
      title: 'Akademik İngilizce',
      topic: 'Konu: Teknik Rapor Yazımı',
      isNow: false,
      color: Color(0xFF1A2A3A),
    ),
  ];

  void _showOptimizeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3E60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Planı Optimize Et',
                style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Yapay zeka bugünkü planını verimlilik skoruna göre yeniden düzenleyecek.',
              style: TextStyle(color: _textSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            _OptimizeOption(
              icon: Icons.bolt_rounded,
              title: 'Hızlı Optimize',
              subtitle: 'Mevcut dersleri yeniden sırala',
              onTap: () { Navigator.pop(context); _showSuccessSnack('Plan hızlıca optimize edildi!'); },
            ),
            const SizedBox(height: 12),
            _OptimizeOption(
              icon: Icons.psychology_rounded,
              title: 'Derin Analiz',
              subtitle: 'Bilişsel yük ve sınav takvimini göz önüne al',
              onTap: () { Navigator.pop(context); _showSuccessSnack('Derin analiz başlatıldı, sonuçlar hazırlanıyor…'); },
            ),
            const SizedBox(height: 12),
            _OptimizeOption(
              icon: Icons.schedule_rounded,
              title: 'Boş Saatleri Doldur',
              subtitle: '16:00–18:00 arası matematikle doldur',
              onTap: () { Navigator.pop(context); _showSuccessSnack('Boş saatler ders ile dolduruldu!'); },
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: _accentBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLessonDetail(_LessonData lesson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3E60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (lesson.isNow)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _accentBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('ŞU AN AKTİF',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            Text(lesson.title,
                style: const TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(lesson.time,
                style: const TextStyle(color: _textSecondary, fontSize: 14)),
            const SizedBox(height: 4),
            Text(lesson.topic,
                style: const TextStyle(color: _textSecondary, fontSize: 14)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: _LessonAction(icon: Icons.menu_book_rounded, label: 'Notlar',
                  onTap: () { Navigator.pop(context); _showSuccessSnack('Ders notları açılıyor…'); })),
              const SizedBox(width: 12),
              Expanded(child: _LessonAction(icon: Icons.play_circle_rounded, label: 'Video',
                  onTap: () { Navigator.pop(context); _showSuccessSnack('Video oynatıcı açılıyor…'); })),
              const SizedBox(width: 12),
              Expanded(child: _LessonAction(icon: Icons.timer_rounded, label: 'Zamanlayıcı',
                  onTap: () { Navigator.pop(context); _showSuccessSnack('Pomodoro başlatıldı!'); })),
            ]),
          ],
        ),
      ),
    );
  }

  void _showMaterialDetail(_MaterialData mat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3E60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: mat.color, borderRadius: BorderRadius.circular(14)),
                child: Icon(mat.icon, color: mat.iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(mat.name,
                    style: const TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                Text(mat.type,
                    style: const TextStyle(color: _textSecondary, fontSize: 13)),
              ]),
            ]),
            const SizedBox(height: 24),
            ...mat.actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessSnack(action.feedback);
                  },
                  icon: Icon(action.icon, size: 18),
                  label: Text(action.label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: action.isPrimary ? _accentBlue : const Color(0xFF162035),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

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
                        style: TextStyle(color: _textSecondary, fontSize: 15),
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
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1D35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E3050), width: 1),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const Spacer(),
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: Color(0xFF12243D), shape: BoxShape.circle),
            child: const Icon(Icons.more_horiz_rounded, color: _textPrimary, size: 20),
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
              child: Text('Haftalık Akış',
                  style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
            ),
            _NavButton(icon: Icons.chevron_left_rounded, onTap: _prevWeek),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.chevron_right_rounded, onTap: _nextWeek),
          ],
        ),
        const SizedBox(height: 6),
        Text(_weekRangeLabel,
            style: const TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_days.length, (i) {
              final day = _days[i];
              final isToday = _isSameDay(day.date, DateTime.now());
              return Padding(
                padding: EdgeInsets.only(right: i < _days.length - 1 ? 8 : 0),
                child: _DayChip(
                  day: day,
                  isSelected: i == _selectedDayIndex,
                  hasEvent: isToday,
                  onTap: () => setState(() => _selectedDayIndex = i),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildDailyLessonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text('Günlük Ders\nSaatleri',
                  style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.4, height: 1.15)),
            ),
            _PillToggle(
              label: _isListView ? 'Liste' : 'Takvim',
              icon: _isListView ? Icons.view_list_rounded : Icons.calendar_month_rounded,
              onTap: () => setState(() => _isListView = !_isListView),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _isListView
            ? _LessonTimeline(lessons: _lessons, onTap: _showLessonDetail)
            : _LessonCalendarView(lessons: _lessons, onTap: _showLessonDetail),
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
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: _accentBlue, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Text('Yapay Zeka Önerisi',
                style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: _textSecondary, fontSize: 15, height: 1.55),
              children: [
                TextSpan(text: 'Bugün saat 16:00 - 18:00 arası '),
                TextSpan(
                  text: 'Matematik',
                  style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' tekrarı için en yüksek bilişsel kapasiteye sahip olacağın zaman dilimi. Bu aralığı boş bırakmanı öneririm.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _showOptimizeSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Planı Optimize Et',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
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
        const Text('Günün Odağı',
            style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
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
              Row(children: [
                const Expanded(
                  child: Text('Tamamlanan Görevler',
                      style: TextStyle(color: _textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const Text('3 / 5',
                    style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 3 / 5,
                  minHeight: 8,
                  backgroundColor: Color(0xFF1A2E50),
                  valueColor: AlwaysStoppedAnimation<Color>(_accentBlue),
                ),
              ),
              const SizedBox(height: 12),
              const Row(children: [
                Icon(Icons.access_time_rounded, color: _textSecondary, size: 15),
                SizedBox(width: 6),
                Text('Tahmini bitiş: 19:30', style: TextStyle(color: _textSecondary, fontSize: 13)),
              ]),
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
        const Text('Yaklaşan Sınavlar',
            style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showSuccessSnack('Sınav detayları yakında açılacak!'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF162035), width: 1),
            ),
            child: Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: const Color(0xFF162035), borderRadius: BorderRadius.circular(14)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('12', style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w800, height: 1.0)),
                    Text('GÜN', style: TextStyle(color: _textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Veri Yapıları Final',
                      style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Önem Seviyesi: Kritik',
                      style: TextStyle(color: _textSecondary, fontSize: 13)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF3B1A1A), borderRadius: BorderRadius.circular(8)),
                child: const Text('Kritik',
                    style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseMaterialsSection() {
    final materials = [
      _MaterialData(
        icon: Icons.description_outlined,
        type: 'Notlar',
        name: 'Analiz-I.pdf',
        color: const Color(0xFF1A3A5C),
        iconColor: const Color(0xFF5B9BD5),
        actions: [
          _MaterialAction(icon: Icons.open_in_new_rounded, label: 'PDF\'i Aç', isPrimary: true, feedback: 'PDF görüntüleyici açılıyor…'),
          _MaterialAction(icon: Icons.download_rounded, label: 'İndir', isPrimary: false, feedback: 'İndirme başladı!'),
          _MaterialAction(icon: Icons.share_rounded, label: 'Paylaş', isPrimary: false, feedback: 'Paylaşım menüsü açılıyor…'),
        ],
      ),
      _MaterialData(
        icon: Icons.play_circle_outline_rounded,
        type: 'Video',
        name: 'Hashing Intro',
        color: const Color(0xFF3B1A1A),
        iconColor: const Color(0xFFE05252),
        actions: [
          _MaterialAction(icon: Icons.play_arrow_rounded, label: 'Videoyu Oynat', isPrimary: true, feedback: 'Video oynatıcı açılıyor…'),
          _MaterialAction(icon: Icons.bookmark_add_rounded, label: 'Kaydet', isPrimary: false, feedback: 'Video kaydedildi!'),
        ],
      ),
      _MaterialData(
        icon: Icons.quiz_outlined,
        type: 'Test',
        name: 'Quiz Denemesi',
        color: const Color(0xFF1A2E50),
        iconColor: const Color(0xFF3B6FF0),
        actions: [
          _MaterialAction(icon: Icons.play_arrow_rounded, label: 'Teste Başla', isPrimary: true, feedback: 'Quiz başlatılıyor…'),
          _MaterialAction(icon: Icons.bar_chart_rounded, label: 'Sonuçlarım', isPrimary: false, feedback: 'Sonuçlar yükleniyor…'),
        ],
      ),
      _MaterialData(
        icon: Icons.folder_shared_outlined,
        type: 'Paylaşılan',
        name: 'Grup Projesi',
        color: const Color(0xFF1A2A1A),
        iconColor: const Color(0xFF4CAF50),
        actions: [
          _MaterialAction(icon: Icons.open_in_new_rounded, label: 'Projeyi Aç', isPrimary: true, feedback: 'Grup projesi açılıyor…'),
          _MaterialAction(icon: Icons.group_rounded, label: 'Grup Üyeleri', isPrimary: false, feedback: 'Grup üyeleri yükleniyor…'),
          _MaterialAction(icon: Icons.upload_rounded, label: 'Dosya Yükle', isPrimary: false, feedback: 'Dosya seçici açılıyor…'),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ders Materyalleri',
            style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: materials.map((m) => _MaterialCard(data: m, onTap: () => _showMaterialDetail(m))).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class _DayData {
  const _DayData({required this.label, required this.number, required this.date});
  final String label;
  final int number;
  final DateTime date;
}

class _LessonData {
  const _LessonData({
    required this.time,
    required this.title,
    required this.topic,
    required this.isNow,
    required this.color,
  });
  final String time;
  final String title;
  final String topic;
  final bool isNow;
  final Color color;
}

class _MaterialAction {
  const _MaterialAction({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.feedback,
  });
  final IconData icon;
  final String label;
  final bool isPrimary;
  final String feedback;
}

class _MaterialData {
  const _MaterialData({
    required this.icon,
    required this.type,
    required this.name,
    required this.color,
    required this.iconColor,
    required this.actions,
  });
  final IconData icon;
  final String type;
  final String name;
  final Color color;
  final Color iconColor;
  final List<_MaterialAction> actions;
}

// ─────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────

class _PlanBackground extends StatelessWidget {
  const _PlanBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B1E3A), Color(0xFF07122A), Color(0xFF061022)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: SizedBox.expand(),
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
        width: 34, height: 34,
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
            color: isSelected ? const Color(0xFF3B6FF0) : const Color(0xFF1A2E50),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.label,
              style: TextStyle(
                color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF7A8DAA),
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
              width: 5, height: 5,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : (hasEvent ? const Color(0xFF3B6FF0) : Colors.transparent),
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
  const _PillToggle({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1A2E50), width: 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: const Color(0xFFBFD0FF), size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Color(0xFFBFD0FF), fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _LessonTimeline extends StatelessWidget {
  const _LessonTimeline({required this.lessons, required this.onTap});
  final List<_LessonData> lessons;
  final void Function(_LessonData) onTap;

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
                child: Column(children: [
                  Container(
                    width: 12, height: 12,
                    margin: const EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(
                      color: lesson.isNow ? const Color(0xFF3B6FF0) : const Color(0xFF1A2E50),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: lesson.isNow ? const Color(0xFF6B9AFF) : const Color(0xFF2A3E60),
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
                ]),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                  child: GestureDetector(
                    onTap: () => onTap(lesson),
                    child: _LessonCard(lesson: lesson),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _LessonCalendarView extends StatelessWidget {
  const _LessonCalendarView({required this.lessons, required this.onTap});
  final List<_LessonData> lessons;
  final void Function(_LessonData) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF162035), width: 1),
      ),
      child: Column(
        children: List.generate(lessons.length, (i) {
          final lesson = lessons[i];
          final isLast = i == lessons.length - 1;
          return GestureDetector(
            onTap: () => onTap(lesson),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(
                  bottom: BorderSide(color: Color(0xFF162035), width: 1),
                ),
              ),
              child: Row(children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    lesson.time.split(' - ').first,
                    style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 4, height: 40,
                  decoration: BoxDecoration(
                    color: lesson.isNow ? const Color(0xFF3B6FF0) : const Color(0xFF1A2E50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title,
                        style: const TextStyle(color: Color(0xFFE6EDFF), fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(lesson.topic,
                        style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 12)),
                  ],
                )),
                if (lesson.isNow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFF3B6FF0), borderRadius: BorderRadius.circular(6)),
                    child: const Text('ŞİMDİ', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
              ]),
            ),
          );
        }),
      ),
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
        color: lesson.isNow ? const Color(0xFF102040) : const Color(0xFF0D1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lesson.isNow ? const Color(0xFF2A4A80) : const Color(0xFF162035),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(lesson.time,
                style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 12, fontWeight: FontWeight.w500)),
            if (lesson.isNow) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF3B6FF0), borderRadius: BorderRadius.circular(6)),
                child: const Text('ŞİMDİ',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ),
            ],
          ]),
          const SizedBox(height: 6),
          Text(lesson.title,
              style: const TextStyle(color: Color(0xFFE6EDFF), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(lesson.topic,
              style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 13)),
          const SizedBox(height: 10),
          Row(children: const [
            Icon(Icons.touch_app_rounded, color: Color(0xFF3B6FF0), size: 13),
            SizedBox(width: 4),
            Text('Detay için dokun', style: TextStyle(color: Color(0xFF3B6FF0), fontSize: 11, fontWeight: FontWeight.w500)),
          ]),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({required this.data, required this.onTap});
  final _MaterialData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 36, height: 36,
              decoration: BoxDecoration(color: data.color, borderRadius: BorderRadius.circular(10)),
              child: Icon(data.icon, color: data.iconColor, size: 20),
            ),
            const Spacer(),
            Text(data.type,
                style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(data.name,
                style: const TextStyle(color: Color(0xFFE6EDFF), fontSize: 13, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _OptimizeOption extends StatelessWidget {
  const _OptimizeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF162035),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFF1E3050), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF3B6FF0), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Color(0xFFE6EDFF), fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 12)),
            ],
          )),
          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7A8DAA), size: 14),
        ]),
      ),
    );
  }
}

class _LessonAction extends StatelessWidget {
  const _LessonAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF162035),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Icon(icon, color: const Color(0xFF3B6FF0), size: 22),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Color(0xFFBFD0FF), fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
