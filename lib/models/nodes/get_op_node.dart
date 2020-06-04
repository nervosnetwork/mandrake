import 'dart:ui' show Offset;

import 'ast_node.dart';

class GetOpNode extends AstNode {
  GetOpNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position) {
    addSlot(_getType(valueType));
  }

  String type;

  String _getType(ValueType valueType) {
    if (valueType.isCellGetOp) {
      return 'cell';
    }
    if (valueType.isScriptGetOp) {
      return 'script';
    }
    if (valueType.isTxGetOp) {
      return 'transaction';
    }
    if (valueType.isHeaderGetOp) {
      return 'header';
    }

    return '';
  }
}
