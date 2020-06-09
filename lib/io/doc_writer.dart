import '../models/document.dart';

class DocWriter {
  DocWriter(this._doc, this._path);
  final Document _doc;
  final String _path;

  bool write() {
    // TODO: implement document/project persistence
    print('write $_doc to $_path');
    return false;
  }
}
