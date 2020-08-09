import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mandrake/editor.dart';
import 'package:mandrake/object_library.dart';
import 'package:mandrake/property_inspector.dart';
import 'package:mandrake/toolbar.dart';
import 'package:mandrake/ruler.dart';

void main() {
  final app = MaterialApp(
    home: Scaffold(body: Editor()),
  );

  testWidgets('Editor shows template dialog on launch', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Choose a template'), findsOneWidget);
  });

  testWidgets('Main components', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(DesignEditor), findsOneWidget);
    expect(find.byType(ObjectLibrary), findsOneWidget);
    expect(find.byType(PropertyInspector), findsOneWidget);
    expect(find.byType(Toolbar), findsOneWidget);
    expect(find.byType(Ruler), findsNWidgets(2));
  });
}
