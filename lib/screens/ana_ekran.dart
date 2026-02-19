import 'package:flutter/material.dart';

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
      body: const Center(child: Text('Ana ekran hazır.')),
    );
  }
}
