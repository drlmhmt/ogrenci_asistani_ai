import 'package:flutter/material.dart';

import 'analysis_page.dart';
import 'home.dart';
import 'mentor_ai_page.dart';
import 'plan_page.dart';
import 'profile_page.dart';

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();

  static AppTabController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTabController>();
  }
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _index = 0;

  void _setIndex(int value) {
    if (value == _index) return;
    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    return AppTabController(
      index: _index,
      setIndex: _setIndex,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _index,
          children: const [
            HomePage(),
            PlanPage(),
            MentorAiPage(),
            AnalysisPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: _AppTabBar(
          currentIndex: _index,
          onTap: _setIndex,
        ),
      ),
    );
  }
}

class AppTabController extends InheritedWidget {
  const AppTabController({
    super.key,
    required this.index,
    required this.setIndex,
    required super.child,
  });

  final int index;
  final ValueChanged<int> setIndex;

  @override
  bool updateShouldNotify(covariant AppTabController oldWidget) {
    return oldWidget.index != index;
  }
}

class _AppTabBar extends StatelessWidget {
  const _AppTabBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _barColor = Color(0xFF061634);
  static const _baseHeight = 78.0;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final totalHeight = _baseHeight + bottomPad;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(34),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _barColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.28),
                      blurRadius: 28,
                      offset: const Offset(0, -14),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + bottomPad),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabItem(
                          index: 0,
                          label: 'Ana Sayfa',
                          selected: currentIndex == 0,
                          selectedAsset: 'assets/tab/home_selected.png',
                          unselectedAsset: 'assets/tab/home_unselected.png',
                          fallbackIcon: Icons.home_rounded,
                          onTap: onTap,
                        ),
                      ),
                      Expanded(
                        child: _TabItem(
                          index: 1,
                          label: 'Plan',
                          selected: currentIndex == 1,
                          selectedAsset: 'assets/tab/plan_selected.png',
                          unselectedAsset: 'assets/tab/plan_unselected.png',
                          fallbackIcon: Icons.fact_check_rounded,
                          onTap: onTap,
                        ),
                      ),
                      Expanded(
                        child: _TabLabel(
                          label: 'Mentor AI',
                          selected: currentIndex == 2,
                          onTap: () => onTap(2),
                          icon: const SizedBox(width: 24, height: 24),
                        ),
                      ),
                      Expanded(
                        child: _TabItem(
                          index: 3,
                          label: 'Analiz',
                          selected: currentIndex == 3,
                          selectedAsset: 'assets/tab/analysis_selected.png',
                          unselectedAsset: 'assets/tab/analysis_unselected.png',
                          fallbackIcon: Icons.show_chart_rounded,
                          onTap: onTap,
                        ),
                      ),
                      Expanded(
                        child: _TabItem(
                          index: 4,
                          label: 'Profil',
                          selected: currentIndex == 4,
                          selectedAsset: 'assets/tab/profile_selected.png',
                          unselectedAsset: 'assets/tab/profile_unselected.png',
                          fallbackIcon: Icons.person_rounded,
                          onTap: onTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: _MentorButton(
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorButton extends StatelessWidget {
  const _MentorButton({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF068EFF),
                Color(0xFF001644),
              ],
              stops: [0.29, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF068EFF).withValues(alpha: 0.26),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/mentorai.png',
              width: 54,
              height: 54,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.smart_toy_rounded,
                size: 38,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.index,
    required this.label,
    required this.selected,
    required this.selectedAsset,
    required this.unselectedAsset,
    required this.fallbackIcon,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool selected;
  final String selectedAsset;
  final String unselectedAsset;
  final IconData fallbackIcon;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return _TabLabel(
      label: label,
      selected: selected,
      onTap: () => onTap(index),
      icon: Image.asset(
        selected ? selectedAsset : unselectedAsset,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          fallbackIcon,
          size: 24,
          color: selected
              ? const Color(0xFF2B7BFF)
              : Colors.white.withValues(alpha: 0.82),
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF2B7BFF)
        : Colors.white.withValues(alpha: 0.82);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: color),
                  child: icon!,
                ),
                const SizedBox(height: 4),
              ],
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
