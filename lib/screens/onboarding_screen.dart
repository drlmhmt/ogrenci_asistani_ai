import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'ana_ekran.dart';

const double _goalCardHeight = 70;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activePageIndex = 0;
  int _selectedGoalIndex = 1;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep.image(
      lottiePath: 'assets/Onboarding1.json',
      title: 'Çalışma Düzenini Yeniden Tasarla',
      subtitle:
          'Hedeflerini belirle, planını oluştur ve ilerlemeni tek bir yerden yönet.',
      backgroundColor: Color(0xFF090909),
    ),
    _OnboardingStep.image(
      lottiePath: 'assets/Onboarding2.json',
      title: 'Gelişimini Gör',
      subtitle:
          'Çözdüğün testleri analiz et, eksiklerini keşfet ve güçlü yönlerini pekiştir.',
      backgroundColor: Color(0xFF0C0B0B),
    ),
    _OnboardingStep.goals(
      title: 'Sana Özel Bir Deneyim',
      subtitle:
          'Hedefini seç, çalışma tarzını belirle. Uygulama senin ritmine uyum sağlasın',
      backgroundColor: Color(0xFF07080B),
    ),
  ];

  final List<_GoalItem> _goalItems = const [
    _GoalItem(
      icon: Icons.school_rounded,
      text: 'Üniversite Sınavına Hazırlanıyorum',
    ),
    _GoalItem(
      icon: Icons.account_balance_rounded,
      text: 'KPSS / Kamu Sınavlarına Hazırlanıyorum',
    ),
    _GoalItem(
      icon: Icons.insert_chart_rounded,
      text: 'Deneme Performansımı Artırmak İstiyorum',
    ),
    _GoalItem(
      icon: Icons.menu_book_rounded,
      text: 'Okul Derslerimi Takip Etmek İstiyorum',
    ),
    _GoalItem(
      icon: Icons.alarm_rounded,
      text: 'Daha Disiplinli ve Planlı Çalışmak İstiyorum',
    ),
    _GoalItem(
      icon: Icons.rocket_launch_rounded,
      text: 'Genel Akademik Gelişim',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final bool isLastPage = _activePageIndex == _steps.length - 1;
    if (isLastPage) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkran()),
      );
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _steps.length,
        onPageChanged: (index) {
          setState(() {
            _activePageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final _OnboardingStep step = _steps[index];
          return ColoredBox(
            color: step.backgroundColor,
            child: step.type == _OnboardingStepType.image
                ? _ImageStepContent(
                    step: step,
                    dots: _PageDots(
                      totalPages: _steps.length,
                      activeIndex: _activePageIndex,
                    ),
                    continueButton: _ContinueButton(
                      label: 'İleri',
                      onPressed: _handleContinue,
                    ),
                  )
                : _GoalsStepContent(
                    step: step,
                    goalItems: _goalItems,
                    selectedGoalIndex: _selectedGoalIndex,
                    onGoalTap: (goalIndex) {
                      setState(() {
                        _selectedGoalIndex = goalIndex;
                      });
                    },
                    dots: _PageDots(
                      totalPages: _steps.length,
                      activeIndex: _activePageIndex,
                    ),
                    continueButton: _ContinueButton(
                      label: 'İleri',
                      onPressed: _handleContinue,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _ImageStepContent extends StatelessWidget {
  final _OnboardingStep step;
  final Widget dots;
  final Widget continueButton;

  const _ImageStepContent({
    required this.step,
    required this.dots,
    required this.continueButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _AnimatedAssetScene(
              imagePath: step.imagePath,
              lottiePath: step.lottiePath,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool shouldScroll = constraints.maxHeight < 210;

                  Widget headerBlock() {
                    return Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -4),
                          child: Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9AA0AA),
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        dots,
                      ],
                    );
                  }

                  if (shouldScroll) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          headerBlock(),
                          const SizedBox(height: 10),
                          continueButton,
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      headerBlock(),
                      const Spacer(),
                      continueButton,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedAssetScene extends StatelessWidget {
  final String? imagePath;
  final String? lottiePath;

  const _AnimatedAssetScene({
    this.imagePath,
    this.lottiePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (lottiePath != null)
          Positioned.fill(
            child: Lottie.asset(
              lottiePath!,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
              frameRate: FrameRate.max,
            ),
          )
        else if (imagePath != null)
          Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
          ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x03000000), Color(0x1F000000)],
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalsStepContent extends StatelessWidget {
  final _OnboardingStep step;
  final List<_GoalItem> goalItems;
  final int selectedGoalIndex;
  final ValueChanged<int> onGoalTap;
  final Widget dots;
  final Widget continueButton;

  const _GoalsStepContent({
    required this.step,
    required this.goalItems,
    required this.selectedGoalIndex,
    required this.onGoalTap,
    required this.dots,
    required this.continueButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          right: -80,
          child: Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: const Color(0x223A5FFF),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -50,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0x1C00C6FF),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 22),
            child: Column(
              children: [
                const _PulseBadge(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    step.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    step.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFAAB1BC),
                      fontSize: 15,
                      height: 1.32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double requiredHeight =
                          (goalItems.length * _goalCardHeight) +
                              ((goalItems.length - 1) * 10);
                      final bool shouldScroll =
                          requiredHeight > constraints.maxHeight;

                      return ListView.separated(
                        primary: false,
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        physics: shouldScroll
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemCount: goalItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final _GoalItem item = goalItems[index];
                          final bool isSelected = index == selectedGoalIndex;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: _goalCardHeight,
                              child: _GoalCard(
                                item: item,
                                isSelected: isSelected,
                                onTap: () => onGoalTap(index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                dots,
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: continueButton,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseBadge extends StatefulWidget {
  const _PulseBadge();

  @override
  State<_PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<_PulseBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(begin: 1, end: 1.06).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF18366B), Color(0xFF111F39)],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0x883E6CFF),
            width: 1.2,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Color(0xFFC9D8FF), size: 16),
            SizedBox(width: 6),
            Text(
              'Kişiselleştirilmiş Akış',
              style: TextStyle(
                color: Color(0xFFC9D8FF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final _GoalItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      scale: isSelected ? 1.008 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? const [Color(0xFF18366E), Color(0xFF112448)]
                : const [Color(0xFF13223D), Color(0xFF101C33)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF4E73FF) : const Color(0x1FFFFFFF),
            width: isSelected ? 1.2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x2F4E73FF),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(item.icon, color: Colors.white, size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.18,
                      ),
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

class _PageDots extends StatelessWidget {
  final int totalPages;
  final int activeIndex;

  const _PageDots({
    required this.totalPages,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (dotIndex) {
        final bool isSelected = dotIndex == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isSelected ? 24 : 8,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0x66FFFFFF),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ContinueButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

enum _OnboardingStepType {
  image,
  goals,
}

class _OnboardingStep {
  final _OnboardingStepType type;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final String? imagePath;
  final String? lottiePath;

  const _OnboardingStep.image({
    this.imagePath,
    this.lottiePath,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
  })  : assert(imagePath != null || lottiePath != null),
        type = _OnboardingStepType.image;

  const _OnboardingStep.goals({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
  })  : type = _OnboardingStepType.goals,
        imagePath = null,
        lottiePath = null;
}

class _GoalItem {
  final IconData icon;
  final String text;

  const _GoalItem({
    required this.icon,
    required this.text,
  });
}
