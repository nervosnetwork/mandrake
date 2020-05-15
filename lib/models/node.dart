import 'dart:ui' show Offset;

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../protos/ast.pb.dart' show Value_Type;

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

/// These categories are not scientific work.
/// Just pick what makes sense for easier use.
enum TemplateKind {
  binaryOp,
  not,
  cellOp,
  scriptOp,
  txOp,
  headerOp,
  // TODO: other categories
}

class NodeMeta {
  NodeMeta(this.kind, this.valueType, [this.templateKind = TemplateKind.binaryOp]);

  AstNodeKind kind;
  Value_Type valueType;
  TemplateKind templateKind;
}

class NodeCreator {
  static Node create(NodeMeta meta, Offset pos) {
    // TODO: create ast nodes
    AstNode node;
    switch (meta.kind) {
      case AstNodeKind.op:
        return createForValueType(meta.kind, meta.valueType, pos);
        break;
      default:
        return createForValueType(meta.kind, meta.valueType, pos);
    }
  }

  static Node createForValueType(AstNodeKind kind, Value_Type valueType, Offset pos) {
    AstNode node;
    switch (valueType) {
      case Value_Type.NOT:
        node = AstNode(
          kind: kind,
          valueType: valueType,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('value');
        break;
      default:
        node = AstNode(
          kind: kind,
          valueType: valueType,
          position: pos,
        );
    }
    return node;
  }
}
