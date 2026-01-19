import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_station/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const MetroApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
