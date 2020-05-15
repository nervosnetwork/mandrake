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
enum NodeTemplate {
  value,
  binaryOperator,
  not,
  cellOperator,
  scriptOperator,
  txOperator,
  headerOperator,
  // TODO: other categories
}

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    // TODO: create more ast nodes
    AstNode node;
    switch (template) {
      case NodeTemplate.value:
        node = AstNode(
          kind: AstNodeKind.primitive,
          valueType: Value_Type.UINT64,
          position: pos,
          minimumSlotCount: 0,
          maximumSlotCount: 0,
        );
        break;
      case NodeTemplate.binaryOperator:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.ADD,
          position: pos,
          minimumSlotCount: 2,
          maximumSlotCount: 2,
        );
        node.addSlot('value A');
        node.addSlot('value B');
        break;
      case NodeTemplate.not:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.NOT,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('value');
        break;
      case NodeTemplate.cellOperator:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.GET_CAPACITY,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('cell');
        break;
      case NodeTemplate.scriptOperator:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.GET_CODE_HASH,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('script');
        break;
      case NodeTemplate.txOperator:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.GET_INPUTS,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('transaction');
        break;
      case NodeTemplate.headerOperator:
        node = AstNode(
          kind: AstNodeKind.op,
          valueType: Value_Type.GET_NUMBER,
          position: pos,
          minimumSlotCount: 1,
          maximumSlotCount: 1,
        );
        node.addSlot('header');
        break;
    }

    return node;
  }
}
