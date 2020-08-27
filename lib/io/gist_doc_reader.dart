import 'dart:convert';
import 'package:universal_io/io.dart';

import '../models/document.dart';

class GistDocReader {
  GistDocReader(this._url);
  final String _url;

  Future<Document> read() async {
    try {
      final content = await _loadGist();
      final json = jsonDecode(content);
      final doc = Document.fromJson(json);
      return doc;
    } catch (e) {
      print('Read and parse document from gist $_url error: $e');
      return null;
    }
  }

  Future<String> _loadGist() async {
    final id = _url.split('/').last;
    final endpoint = 'https://api.github.com/gists/$id';

    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(endpoint));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    final json = jsonDecode(body);
    final filename = json['files'].keys.first;
    return json['files'][filename]['content'];
  }
}
