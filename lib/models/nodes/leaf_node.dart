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
        );

  String _value = '';

  double get bodyHeight => 30;

  @override
  Size get size {
    return Size(
      200,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  String get value {
    if (valueType == Value_Type.NIL) {
      return 'NIL';
    }

    if (valueType == Value_Type.BOOL) {
      return 'True'; // TODO
    }

    return _value; // TODO: format
  }

  void setValue(String v) {
    _value = v; // TODO: format
  }
}
