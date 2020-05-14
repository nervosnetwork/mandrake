import 'package:flutter/material.dart';
import 'editor.dart';

void main() => runApp(MandrakeApp());

class MandrakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandrake',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Banner(
          message: 'INSIDER α',
          location: BannerLocation.topEnd,
          child: Editor(),
        ),
      ),
    );
  }
}
