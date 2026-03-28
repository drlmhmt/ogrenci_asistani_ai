import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class ViewPlanPage extends StatelessWidget {
  const ViewPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Planı Gör',
      subtitle: 'Bugünkü planın detaylarını burada göstereceğiz.',
    );
  }
}

