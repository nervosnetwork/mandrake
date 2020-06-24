import 'web.dart' if (dart.library.io) 'desktop.dart';

import 'foundation.dart';
import '../models/document.dart';

class AstWriter {
  AstWriter(this._doc, this._handle);
  final Document _doc;
  final FileHandle _handle;

  Future<void> write() async {
    await writeFile(_handle, _doc.toAst());
  }
}

extension DocumentAstExportable on Document {
  List<int> toAst() {
    return root.toAst();
  }
}
