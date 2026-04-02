import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'full_analysis_page.dart';

/// Sınav analizi / sınav sonucu — Figma/CSS ile uyumlu koyu tema.
class ExamResultPage extends StatelessWidget {
  const ExamResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const bottomBarHeight = 91.0;
    final scrollBottom = bottomBarHeight + bottomInset + 24;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _PageBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ExamTopBar(
                  onBack: () => Navigator.of(context).maybePop(),
                  titleStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: const Color(0xFFB1C5FF),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, scrollBottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _HeroExamCard(),
                        const SizedBox(height: 24),
                        _SubjectResultCard(
                          title: 'Matematik',
                          questionCount: '40 Soru',
                          iconBackground: const Color(0xFFB1C5FF).withValues(alpha: 0.1),
                          leading: Text(
                            'Σ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB1C5FF),
                            ),
                          ),
                          correct: '0',
                          wrong: '0',
                          empty: '40',
                        ),
                        const SizedBox(height: 16),
                        _SubjectResultCard(
                          title: 'Fen Bilimleri',
                          questionCount: '40 Soru',
                          iconBackground: const Color(0xFFA9C7FF).withValues(alpha: 0.1),
                          leading: Icon(
                            Icons.science_outlined,
                            color: const Color(0xFFA9C7FF),
                            size: 22,
                          ),
                          correct: '0',
                          wrong: '0',
                          empty: '40',
                        ),
                        const SizedBox(height: 24),
                        const _SmartCalculationCard(),
                        const SizedBox(height: 24),
                        _AssistantNoteCard(
                          onDetailTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const FullAnalysisPage(),
                              ),
                            );
                          },
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
            child: _ExamBottomShell(height: bottomBarHeight + bottomInset),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF0D1321)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1),
                radius: 1.75,
                colors: [
                  const Color(0xFF0D6EFD).withValues(alpha: 0.15),
                  const Color(0xFF0D6EFD).withValues(alpha: 0),
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomRight,
                radius: 1.5,
                colors: [
                  const Color(0xFFB1C5FF).withValues(alpha: 0.05),
                  const Color(0xFFB1C5FF).withValues(alpha: 0),
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExamTopBar extends StatelessWidget {
  const _ExamTopBar({
    required this.onBack,
    required this.titleStyle,
  });

  final VoidCallback onBack;
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
                  onTap: onBack,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: const Color(0xFFB1C5FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Sınav Analizi',
                  style: titleStyle,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D6EFD),
                  border: Border.all(
                    color: const Color(0xFFB1C5FF).withValues(alpha: 0.2),
                  ),
                ),
                child: const CircleAvatar(
                  radius: 14,
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

class _HeroExamCard extends StatelessWidget {
  const _HeroExamCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A1F44),
            Color(0xFF0D6EFD),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Text(
                      'DENEME SINAVI',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        height: 15 / 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: const Color(0xFFDAE2FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Türkiye Geneli AYT-2',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      height: 30 / 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '24 Mayıs 2024',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '180 Dakika',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'TOPLAM NET',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                height: 15 / 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '0.00',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 60,
                                height: 1.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFFB1C5FF)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _SubjectResultCard extends StatelessWidget {
  const _SubjectResultCard({
    required this.title,
    required this.questionCount,
    required this.leading,
    required this.iconBackground,
    required this.correct,
    required this.wrong,
    required this.empty,
  });

  final String title;
  final String questionCount;
  final Widget leading;
  final Color iconBackground;
  final String correct;
  final String wrong;
  final String empty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151C29),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color.fromRGBO(66, 70, 85, 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: leading,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    height: 28 / 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDCE2F5),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3543),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  questionCount,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    height: 15 / 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC2C6D8).withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'DOĞRU',
                  value: correct,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'YANLIŞ',
                  value: wrong,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'BOŞ',
                  value: empty,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(7, 14, 27, 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(66, 70, 85, 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 9,
              height: 14 / 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC2C6D8).withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              height: 27 / 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmartCalculationCard extends StatelessWidget {
  const _SmartCalculationCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFB1C5FF).withValues(alpha: 0.2),
                    const Color(0xFFA9C7FF).withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(35, 42, 56, 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFB1C5FF),
                          Color(0xFFA9C7FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB1C5FF).withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Akıllı Hesaplama',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      height: 28 / 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Girdiğin verilere göre sınav analizini ve netlerini anında hesapla.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      height: 23 / 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFC2C6D8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: const Color(0xFFB1C5FF),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Net hesaplama yakında.',
                              style: GoogleFonts.manrope(),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB1C5FF)
                                  .withValues(alpha: 0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 20),
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Text(
                          'Netleri Hesapla',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AssistantNoteCard extends StatelessWidget {
  const _AssistantNoteCard({required this.onDetailTap});

  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151C29),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color.fromRGBO(66, 70, 85, 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ASİSTAN NOTU',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              height: 15 / 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: const Color(0xFFC2C6D8).withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 1.5,
                height: 91,
                decoration: BoxDecoration(
                  color: const Color(0xFFB1C5FF).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Sonuçların geçen aya göre daha tutarlı görünüyor. '
                  'Matematikte boş sayın yüksek; net artışı için önce '
                  'güvenli soruları tamamlamayı dene.',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    height: 23 / 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFC2C6D8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Material(
            color: const Color(0xFFB1C5FF).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onDetailTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.show_chart_rounded,
                      size: 18,
                      color: Color(0xFFB1C5FF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Detaylı Analiz Gör',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB1C5FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamBottomShell extends StatelessWidget {
  const _ExamBottomShell({required this.height});

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
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              _BottomItem(
                icon: Icons.calendar_today_outlined,
                label: 'Plan',
                active: false,
                onTap: () {},
              ),
              _BottomActivePill(
                icon: Icons.show_chart_rounded,
                label: 'Analiz',
                onTap: () {},
              ),
              _BottomItem(
                icon: Icons.timer_outlined,
                label: 'Odaklan',
                active: false,
                onTap: () {},
              ),
              _BottomItem(
                icon: Icons.add_a_photo_outlined,
                label: 'Soru Sor',
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
            width: 52,
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

class _BottomActivePill extends StatelessWidget {
  const _BottomActivePill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D6EFD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
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
