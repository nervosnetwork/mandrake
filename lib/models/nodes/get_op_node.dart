import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'ast_node.dart';

class GetOpNode extends AstNode {
  GetOpNode({Value_Type valueType, Offset position})
      : super(valueType: valueType, position: position) {
    addSlot(_getType(valueType));
  }

  String type;

  String _getType(Value_Type valueType) {
    if (valueType.isCell) {
      return 'Cell';
    }
    if (valueType.isScript) {
      return 'Script';
    }
    if (valueType.isTx) {
      return 'Transaction';
    }
    if (valueType.isHeader) {
      return 'Header';
    }

    return '';
  }
}
