import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_page.dart';
import 'screens/onboarding.dart';
import 'services/onboarding_state_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BilgiAIApp());
}

class BilgiAIApp extends StatelessWidget {
  const BilgiAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _AppEntryPoint(),
    );
  }
}

class _AppEntryPoint extends StatelessWidget {
  const _AppEntryPoint();

  @override
  Widget build(BuildContext context) {
    final onboardingStateService = OnboardingStateService();

    return FutureBuilder<bool>(
      future: onboardingStateService.isOnboardingSeen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF061022),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5B9DFF),
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return const LoginPage();
        }

        return const OnboardingPage();
      },
    );
  }
}
