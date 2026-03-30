import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class FullAnalysisPage extends StatelessWidget {
  const FullAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Detaylı Analiz',
      subtitle: 'Sınav ve konu bazlı analizleri burada göstereceğiz.',
    );
  }
}

