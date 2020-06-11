import 'web.dart' if (dart.library.io) 'desktop.dart';
import 'dart:convert';

import '../models/document.dart';

class DocWriter {
  DocWriter(this._doc, this._path);
  final Document _doc;
  final String _path;

  Future<void> write() async {
    await writeFileAsString(_path, jsonEncode(_doc));
  }
}
