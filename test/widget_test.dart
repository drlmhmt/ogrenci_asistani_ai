// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:ogrenci_asistani/main.dart';
import 'package:ogrenci_asistani/screens/launch_screen.dart';
import 'package:ogrenci_asistani/screens/onboarding_screen.dart';

void main() {
  testWidgets('Launch screen then onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(LaunchScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    // Onboarding screen has repeating animations; avoid pumpAndSettle timeout.
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Çalışma Düzenini Yeniden Tasarla'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'İleri'), findsWidgets);
  });
}
