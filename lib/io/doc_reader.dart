import '../models/document.dart';

class DocReader {
  DocReader(this._path);
  final String _path;

  Document read() {
    print('read from $_path');
    return Document();
    // TODO: implement document/project file reading
  }
}
