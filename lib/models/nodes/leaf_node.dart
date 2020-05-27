import 'dart:ui' show Offset, Size;

import '../../protos/ast.pb.dart' show Value_Type;
import 'ast_node.dart';

class LeafNode extends AstNode {
  LeafNode({
    Value_Type valueType,
    Offset position,
  }) : super(
          valueType: valueType,
          position: position,
        ) {
    if (valueType == Value_Type.NIL) {
      _value = 'NIL';
    } else if (valueType == Value_Type.BOOL) {
      _value = 'true';
    } else if (valueType == Value_Type.BYTES) {
      _value = '0x';
    } else if (valueType == Value_Type.ERROR) {
      _value = 'Error message';
    } else {
      _value = '0';
    }
  }

  String _value = '';

  double get bodyHeight => 30;

  @override
  Size get size {
    return Size(
      200,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  String get value => _value;

  void setValue(String v) {
    _value = v; // TODO: format validation
    notifyListeners();
  }
}
