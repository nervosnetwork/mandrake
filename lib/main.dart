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
        primaryColor: Colors.red,
        accentColor: Colors.blue[600],
        secondaryHeaderColor: Colors.purple,
        backgroundColor: Colors.white,
        dialogBackgroundColor: Colors.grey[300],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.grey[900],
        secondaryHeaderColor: Colors.grey[600],
        backgroundColor: Color(0xff1d2022),
        dialogBackgroundColor: Colors.grey[600],
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
