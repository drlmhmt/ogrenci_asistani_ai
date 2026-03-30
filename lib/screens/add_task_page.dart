import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Görev Ekle',
      subtitle: 'Yeni görev ekleme ekranı burada olacak.',
    );
  }
}

