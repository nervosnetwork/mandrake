import '../protos/ast.pb.dart';
import '../models/document.dart';

class AstWriter {
  AstWriter(this._doc, this._path);
  final Document _doc;
  final String _path;

  bool write() {
    print('write $_doc AST to $_path');
    // TODO: implement exporting as AST binary file
    return false;
  }
}

extension DocumentAstExportable on Document {
  List<int> toAst() {
    final root = Root();
    // TODO
    return root.writeToBuffer();
  }
}
