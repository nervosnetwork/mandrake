import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    'googleClientId': Platform.environment['GOOGLE_CLIENT_ID'] ??
        '386449909060-3bghhjo9fsfrfroenpgdd3d7jjl34fr1.apps.googleusercontent.com',
  };

  final filename = 'lib/config.dart';
  await File(filename).writeAsString('final environment = ${json.encode(config)};');
}
