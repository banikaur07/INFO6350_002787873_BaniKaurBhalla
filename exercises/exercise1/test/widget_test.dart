import 'package:exercise1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that the title text is displayed
    expect(find.text('Hello, World!'), findsOneWidget);

    // Verify that the app bar title is displayed
    expect(find.text('Hello World'), findsOneWidget);

    // Verify that the app contains a Scaffold widget
    expect(find.byType(Scaffold), findsOneWidget);

    // Verify that the app contains an AppBar widget
    expect(find.byType(AppBar), findsOneWidget);

    // Verify that the app contains a Center widget
    expect(find.byType(Center), findsOneWidget);
  });
}
