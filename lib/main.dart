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
    final onboardingSeen = await OnboardingStateService().isOnboardingSeen();
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (!onboardingSeen) {
      // Onboarding hiç görülmemiş
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else if (user != null && user.emailVerified) {
      // Giriş yapmış ve doğrulanmış
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaEkran()),
      );
    } else {
      // Onboarding görülmüş ama giriş yapılmamış
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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