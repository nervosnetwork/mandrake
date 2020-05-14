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
        backgroundColor: Colors.white,
        primaryColor: Colors.red,
        accentColor: Colors.blue[600],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        backgroundColor: Color(0xff1d2022),
        accentColor: Colors.grey[900],
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
