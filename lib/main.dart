import 'package:flutter/material.dart';

import 'widgets/editor.dart';

void main() => runApp(MandrakeApp());

class MandrakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandrake',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        for (final path in paths) {
          final regExpPattern = RegExp(path.pattern);
          if (regExpPattern.hasMatch(settings.name)) {
            final firstMatch = regExpPattern.firstMatch(settings.name);
            final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
            print(match);
            return MaterialPageRoute<void>(
              builder: (context) => path.builder(context, match),
              settings: settings,
            );
          }
        }
        return null;
      },
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
    );
  }

  static List<_Path> paths = [
    _Path(
      r'^/gist/([\w-]+)$',
      (context, match) => Scaffold(body: Editor(gist: match)),
    ),
    _Path(
      r'^/',
      (context, match) => Scaffold(body: Editor()),
    ),
  ];
}

// Implemented in the way as per
// https://medium.com/flutter/flutter-web-navigating-urls-using-named-routes-307e1b1e2050
class _Path {
  const _Path(this.pattern, this.builder);

  final String pattern;
  final Widget Function(BuildContext, String) builder;
}
