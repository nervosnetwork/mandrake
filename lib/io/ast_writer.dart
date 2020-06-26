import 'package:mandrake/models/node.dart';

import 'web.dart' if (dart.library.io) 'desktop.dart';

import 'foundation.dart';
import '../models/document.dart';

class AstWriter {
  AstWriter(this._doc, this._handle);
  final Document _doc;
  final FileHandle _handle;

  Future<void> write() async {
    await writeFile(_handle, _doc.toAstBytes());
  }
}

extension DocumentAstExportable on Document {
  List<int> toAstBytes() => root.toAstBytes();
}

extension RootAstExportable on RootNode {
  Root toAst() {
    final result = Root();

    for (final callSlot in callSlots) {
      final child = children.firstWhere((c) => c.id == callSlot.childId, orElse: () => null);
      if (child != null) {
        final call = Call();
        call.name = child.name;
        call.result = (child as AstNode).toAstValue();
        result.calls.add(call);
      }
    }

    for (final streamSlot in streamSlots) {
      final child = children.firstWhere((c) => c.id == streamSlot.childId, orElse: () => null);
      if (child != null) {
        final stream = Stream();
        stream.name = child.name;
        stream.filter = (child as AstNode).toAstValue();
        result.streams.add(stream);
      }
    }

    return result;
  }

  List<int> toAstBytes() {
    return toAst().writeToBuffer();
  }
}
