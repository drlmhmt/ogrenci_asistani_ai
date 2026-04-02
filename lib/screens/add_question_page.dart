import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Soru ekleme — koyu tema, Figma/CSS ile uyumlu renk ve tipografi.
class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _topicController = TextEditingController();

  String? _courseValue = 'Ders Seçiniz';
  int _difficultyIndex = 0;

  static const _bgDeep = Color(0xFF0D1321);
  static const _labelAccent = Color(0xFFB1C5FF);

  static const _courses = <String>[
    'Ders Seçiniz',
    'Matematik',
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Türkçe',
    'Tarih',
  ];

  static const _difficulties = ['Başlangıç', 'Orta', 'Zor', 'Olimpiyat'];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _onAnalyze() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Analiz başlatılıyor…',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A2335),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const bottomBarHeight = 95.0;
    final scrollBottom = bottomBarHeight + bottomInset + 24;

    return Scaffold(
      backgroundColor: _bgDeep,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _PageBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(
                  onClose: () => Navigator.of(context).maybePop(),
                  titleStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: _labelAccent,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, scrollBottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BentoSection(
                          onCameraTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Kamera yakında.',
                                  style: GoogleFonts.manrope(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onGalleryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Galeri yakında.',
                                  style: GoogleFonts.manrope(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        _SectionLabel(
                          text: 'DERS VE KONU',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: _labelAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _CourseDropdown(
                          value: _courseValue,
                          items: _courses,
                          onChanged: (v) => setState(() => _courseValue = v),
                        ),
                        const SizedBox(height: 16),
                        _TopicField(
                          controller: _topicController,
                          hint: 'Konu başlığı yazın…',
                        ),
                        const SizedBox(height: 32),
                        _SectionLabel(
                          text: 'ZORLUK SEVİYESİ',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: _labelAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _DifficultyWrap(
                          difficulties: _difficulties,
                          selectedIndex: _difficultyIndex,
                          onSelect: (i) => setState(() => _difficultyIndex = i),
                        ),
                        const SizedBox(height: 32),
                        const _InsightCard(),
                        const SizedBox(height: 24),
                        _AnalyzeButton(
                          onPressed: _onAnalyze,
                          label: 'Soruyu Analiz Et',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomShell(height: bottomBarHeight + bottomInset),
          ),
        ],
      ),
    );
  }
}

class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 3.65,
          colors: [
            Color(0xFF0A1F44),
            Color(0xFF0D1321),
          ],
          stops: [0.0, 1.0],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onClose,
    required this.titleStyle,
  });

  final VoidCallback onClose;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1321).withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB1C5FF).withValues(alpha: 0.06),
                blurRadius: 48,
                offset: const Offset(0, 48),
              ),
            ],
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFFB1C5FF),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Soru Ekle',
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFB1C5FF).withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF0B1E3A),
                  backgroundImage: AssetImage('assets/Logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BentoSection extends StatelessWidget {
  const _BentoSection({
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GlassBentoCard(
          height: 194,
          onTap: onCameraTap,
          iconBackground: const Color(0xFF0D6EFD),
          iconShadow: [
            BoxShadow(
              color: const Color(0xFF0D6EFD).withValues(alpha: 0.4),
              blurRadius: 20,
            ),
          ],
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                color: Colors.white,
                size: 28,
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 10, color: Color(0xFF0D6EFD)),
                ),
              ),
            ],
          ),
          title: 'Fotoğraf Çek',
          subtitle: 'Soruyu anında tara',
        ),
        const SizedBox(height: 16),
        _GlassBentoCard(
          height: 194,
          onTap: onGalleryTap,
          iconBackground: const Color(0xFF2E3543),
          iconShadow: null,
          icon: const Icon(
            Icons.image_outlined,
            color: Color(0xFFB1C5FF),
            size: 28,
          ),
          title: 'Galeriden Seç',
          subtitle: 'Cihazındaki görselleri ekle',
        ),
      ],
    );
  }
}

class _GlassBentoCard extends StatelessWidget {
  const _GlassBentoCard({
    required this.height,
    required this.onTap,
    required this.iconBackground,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconShadow,
  });

  final double height;
  final VoidCallback onTap;
  final Color iconBackground;
  final List<BoxShadow>? iconShadow;
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(48),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: height,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(25, 32, 45, 0.7),
                border: Border.all(
                  color: const Color.fromRGBO(66, 70, 85, 0.15),
                ),
                borderRadius: BorderRadius.circular(48),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconBackground,
                      boxShadow: iconShadow,
                    ),
                    child: Center(child: icon),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      height: 28 / 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFDCE2F5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC2C6D8),
                    ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text.toUpperCase(), style: style),
    );
  }
}

class _CourseDropdown extends StatelessWidget {
  const _CourseDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF070E1B),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: const Color.fromRGBO(66, 70, 85, 0.15),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFC2C6D8),
          ),
          dropdownColor: const Color(0xFF151C29),
          style: GoogleFonts.manrope(
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFDCE2F5),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TopicField extends StatelessWidget {
  const _TopicField({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF070E1B),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: const Color.fromRGBO(66, 70, 85, 0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      child: TextField(
        controller: controller,
        style: GoogleFonts.manrope(
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFDCE2F5),
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            fontSize: 16,
            height: 22 / 16,
            color: const Color(0xFFC2C6D8).withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

class _DifficultyWrap extends StatelessWidget {
  const _DifficultyWrap({
    required this.difficulties,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> difficulties;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(difficulties.length, (i) {
        final selected = i == selectedIndex;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0D6EFD)
                    : const Color(0xFF232A38),
                borderRadius: BorderRadius.circular(999),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D6EFD).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                difficulties[i],
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? Colors.white
                      : const Color(0xFFC2C6D8),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(70, 119, 193, 0.1),
            border: Border.all(
              color: const Color(0xFFB1C5FF).withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(48),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB1C5FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFB1C5FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zeki İpucu',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB1C5FF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Soruyu kareye ortalayın, gölge ve yansımayı azaltın. '
                      'Net ve okunaklı bir görüntü, yapay zeka analizinin '
                      'doğruluğunu en üst düzeye yaklaştırır.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 23 / 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFC2C6D8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB1C5FF),
            Color(0xFF0D6EFD),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D6EFD).withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 28 / 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomShell extends StatelessWidget {
  const _BottomShell({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: height,
          padding: EdgeInsets.only(bottom: bottomPad),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1321).withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomItem(
                icon: Icons.home_outlined,
                label: 'Ana Sayfa',
                active: false,
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
              ),
              _BottomItem(
                icon: Icons.calendar_today_outlined,
                label: 'Plan',
                active: false,
                onTap: () {},
              ),
              _BottomFab(
                onTap: () {},
              ),
              _BottomItem(
                icon: Icons.timer_outlined,
                label: 'Odaklan',
                active: false,
                onTap: () {},
              ),
              _BottomItem(
                icon: Icons.show_chart_rounded,
                label: 'Analiz',
                active: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = active
        ? const Color(0xFF0D6EFD)
        : const Color(0xFF94A3B8);
    return Opacity(
      opacity: active ? 1 : 0.7,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: c),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    height: 15 / 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.25,
                    color: c,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomFab extends StatelessWidget {
  const _BottomFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 91,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D6EFD),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D6EFD).withValues(alpha: 0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                'Soru Sor',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  height: 15 / 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.25,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
