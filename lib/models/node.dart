import 'dart:ui' show Offset;

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../protos/ast.pb.dart' show Value_Type;

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

class NodeMeta {
  NodeMeta(this.kind, this.valueType);

  AstNodeKind kind;
  Value_Type valueType;
}

class NodeCreator {
  static Node create(NodeMeta meta, Offset pos) {
    // TODO: create ast nodes
    return AstNode(meta.kind, meta.valueType, pos);
  }
}
