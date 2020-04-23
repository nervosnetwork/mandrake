// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mandrake/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MandrakeApp());

    expect(find.text('Booting'), findsOneWidget);
  });
}
