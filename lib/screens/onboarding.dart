import 'package:flutter/material.dart';

import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      assetPath: 'assets/onboarding/onboarding1.png',
      accentA: Color(0xFF9BB6FF),
      accentB: Color(0xFF1F6BFF),
      title: TextSpan(
        children: [
          TextSpan(text: 'Çalışmanı '),
          TextSpan(
            text: 'Akıllıca',
            style: TextStyle(color: Color(0xFF9BB6FF)),
          ),
          TextSpan(text: '\nPlanla'),
        ],
      ),
      description:
          'Yapay zekâ destekli asistanınla daha\ndüzenli çalış, potansiyelini ortaya\nçıkar.',
    ),
    _OnboardingSlide(
      assetPath: 'assets/onboarding/onboarding2.png',
      accentA: Color(0xFF2EE5D9),
      accentB: Color(0xFF2B7BFF),
      title: TextSpan(
        children: [
          TextSpan(text: 'Gelişimini\n'),
          TextSpan(
            text: 'Takip',
            style: TextStyle(color: Color(0xFF2EE5D9)),
          ),
          TextSpan(text: ' Et'),
        ],
      ),
      description:
          'Yapay zekâ analizleriyle nasıl\nçalıştığını keşfet, daha verimli ilerle\nve hedeflerine ulaş.',
    ),
    _OnboardingSlide(
      assetPath: 'assets/onboarding/onboarding3.png',
      accentA: Color(0xFFFF7AD9),
      accentB: Color(0xFF9B5CFF),
      title: TextSpan(
        children: [
          TextSpan(text: 'Kişisel\n'),
          TextSpan(
            text: 'Sistemini',
            style: TextStyle(color: Color(0xFFFF7AD9)),
          ),
          TextSpan(text: ' Kur'),
        ],
      ),
      description:
          'Hedeflerine özel optimize edilmiş yapay\nzekâ destekli çalışma programın seni\nbekliyor.',
    ),
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_currentPage == _slides.length - 1) {
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final isLastPage = _currentPage == _slides.length - 1;
    return Scaffold(
      backgroundColor: const Color(0xFF061022),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _OnboardingBackground(assetPath: _slides[index].assetPath);
              },
            ),
          ),
          Positioned.fill(
            child: _VividGlows(
              accentA: slide.accentA,
              accentB: slide.accentB,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x00061022),
                    Color.lerp(
                      Color.lerp(slide.accentA, slide.accentB, 0.65),
                      const Color(0xFF061022),
                      0.62,
                    )!
                        .withValues(alpha: 0.60),
                    const Color(0xFF061022).withValues(alpha: 0.96),
                  ],
                  stops: const [0.0, 0.66, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF9AA8C7),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      child: const Text('Geç'),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFE6EDFF),
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              height: 1.08,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.55,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 22),
                          _PageDots(
                            length: _slides.length,
                            index: _currentPage,
                            activeColor: slide.accentA,
                          ),
                          const SizedBox(height: 22),
                          _PrimaryActionButton(
                            label: isLastPage ? 'Başla' : 'İleri',
                            onTap: _nextStep,
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                slide.accentA,
                                slide.accentB,
                              ],
                            ),
                            shadowColor: slide.accentB,
                          ),
                        ],
                      ),
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

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground({required this.assetPath});

  final String assetPath;

  static final List<double> _vividMatrix = _saturationMatrix(1.22);

  static List<double> _saturationMatrix(double saturation) {
    final invSat = 1 - saturation;
    const r = 0.2126;
    const g = 0.7152;
    const b = 0.0722;

    final rInvSat = r * invSat;
    final gInvSat = g * invSat;
    final bInvSat = b * invSat;

    return [
      rInvSat + saturation,
      gInvSat,
      bInvSat,
      0,
      0,
      rInvSat,
      gInvSat + saturation,
      bInvSat,
      0,
      0,
      rInvSat,
      gInvSat,
      bInvSat + saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF061022),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topInset = MediaQuery.paddingOf(context).top;
          final topCrop = (constraints.maxHeight * 0.03) + (topInset * 0.6);

          return ClipRect(
            child: Transform.translate(
              offset: Offset(0, -topCrop),
              child: Transform.scale(
                scale: 1.18,
                alignment: Alignment.topCenter,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(_vividMatrix),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.length,
    required this.index,
    required this.activeColor,
  });

  final int length;
  final int index;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (dotIndex) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: index == dotIndex ? 34 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == dotIndex
                ? activeColor
                : const Color(0xFF26324A),
            borderRadius: BorderRadius.circular(999),
            boxShadow: index == dotIndex
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.45),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onTap,
    required this.gradient,
    required this.shadowColor,
  });

  final String label;
  final VoidCallback onTap;
  final Gradient gradient;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.26),
              blurRadius: 42,
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
                  fontSize: 20,
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

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.assetPath,
    required this.title,
    required this.description,
    required this.accentA,
    required this.accentB,
  });

  final String assetPath;
  final InlineSpan title;
  final String description;
  final Color accentA;
  final Color accentB;
}

class _VividGlows extends StatelessWidget {
  const _VividGlows({
    required this.accentA,
    required this.accentB,
  });

  final Color accentA;
  final Color accentB;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final glow = w * 0.95;

          return Stack(
            children: [
              Positioned(
                left: -glow * 0.35,
                top: -glow * 0.30,
                width: glow,
                height: glow,
                child: _RadialGlow(color: accentA, alpha: 0.40),
              ),
              Positioned(
                right: -glow * 0.40,
                top: -glow * 0.22,
                width: glow * 0.9,
                height: glow * 0.9,
                child: _RadialGlow(color: accentB, alpha: 0.32),
              ),
              Positioned(
                left: -glow * 0.10,
                bottom: -glow * 0.55,
                width: glow * 1.1,
                height: glow * 1.1,
                child: _RadialGlow(color: accentB, alpha: 0.26),
              ),
              Positioned(
                right: -glow * 0.18,
                bottom: -glow * 0.48,
                width: glow,
                height: glow,
                child: _RadialGlow(color: accentA, alpha: 0.22),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({
    required this.color,
    required this.alpha,
  });

  final Color color;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: alpha * 0.24),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
          radius: 0.85,
        ),
      ),
    );
  }
}
