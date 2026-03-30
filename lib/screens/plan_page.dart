import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Plan',
      subtitle: 'Günlük planını burada yöneteceğiz.',
    );
  }
}

