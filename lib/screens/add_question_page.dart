import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class AddQuestionPage extends StatelessWidget {
  const AddQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Soru Ekle',
      subtitle: 'Yeni soru ekleme akışı burada olacak.',
    );
  }
}

