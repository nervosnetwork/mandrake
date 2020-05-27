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
    if (valueType.isCellGetOp) {
      return 'Cell';
    }
    if (valueType.isScriptGetOp) {
      return 'Script';
    }
    if (valueType.isTxGetOp) {
      return 'Transaction';
    }
    if (valueType.isHeaderGetOp) {
      return 'Header';
    }

    return '';
  }
}
