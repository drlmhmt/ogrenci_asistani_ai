import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class WeakTopicPage extends StatelessWidget {
  const WeakTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Zayıf Konu',
      subtitle: 'Zayıf konularını burada yöneteceğiz.',
    );
  }
}

