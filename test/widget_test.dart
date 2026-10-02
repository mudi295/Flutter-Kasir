import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kasir/app.dart';

void main() {
  testWidgets('KasirApp boots to splash', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const KasirApp());
    // Splash shows branding immediately
    expect(find.text('Kasir Premium'), findsOneWidget);
    expect(find.byIcon(Icons.point_of_sale_rounded), findsOneWidget);
    // Let splash timer + navigation finish
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    // Should navigate to login (not logged in by default)
    expect(find.text('Login Kasir'), findsOneWidget);
  });
}
