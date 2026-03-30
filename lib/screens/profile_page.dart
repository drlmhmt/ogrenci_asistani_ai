import 'package:flutter/material.dart';

import 'placeholder_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Profil',
      subtitle: 'Profil ayarlarını burada düzenleyeceğiz.',
    );
  }
}

