import 'package:universal_io/io.dart';
import 'dart:convert';

import '../models/document.dart';

class Gist {
  String url;
  String id;

  Gist(this.url, this.id);
}

class GistDocWriter {
  GistDocWriter(this._doc, this._filename, this._token);
  final Document _doc;
  final String _filename;
  final String _token;

  // Return gist URL if successful.
  Future<Gist> write() async {
    final endpoint = 'https://api.github.com/gists';
    final content = JsonEncoder.withIndent('  ').convert(_doc);
    final body = {
      'public': true,
      'files': {
        _filename ?? 'untitled.json': {'content': content}
      },
    };

    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse(endpoint));
    request.headers.add(HttpHeaders.authorizationHeader, 'token $_token');
    request.add(utf8.encode(jsonEncode(body)));

    final response = await request.close();
    final result = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(result);
    return Gist(decoded['html_url'], decoded['id']);
  }
}
