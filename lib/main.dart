import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/launch_screen.dart';

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
      home: LaunchScreen(),
    );
  }
}
