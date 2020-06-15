import 'web.dart' if (dart.library.io) 'desktop.dart';
import 'dart:convert';

import 'foundation.dart';
import '../models/document.dart';

class DocWriter {
  DocWriter(this._doc, this._handle);
  final Document _doc;
  final FileHandle _handle;

  Future<void> write() async {
    await writeFileAsString(_handle, jsonEncode(_doc));
  }
}
