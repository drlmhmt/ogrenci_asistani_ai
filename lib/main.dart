import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';
import 'screens/onboarding.dart';
import 'screens/main_tab_scaffold.dart';
import 'screens/timer_page.dart';
import 'services/onboarding_state_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_controller_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final themeController = ThemeController(prefs);
  await themeController.load();
  runApp(BilgiAIApp(themeController: themeController));
}

class BilgiAIApp extends StatelessWidget {
  const BilgiAIApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    // Scope, MaterialApp'in üstünde olmalı; aksi halde bazı bağlamlarda
    // (builder child'ı gecikmeli vb.) ThemeControllerScope bulunamıyor.
    return ThemeControllerScope(
      controller: themeController,
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: themeController.themeMode,
            home: const TimerPage(),
          );
        },
      ),
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
          return const _SplashScreen();
        }

        if (snapshot.data == false) {
          return const OnboardingPage();
        }

        return const _AuthGate();
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        return const MainTabScaffold();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF061022),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9BB6FF)),
        ),
      ),
    );
  }
}
