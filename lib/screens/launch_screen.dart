import 'package:flutter/material.dart';

import '../services/onboarding_state_service.dart';
import 'login_page.dart';
import 'onboarding_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final OnboardingStateService _onboardingStateService =
      OnboardingStateService();

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isOnboardingSeen = await _onboardingStateService.isOnboardingSeen();
    if (!mounted) return;

    final Widget nextScreen = isOnboardingSeen
        ? const LoginPage()
        : const OnboardingScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00184B),
      body: SizedBox.expand(
        child: Image(image: AssetImage('assets/Splash.jpg'), fit: BoxFit.cover),
      ),
    );
  }
}
