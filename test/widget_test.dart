import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ogrenci_asistani/screens/login_page.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  testWidgets('Login page shows primary actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Bilgi AI'), findsOneWidget);
    expect(find.text('Giriş yap'), findsOneWidget);
    expect(find.text('Şifremi unuttum'), findsOneWidget);
    expect(find.text('Hesabınız yok mu? Kayıt olun'), findsOneWidget);
  });
}
