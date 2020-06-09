import '../models/document.dart';

import '../experimental/ast_example.dart';

import 'web.dart' if (dart.library.io) 'desktop.dart';

class AstWriter {
  AstWriter(this._doc, this._path);
  final Document _doc;
  final String _path;

  Future<void> write() async {
    await writeFile(_path, _doc.toAst());
  }
}

extension DocumentAstExportable on Document {
  List<int> toAst() {
    // TODO: build real ast
    // final root = Root();
    // return root.writeToBuffer();
    return output();
  }
}
