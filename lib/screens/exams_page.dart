import 'package:flutter/material.dart';

import 'field_selection_page.dart';

const List<ExamOption> examOptions = [
  ExamOption(
    key: 'yks',
    title: 'YKS',
    yearLabel: '2026',
    subtitle: 'Üniversite hedefi için TYT ve AYT odaklı hazırlık akışı.',
    icon: Icons.school_rounded,
    accentA: Color(0xFF59A7FF),
    accentB: Color(0xFF226BFF),
    surfaceColor: Color(0xFF1A2437),
    minScore: 100,
    maxScore: 500,
    scoreUnit: 'puan',
    guidance:
        'YKS puanı 100-500 bandındadır. Hedef puanın ne kadar yüksekse çalışma programı o kadar yoğunlaşır.',
    fields: [
      ExamField(
        key: 'sayisal',
        title: 'Sayısal',
        subtitle: 'Mühendislik, tıp ve fen bölümleri için uygun alan.',
        icon: Icons.functions_rounded,
      ),
      ExamField(
        key: 'esit_agirlik',
        title: 'Eşit Ağırlık',
        subtitle: 'Hukuk, işletme ve psikoloji gibi bölümler için dengeli alan.',
        icon: Icons.balance_rounded,
      ),
      ExamField(
        key: 'sozel',
        title: 'Sözel',
        subtitle: 'Edebiyat, iletişim ve tarih odaklı bölümler için uygun alan.',
        icon: Icons.menu_book_rounded,
      ),
      ExamField(
        key: 'dil',
        title: 'Dil',
        subtitle: 'Yabancı dil bölümleri ve öğretmenlikler için uygun alan.',
        icon: Icons.language_rounded,
      ),
    ],
  ),
  ExamOption(
    key: 'lgs',
    title: 'LGS',
    yearLabel: '2026',
    subtitle: 'Lise yerleştirme için resmî merkezi sınav hazırlığı.',
    icon: Icons.emoji_events_rounded,
    accentA: Color(0xFF6AE4C8),
    accentB: Color(0xFF0EAE8D),
    surfaceColor: Color(0xFF172C31),
    minScore: 100,
    maxScore: 500,
    scoreUnit: 'puan',
    guidance:
        'LGS puanı 100-500 aralığında değerlendirilir. Yüksek yüzdelik dilim için hedefini 400 üstünde tutmak avantaj sağlar.',
    fields: [
      ExamField(
        key: 'nitelikli_okul',
        title: 'Nitelikli Okul',
        subtitle: 'Fen lisesi, Anadolu lisesi ve proje okulu hedefi.',
        icon: Icons.apartment_rounded,
      ),
      ExamField(
        key: 'fen_lisesi',
        title: 'Fen Lisesi',
        subtitle: 'Sayısal ağırlıklı üst düzey lise hedefi.',
        icon: Icons.biotech_rounded,
      ),
      ExamField(
        key: 'anadolu_lisesi',
        title: 'Anadolu Lisesi',
        subtitle: 'Dengeli akademik program sunan lise seçeneği.',
        icon: Icons.auto_stories_rounded,
      ),
    ],
  ),
  ExamOption(
    key: 'kpss',
    title: 'KPSS',
    yearLabel: '2026',
    subtitle: 'Kamu personeli yerleştirmeleri için resmî seçme sınavı.',
    icon: Icons.business_center_rounded,
    accentA: Color(0xFFFFBE64),
    accentB: Color(0xFFFF7B54),
    surfaceColor: Color(0xFF31251B),
    minScore: 40,
    maxScore: 100,
    scoreUnit: 'puan',
    guidance:
        'KPSS puanı oturuma göre 40-100 bandında odaklanır. Hedef kadro için genelde 80+ puan rekabet avantajıdır.',
    fields: [
      ExamField(
        key: 'b_grubu',
        title: 'B Grubu',
        subtitle: 'Genel memurluk ve uzman yardımcılığı hedefleri.',
        icon: Icons.badge_rounded,
      ),
      ExamField(
        key: 'ogretmenlik',
        title: 'Öğretmenlik',
        subtitle: 'Eğitim bilimleri ve OABT ile öğretmen atamaları.',
        icon: Icons.cast_for_education_rounded,
      ),
      ExamField(
        key: 'a_grubu',
        title: 'A Grubu',
        subtitle: 'Müfettişlik, uzmanlık ve denetmenlik kadroları.',
        icon: Icons.account_balance_rounded,
      ),
    ],
  ),
  ExamOption(
    key: 'ales',
    title: 'ALES',
    yearLabel: '2026',
    subtitle: 'Lisansüstü başvurular ve akademik kadrolar için kullanılır.',
    icon: Icons.psychology_alt_rounded,
    accentA: Color(0xFFD496FF),
    accentB: Color(0xFF8A46FF),
    surfaceColor: Color(0xFF281C35),
    minScore: 50,
    maxScore: 100,
    scoreUnit: 'puan',
    guidance:
        'ALES sayısal, sözel ve eşit ağırlık puan türleriyle 50-100 aralığında değerlendirilir.',
    fields: [
      ExamField(
        key: 'sayisal',
        title: 'Sayısal',
        subtitle: 'Mühendislik ve fen alanları için daha kritik puan türü.',
        icon: Icons.calculate_rounded,
      ),
      ExamField(
        key: 'sozel',
        title: 'Sözel',
        subtitle: 'Sosyal bilimler ve iletişim alanları için uygun puan türü.',
        icon: Icons.history_edu_rounded,
      ),
      ExamField(
        key: 'esit_agirlik',
        title: 'Eşit Ağırlık',
        subtitle: 'Yönetim, hukuk ve benzeri alanlar için dengeli puan türü.',
        icon: Icons.scale_rounded,
      ),
    ],
  ),
  ExamOption(
    key: 'dgs',
    title: 'DGS',
    yearLabel: '2026',
    subtitle: 'Ön lisans mezunlarının lisansa geçişi için kullanılır.',
    icon: Icons.sync_alt_rounded,
    accentA: Color(0xFF7CD7FF),
    accentB: Color(0xFF1B91D7),
    surfaceColor: Color(0xFF182B37),
    minScore: 120,
    maxScore: 360,
    scoreUnit: 'puan',
    guidance:
        'DGS puanı 120-360 bandında hesaplanır. Hedef bölüme göre sayısal ya da eşit ağırlık odağı belirlenir.',
    fields: [
      ExamField(
        key: 'sayisal',
        title: 'Sayısal',
        subtitle: 'Mühendislik ve teknik lisans programları için uygun tür.',
        icon: Icons.architecture_rounded,
      ),
      ExamField(
        key: 'esit_agirlik',
        title: 'Eşit Ağırlık',
        subtitle: 'İşletme, ekonomi ve benzeri lisans programları için uygun tür.',
        icon: Icons.account_tree_rounded,
      ),
    ],
  ),
  ExamOption(
    key: 'yds',
    title: 'YDS',
    yearLabel: '2026',
    subtitle: 'Yabancı dil yeterliliğini gösteren resmî dil sınavı.',
    icon: Icons.translate_rounded,
    accentA: Color(0xFFFF8FA3),
    accentB: Color(0xFFE2497B),
    surfaceColor: Color(0xFF381D2A),
    minScore: 20,
    maxScore: 100,
    scoreUnit: 'puan',
    guidance:
        'YDS puanı 20-100 bandındadır. Akademik ve kurumsal başvurular için genelde 70+ hedeflenir.',
    fields: [
      ExamField(
        key: 'ingilizce',
        title: 'İngilizce',
        subtitle: 'En yaygın tercih edilen yabancı dil oturumu.',
        icon: Icons.language_rounded,
      ),
      ExamField(
        key: 'almanca',
        title: 'Almanca',
        subtitle: 'Almanca yeterlilik hedefleyen adaylar için uygun oturum.',
        icon: Icons.public_rounded,
      ),
      ExamField(
        key: 'fransizca',
        title: 'Fransızca',
        subtitle: 'Fransızca akademik veya kurumsal başvurular için uygun oturum.',
        icon: Icons.travel_explore_rounded,
      ),
      ExamField(
        key: 'arapca',
        title: 'Arapça',
        subtitle: 'Arapça yeterlilik göstermek isteyen adaylar için uygun oturum.',
        icon: Icons.forum_rounded,
      ),
    ],
  ),
];

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  ExamOption _selectedExam = examOptions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08111F),
      body: Stack(
        children: [
          const _ScreenBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Hedefini Belirle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Başlamadan önce hangi sınava hazırlandığını seç. AI asistanı planlarını buna göre optimize etsin.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: examOptions
                            .map(
                              (exam) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _ExamCard(
                                  exam: exam,
                                  isSelected: exam.key == _selectedExam.key,
                                  onTap: () => setState(() => _selectedExam = exam),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FlowActionButton(
                    label: 'İlerle',
                    startColor: _selectedExam.accentA,
                    endColor: _selectedExam.accentB,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FieldSelectionPage(exam: _selectedExam),
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
    );
  }
}

class ExamOption {
  const ExamOption({
    required this.key,
    required this.title,
    required this.yearLabel,
    required this.subtitle,
    required this.icon,
    required this.accentA,
    required this.accentB,
    required this.surfaceColor,
    required this.minScore,
    required this.maxScore,
    required this.scoreUnit,
    required this.guidance,
    required this.fields,
  });

  final String key;
  final String title;
  final String yearLabel;
  final String subtitle;
  final IconData icon;
  final Color accentA;
  final Color accentB;
  final Color surfaceColor;
  final double minScore;
  final double maxScore;
  final String scoreUnit;
  final String guidance;
  final List<ExamField> fields;
}

class ExamField {
  const ExamField({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({
    required this.exam,
    required this.isSelected,
    required this.onTap,
  });

  final ExamOption exam;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? exam.accentA.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.08);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            exam.surfaceColor,
            exam.surfaceColor.withValues(alpha: 0.94),
          ],
        ),
        border: Border.all(color: borderColor, width: 1.4),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: exam.accentB.withValues(alpha: 0.28),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [exam.accentA, exam.accentB],
                    ),
                  ),
                  child: Icon(exam.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exam.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            child: Text(
                              exam.yearLabel,
                              style: TextStyle(
                                color: exam.accentA,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exam.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 15,
                          height: 1.45,
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
                      : Colors.white.withValues(alpha: 0.34),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenBackground extends StatelessWidget {
  const _ScreenBackground();

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
                  Color(0xFF2576F6),
                  Color(0xFF1248AF),
                  Color(0xFF0A235C),
                  Color(0xFF07152E),
                ],
                stops: [0, 0.26, 0.62, 1],
              ),
            ),
          ),
          Positioned(
            top: -110,
            left: -30,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7CC7FF).withValues(alpha: 0.42),
                      const Color(0xFF7CC7FF).withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.35, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -90,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF34B7FF).withValues(alpha: 0.24),
                      const Color(0xFF34B7FF).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.42, 1],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1E5FFF).withValues(alpha: 0.18),
                      const Color(0xFF1E5FFF).withValues(alpha: 0.04),
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
                      Colors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                      const Color(0xFF56B6FF).withValues(alpha: 0.03),
                    ],
                    stops: const [0, 0.46, 1],
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
                  const Color(0xFF08111F).withValues(alpha: 0.3),
                  const Color(0xFF08111F),
                ],
                stops: const [0, 0.45, 1],
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
