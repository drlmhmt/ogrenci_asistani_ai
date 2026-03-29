import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanici Bilgileri'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Kullanici bilgileri formu burada yer alacak.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
