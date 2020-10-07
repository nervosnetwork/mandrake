import 'package:flutter/material.dart';

import 'widgets/editor.dart';

void main() => runApp(MandrakeApp());

class MandrakeApp extends StatefulWidget {
  @override
  _MandrakeAppState createState() => _MandrakeAppState();
}

class _MandrakeAppState extends State<MandrakeApp> {
  String _gistUrl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandrake',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('DefaultEditor'),
            child: Scaffold(
              body: Editor(),
            ),
          ),
          if (_gistUrl != null)
            MaterialPage(
              key: ValueKey(_gistUrl),
              child: Scaffold(
                body: Editor(gistUrl: _gistUrl),
              ),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          setState(() {
            _gistUrl = null;
          });

          return true;
        },
      ),
    );
  }
}
