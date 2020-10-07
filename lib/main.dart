import 'package:flutter/material.dart';

import 'widgets/editor.dart';

void main() => runApp(MandrakeApp());

class MandrakeApp extends StatefulWidget {
  @override
  _MandrakeAppState createState() => _MandrakeAppState();
}

class _MandrakeAppState extends State<MandrakeApp> {
  final RouterDelegate _routerDelegate = AppRouterDelegate();
  final RouteInformationParser _routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mandrake',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
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
    );
  }
}

class RoutePath {
  final String gistUrl;

  RoutePath.home() : gistUrl = null;
  RoutePath.gist(this.gistUrl);

  bool get isHomePage => gistUrl == null;
  bool get isGistPage => gistUrl != null;
}

class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  String _gistUrl;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  RoutePath get currentConfiguration {
    return _gistUrl == null ? RoutePath.home() : RoutePath.gist(_gistUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
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

        _gistUrl = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) {
    if (path.isGistPage) {
      _gistUrl = path.gistUrl;
    } else {
      _gistUrl = null;
    }
    return null;
  }
}

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // `/`
    if (uri.pathSegments.isEmpty) {
      return RoutePath.home();
    }

    // `/gist/:id`
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'gist') {
        return null;
      }
      var id = uri.pathSegments[1];
      return RoutePath.gist(id);
    }

    return null;
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isGistPage) {
      return RouteInformation(location: '/gist/${path.gistUrl}');
    }
    return null;
  }
}
