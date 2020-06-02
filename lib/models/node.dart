import 'dart:ui' show Offset;

import 'package:mandrake/models/nodes/op_node.dart';

import '../models/document.dart';
import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../models/nodes/primitive_node.dart';
import '../models/nodes/get_op_node.dart';

import '../models/prefabs/example_query_cell.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/op_node.dart';
export 'nodes/primitive_node.dart';
export 'nodes/get_op_node.dart';

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos, [Document document]) {
    final valueType = template.valueType;

    if (valueType == ValueType.exampleQueryCell) {
      return QueryCellExampleNode.create(document, pos);
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
