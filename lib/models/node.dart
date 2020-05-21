import 'dart:ui' show Offset;

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../protos/ast.pb.dart' show Value_Type;

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

/// NT: short for NodeTemplate
class NT {
  NT(this.valueType);

  final Value_Type valueType;
}

class NodeCreator {
  static Node create(NT template, Offset pos) {
    // TODO: create more ast nodes
    AstNode node;
    node = AstNode(
      kind: AstNodeKind.primitive, // TODO: group kind
      valueType: template.valueType,
      position: pos,
      minimumSlotCount: 0,
      maximumSlotCount: 2,
    );

    return node;
  }
}
