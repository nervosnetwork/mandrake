import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mandrake/editor.dart';

void main() {
  final app = MaterialApp(
    home: Scaffold(body: Editor()),
  );

  testWidgets('Editor shows template dialog on launch', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text('Choose a template'), findsOneWidget);
  });
}
