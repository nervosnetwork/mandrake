import 'web.dart' if (dart.library.io) 'desktop.dart';
import 'dart:convert';

import '../models/document.dart';

class DocReader {
  DocReader(this._path);
  final String _path;

  Future<Document> read() async {
    try {
      final content = await readFileAsString(_path);
      final json = jsonDecode(content);
      return Document.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
