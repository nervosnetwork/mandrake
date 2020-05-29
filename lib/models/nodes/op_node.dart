import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'ast_node.dart';

class OperationNode extends AstNode {
  OperationNode({Value_Type valueType, Offset position})
      : super(valueType: valueType, position: position) {
    _addSlots();
  }

  /// TODO: override canConnect to limit child types

  void _addSlots() {
    final expectedSlots = _slotNameMap[valueType];
    if (expectedSlots != null) {
      for (final name in expectedSlots) {
        addSlot(name);
      }
    } else {
      for (var i = 0; i < valueType.minimumSlotCount; i++) {
        addSlot('Operand ${i + 1}');
      }
    }
  }

  static final _slotNameMap = {
    Value_Type.HASH: ['Hash'],
    Value_Type.LEN: ['Bytes'],
    Value_Type.INDEX: ['Index', 'List'],
    Value_Type.SLICE: ['Start', 'End', 'Bytes'],
    Value_Type.COND: ['Condition', 'Expr1', 'Expr1'],
  };
}
