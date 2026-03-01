import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/ana_ekran.dart';
import 'screens/login_page.dart';
import 'screens/onboarding_screen.dart'; // onboarding sayfanın import'u
import 'services/onboarding_state_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashRouter(),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    // Firebase Auth'ın yerel oturum bilgisini yüklemesini bekle
    try {
      await FirebaseAuth.instance.authStateChanges().first
          .timeout(const Duration(seconds: 3));
    } catch (_) {}

    if (!mounted) return;

    final onboardingSeen = await OnboardingStateService().isOnboardingSeen();
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    // Navigator overlay ilk frame sonrası hazır olur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!onboardingSeen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AnaEkran()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00184B),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}