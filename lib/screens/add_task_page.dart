import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MOCK DATA — öğrenci tipine göre ders listeleri
// ─────────────────────────────────────────────────────────────────────────────
class _MockData {
  static const List<_StudentType> studentTypes = [
    _StudentType(id: 'yks', label: 'YKS', icon: Icons.school_rounded),
    _StudentType(id: 'lgs', label: 'LGS', icon: Icons.menu_book_rounded),
    _StudentType(id: 'kpss', label: 'KPSS', icon: Icons.account_balance_rounded),
    _StudentType(id: 'uni', label: 'Üniversite', icon: Icons.science_rounded),
    _StudentType(id: 'other', label: 'Diğer', icon: Icons.star_rounded),
  ];

  static const Map<String, List<String>> courses = {
    'yks': [
      'Matematik', 'Geometri', 'Fizik', 'Kimya', 'Biyoloji',
      'Türkçe', 'Edebiyat', 'Tarih', 'Coğrafya', 'Felsefe',
      'Mantık', 'İngilizce',
    ],
    'lgs': [
      'Matematik', 'Fen Bilimleri', 'Türkçe', 'İnkılap Tarihi',
      'Din Kültürü', 'İngilizce',
    ],
    'kpss': [
      'Genel Yetenek', 'Genel Kültür', 'Eğitim Bilimleri',
      'Türkçe', 'Matematik', 'Tarih', 'Coğrafya', 'Hukuk',
      'İktisat', 'Muhasebe',
    ],
    'uni': [
      'İleri Matematik', 'Veri Yapıları', 'Algoritmalar',
      'Fizik II', 'Kimya II', 'Akademik İngilizce',
      'Lineer Cebir', 'Olasılık & İstatistik',
      'İşletim Sistemleri', 'Veritabanı', 'Yazılım Mühendisliği',
    ],
    'other': [
      'Genel Tekrar', 'Proje', 'Okuma', 'Araştırma', 'Ödev', 'Diğer',
    ],
  };

  static const List<_TaskTemplate> templates = [
    _TaskTemplate(label: 'Konu Tekrarı', icon: Icons.refresh_rounded, duration: 45),
    _TaskTemplate(label: 'Soru Çöz', icon: Icons.edit_rounded, duration: 60),
    _TaskTemplate(label: 'Video İzle', icon: Icons.play_circle_rounded, duration: 30),
    _TaskTemplate(label: 'Deneme Sınavı', icon: Icons.assignment_rounded, duration: 180),
  ];
}

class _StudentType {
  const _StudentType({required this.id, required this.label, required this.icon});
  final String id;
  final String label;
  final IconData icon;
}

class _TaskTemplate {
  const _TaskTemplate({required this.label, required this.icon, required this.duration});
  final String label;
  final IconData icon;
  final int duration;
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFF061022);
  static const _card = Color(0xFF0D1B2E);
  static const _blue = Color(0xFF3B6FF0);
  static const _textPrimary = Color(0xFFE6EDFF);
  static const _textSecondary = Color(0xFF7A8DAA);
  static const _border = Color(0xFF162035);

  // Form state
  final _taskNameController = TextEditingController();
  final _durationController = TextEditingController(text: '45');
  final _formKey = GlobalKey<FormState>();

  String _selectedTypeId = 'yks';
  String? _selectedCourse;
  String _priority = 'ORTA'; // DÜŞÜK / ORTA / YÜKSEK
  bool _reminderEnabled = true;
  DateTime _reminderDate = DateTime.now().add(const Duration(hours: 2));

  late final AnimationController _heroAnim;
  late final Animation<double> _heroFade;

  @override
  void initState() {
    super.initState();
    _selectedCourse = _MockData.courses[_selectedTypeId]!.first;
    _heroAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _heroFade = CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut);
    _heroAnim.forward();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _durationController.dispose();
    _heroAnim.dispose();
    super.dispose();
  }

  List<String> get _courses => _MockData.courses[_selectedTypeId] ?? [];

  void _onTypeChanged(String id) {
    setState(() {
      _selectedTypeId = id;
      _selectedCourse = _MockData.courses[id]!.first;
    });
  }

  void _applyTemplate(_TaskTemplate t) {
    setState(() {
      _taskNameController.text = t.label;
      _durationController.text = t.duration.toString();
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: _blue, surface: Color(0xFF0D1B2E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _reminderDate = DateTime(picked.year, picked.month, picked.day,
          _reminderDate.hour, _reminderDate.minute));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderDate),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: _blue, surface: Color(0xFF0D1B2E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _reminderDate = DateTime(_reminderDate.year, _reminderDate.month,
          _reminderDate.day, picked.hour, picked.minute));
    }
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(
          '"${_taskNameController.text.isEmpty ? _selectedCourse! : _taskNameController.text}" görevi oluşturuldu!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        )),
      ]),
      backgroundColor: _blue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 2),
    ));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final botPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            const _TaskBg(),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, topPad, 0, botPad + 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  _buildHeroCard(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildTemplates(),
                        const SizedBox(height: 24),
                        _buildTaskNameField(),
                        const SizedBox(height: 16),
                        _buildStudentTypeSelector(),
                        const SizedBox(height: 16),
                        _buildCourseDropdown(),
                        const SizedBox(height: 16),
                        _buildDurationField(),
                        const SizedBox(height: 16),
                        _buildPrioritySelector(),
                        const SizedBox(height: 16),
                        _buildReminderCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildCreateButton(botPad),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1D35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E3050)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text('Yeni Görev',
              style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
        ),
        Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
          child: const Center(
            child: Text('AS', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeroCard() {
    return FadeTransition(
      opacity: _heroFade,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2040), Color(0xFF0A1628), Color(0xFF061022)],
          ),
          border: Border.all(color: const Color(0xFF1A2E50), width: 1),
        ),
        child: Stack(
          children: [
            // Dekoratif daireler
            Positioned(top: -30, right: -30,
              child: Container(width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    _blue.withValues(alpha: 0.25), Colors.transparent,
                  ]),
                )),
            ),
            Positioned(bottom: -40, left: 60,
              child: Container(width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF7B5EE8).withValues(alpha: 0.2), Colors.transparent,
                  ]),
                )),
            ),
            // İkon grid (dekoratif)
            Positioned(right: 16, top: 0, bottom: 0,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                _HeroIcon(icon: Icons.timer_rounded, color: _blue),
                const SizedBox(height: 10),
                _HeroIcon(icon: Icons.auto_awesome_rounded, color: const Color(0xFF9B6BFF)),
                const SizedBox(height: 10),
                _HeroIcon(icon: Icons.trending_up_rounded, color: const Color(0xFF4CAF50)),
              ]),
            ),
            // Yazı
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _blue.withValues(alpha: 0.4)),
                    ),
                    child: const Text('Odaklanma Zamanı',
                        style: TextStyle(color: _blue, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 10),
                  const Text('Yeni bir hedefe\nodaklan',
                      style: TextStyle(color: _textPrimary, fontSize: 26, fontWeight: FontWeight.w800,
                          letterSpacing: -0.6, height: 1.15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hızlı Şablon',
            style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _MockData.templates.map((t) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _applyTemplate(t),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(t.icon, color: _blue, size: 16),
                    const SizedBox(width: 8),
                    Text(t.label,
                        style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF162035),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${t.duration}dk',
                          style: const TextStyle(color: _textSecondary, fontSize: 11)),
                    ),
                  ]),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskNameField() {
    return _SectionCard(
      label: 'GÖREV ADI',
      icon: Icons.edit_rounded,
      child: TextFormField(
        controller: _taskNameController,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Örn: Kuantum Fiziği Ödevi',
          hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 15),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildStudentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('ÖĞRENCİ TİPİ',
              style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _MockData.studentTypes.map((t) {
              final selected = t.id == _selectedTypeId;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _onTypeChanged(t.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? _blue : _card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? _blue : _border),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(t.icon, color: selected ? Colors.white : _textSecondary, size: 15),
                      const SizedBox(width: 6),
                      Text(t.label,
                          style: TextStyle(
                            color: selected ? Colors.white : _textSecondary,
                            fontSize: 13, fontWeight: FontWeight.w600,
                          )),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDropdown() {
    return _SectionCard(
      label: 'DERS SEÇİMİ',
      icon: Icons.book_rounded,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCourse,
          isExpanded: true,
          dropdownColor: const Color(0xFF0D1B2E),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary),
          style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
          items: _courses.map((c) => DropdownMenuItem(
            value: c,
            child: Text(c),
          )).toList(),
          onChanged: (v) => setState(() => _selectedCourse = v),
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    return _SectionCard(
      label: 'HEDEF SÜRE',
      icon: Icons.timer_outlined,
      child: Row(children: [
        SizedBox(
          width: 70,
          child: TextFormField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
            validator: (v) => (v == null || v.isEmpty) ? 'Süre girin' : null,
          ),
        ),
        const Text('dakika', style: TextStyle(color: _textSecondary, fontSize: 15)),
        const Spacer(),
        // Hızlı süre butonları
        _DurationChip(label: '30', onTap: () => setState(() => _durationController.text = '30')),
        const SizedBox(width: 6),
        _DurationChip(label: '45', onTap: () => setState(() => _durationController.text = '45')),
        const SizedBox(width: 6),
        _DurationChip(label: '60', onTap: () => setState(() => _durationController.text = '60')),
        const SizedBox(width: 6),
        _DurationChip(label: '90', onTap: () => setState(() => _durationController.text = '90')),
      ]),
    );
  }

  Widget _buildPrioritySelector() {
    return _SectionCard(
      label: 'ÖNCELİK SEVİYESİ',
      icon: Icons.flag_rounded,
      child: Row(children: [
        _PriorityBtn(label: 'DÜŞÜK', selected: _priority == 'DÜŞÜK',
            color: const Color(0xFF4CAF50),
            onTap: () => setState(() => _priority = 'DÜŞÜK')),
        const SizedBox(width: 8),
        _PriorityBtn(label: 'ORTA', selected: _priority == 'ORTA',
            color: _blue,
            onTap: () => setState(() => _priority = 'ORTA')),
        const SizedBox(width: 8),
        _PriorityBtn(label: 'YÜKSEK', selected: _priority == 'YÜKSEK',
            color: const Color(0xFFFF6B6B),
            onTap: () => setState(() => _priority = 'YÜKSEK')),
      ]),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Başlık + toggle
        Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: const Color(0xFF162035), borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFFFB56A), size: 17),
          ),
          const SizedBox(width: 12),
          const Text('Hatırlatıcı Kur',
              style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          Switch.adaptive(
            value: _reminderEnabled,
            activeThumbColor: Colors.white,
            activeTrackColor: _blue,
            inactiveTrackColor: const Color(0xFF162035),
            onChanged: (v) => setState(() => _reminderEnabled = v),
          ),
        ]),
        if (_reminderEnabled) ...[
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1524),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Tarih', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_formatDate(_reminderDate),
                      style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                ]),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1524),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Saat', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_formatTime(_reminderDate),
                      style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                ]),
              ),
            )),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF162035),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: _textSecondary, size: 14),
              const SizedBox(width: 8),
              Text(_timeUntilReminder(),
                  style: const TextStyle(color: _textSecondary, fontSize: 12)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _buildCreateButton(double botPad) {
    return Positioned(
      left: 20, right: 20, bottom: botPad + 20,
      child: GestureDetector(
        onTap: _createTask,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A7FFF), Color(0xFF2B5CE6)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _blue.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.add_task_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Görevi Oluştur',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
            ]),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = ['', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return '${d.day} ${months[d.month]}\n${d.year}';
  }

  static String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _timeUntilReminder() {
    final diff = _reminderDate.difference(DateTime.now());
    if (diff.isNegative) return 'Hatırlatıcı geçmiş bir zamanda ayarlı';
    if (diff.inDays > 0) return '${diff.inDays} gün ${diff.inHours % 24} saat sonra hatırlatılacak';
    if (diff.inHours > 0) return '${diff.inHours} saat ${diff.inMinutes % 60} dakika sonra';
    return '${diff.inMinutes} dakika sonra hatırlatılacak';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TaskBg extends StatelessWidget {
  const _TaskBg();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFF0B1E3A), Color(0xFF07122A), Color(0xFF061022)],
        stops: [0.0, 0.4, 1.0],
      ),
    ),
    child: SizedBox.expand(),
  );
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withValues(alpha: 0.25)),
    ),
    child: Icon(icon, color: color, size: 20),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.label, required this.icon, required this.child});
  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 2),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF7A8DAA), size: 13),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ]),
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF162035)),
        ),
        child: child,
      ),
    ]);
  }
}

class _PriorityBtn extends StatelessWidget {
  const _PriorityBtn({required this.label, required this.selected, required this.color, required this.onTap});
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        decoration: BoxDecoration(
          color: selected ? color : const Color(0xFF0A1524),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : const Color(0xFF162035)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF7A8DAA),
                fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5,
              )),
        ),
      ),
    ),
  );
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1524),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF162035)),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF7A8DAA), fontSize: 12, fontWeight: FontWeight.w600)),
    ),
  );
}
