import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mandrake/widgets/editor.dart';
import 'package:mandrake/widgets/object_library.dart';
import 'package:mandrake/widgets/property_inspector.dart';
import 'package:mandrake/widgets/toolbar.dart';
import 'package:mandrake/widgets/ruler.dart';

void main() {
  final app = MaterialApp(
    home: Scaffold(body: Editor()),
  );

  testWidgets('Editor does not show template dialog on launch', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'last-editing-doc': ''});
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Choose a template'), findsNothing);
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
