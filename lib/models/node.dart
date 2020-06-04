import 'dart:ui' show Offset;

import 'package:mandrake/models/nodes/op_node.dart';

import 'nodes/node_base.dart';
import 'nodes/ast_node.dart';
import 'nodes/prefab_node.dart';
import 'nodes/primitive_node.dart';
import 'nodes/get_op_node.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/prefab_node.dart';
export 'nodes/op_node.dart';
export 'nodes/primitive_node.dart';
export 'nodes/get_op_node.dart';

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    final valueType = template.valueType;

    if (valueType.isPrefab) {
      return PrefabNode(valueType: valueType, position: pos);
    }

    if (valueType.isOperation) {
      return OperationNode(valueType: valueType, position: pos);
    }

    if (valueType.isPrimitiveField) {
      return PrimitiveNode(valueType: valueType, position: pos);
    }

    if (valueType.isGetOperator) {
      return GetOpNode(valueType: valueType, position: pos);
    }

    final node = AstNode(valueType: valueType, position: pos);
    for (var i = 0; i < node.minimumSlotCount; i++) {
      node.addSlot('Child ${i + 1}');
    }
    return node;
  }
}
