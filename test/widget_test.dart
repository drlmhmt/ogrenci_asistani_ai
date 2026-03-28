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
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    expect(find.text('Merhaba!'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsWidgets);
    expect(find.text('Şifremi Unuttum'), findsOneWidget);
    expect(find.textContaining('Henüz hesabın yok mu'), findsOneWidget);
    expect(find.text('Kayıt ol'), findsOneWidget);
  });
}
