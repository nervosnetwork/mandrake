import 'package:flutter/material.dart';
import 'editor.dart';

void main() => runApp(MandrakeApp());

class MandrakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandrake',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Editor(),
      ),
    );
  }
}
