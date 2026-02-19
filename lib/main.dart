import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';

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
