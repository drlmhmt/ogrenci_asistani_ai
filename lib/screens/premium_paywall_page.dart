import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class PremiumPaywallPage extends StatelessWidget {
  const PremiumPaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Premium',
      subtitle: 'Paywall ekranını burada tasarlayacağız.',
    );
  }
}

