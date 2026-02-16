import 'package:flutter/material.dart';

void main() => runApp(const BilgiAIApp());

class BilgiAIApp extends StatelessWidget {
  const BilgiAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkran()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00184B),
      body: SizedBox.expand(
        child: Image(
          image: AssetImage('assets/Splash-1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1931),
        elevation: 0,
        leadingWidth: 64,
        leading: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text('Bilgi AI', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(child: Text('Logo ve Launch Testi Basarili!')),
    );
  }
}
