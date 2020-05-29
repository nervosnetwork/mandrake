import 'dart:ui' show Offset;

import 'package:mandrake/models/nodes/op_node.dart';

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../models/nodes/primitive_node.dart';
import '../models/nodes/get_op_node.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/op_node.dart';
export 'nodes/primitive_node.dart';
export 'nodes/get_op_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    final valueType = template.valueType;

    if (valueType.isOperation) {
      return OperationNode(valueType: valueType, position: pos);
    }

    if (valueType.isPrimitiveField) {
      return PrimitiveNode(valueType: valueType, position: pos);
    }

    if (valueType.isGetOperator) {
      return GetOpNode(valueType: valueType, position: pos);
    }

    // TODO: create more ast nodes
    final node = AstNode(valueType: valueType, position: pos);
    for (var i = 0; i < node.minimumSlotCount; i++) {
      node.addSlot('Child ${i + 1}');
    }
    return node;
  }
}
