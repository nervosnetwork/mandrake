import 'web.dart' if (dart.library.io) 'desktop.dart';

import 'foundation.dart';
import '../models/document.dart';
import '../models/node.dart';
import '../protos/ast.pb.dart';

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

extension RootNodeAstExportable on RootNode {
  List<int> toAst() {
    final result = Root();
    // TODO: build the full Root with calls/streams and sub values.
    final call = Call();
    result.calls.add(call);
    return result.writeToBuffer();
  }
}
