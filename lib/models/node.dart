import 'dart:ui' show Offset;

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../models/nodes/leaf_node.dart';
import '../models/nodes/get_op_node.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/leaf_node.dart';
export 'nodes/get_op_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    if (template.valueType.isLeaf) {
      return LeafNode(valueType: template.valueType, position: pos);
    } else if (template.valueType.isGetOperator) {
      return GetOpNode(valueType: template.valueType, position: pos);
    } else {
      // TODO: create more ast nodes
      final node = AstNode(valueType: template.valueType, position: pos);

      for (var i = 0; i < node.minimumSlotCount; i++) {
        node.addSlot('Child ${i + 1}');
      }
      return node;
    }
  }
}
