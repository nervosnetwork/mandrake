import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'web.dart' if (dart.library.io) 'desktop.dart';
import 'package:path/path.dart' as path;

import 'foundation.dart';
import '../models/document.dart';

class DocReader {
  DocReader(this._handle);
  final FileHandle _handle;

  Future<Document> read() async {
    try {
      final content = await readFileAsString(_handle);
      final json = jsonDecode(content);
      final doc = Document.fromJson(json);
      if (!kIsWeb) {
        doc.fileName = path.basename(_handle.handle);
      }
      for (final node in doc.allNodes.values) {
        node.doc = doc;
      }
      return doc;
    } catch (e) {
      print('Read and parse document error: $e');
      return null;
    }
  }
}
