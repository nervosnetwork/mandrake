import 'dart:ui' show Offset;

import 'package:mandrake/models/nodes/leaf_node.dart';

import '../models/nodes/node_base.dart';
import '../models/nodes/ast_node.dart';
import '../protos/ast.pb.dart' show Value_Type;

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/leaf_node.dart';
export '../protos/ast.pb.dart' show Value_Type;

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    // TODO: create more ast nodes
    AstNode node;
    if (template.valueType.isLeaf) {
      node = LeafNode(
        valueType: template.valueType,
        position: pos,
      );
    } else {
      node = AstNode(
        valueType: template.valueType,
        position: pos,
      );
    }

    for (var i = 0; i < node.minimumSlotCount; i++) {
      node.addSlot('Child ${i + 1}');
    }

    return node;
  }
}

class NodeTemplate {
  NodeTemplate(this.valueType);

  final Value_Type valueType;

  String get title => valueType.uiName;
  NodeTemplateGroup get group {
    for (final group in NodeTemplateGroup.values) {
      if (grouped[group].contains(this)) {
        return group;
      }
    }
    return NodeTemplateGroup.operation;
  }

  /// Just for short constructor
  static NodeTemplate NT(Value_Type valueType) => NodeTemplate(valueType);

  /// For categorized grouping, used by Object Library.
  static final grouped = {
    NodeTemplateGroup.operation: [
      NT(Value_Type.HASH),
      NT(Value_Type.SERIALIZE_TO_CORE),
      NT(Value_Type.SERIALIZE_TO_JSON),
      NT(Value_Type.NOT),
      NT(Value_Type.AND),
      NT(Value_Type.OR),
      NT(Value_Type.EQUAL),
      NT(Value_Type.LESS),
      NT(Value_Type.LEN),
      NT(Value_Type.SLICE),
      NT(Value_Type.INDEX),
      NT(Value_Type.ADD),
      NT(Value_Type.SUBTRACT),
      NT(Value_Type.MULTIPLY),
      NT(Value_Type.DIVIDE),
      NT(Value_Type.MOD),
      NT(Value_Type.COND),
      NT(Value_Type.TAIL_RECURSION),
    ],
    NodeTemplateGroup.prefab: [],
    NodeTemplateGroup.primitive: [
      NT(Value_Type.NIL),
      NT(Value_Type.UINT64),
      NT(Value_Type.BOOL),
      NT(Value_Type.BYTES),
      NT(Value_Type.ERROR),
      NT(Value_Type.ARG),
      NT(Value_Type.PARAM),
    ],
    NodeTemplateGroup.blockchain: [
      NT(Value_Type.OUT_POINT),
      NT(Value_Type.CELL_INPUT),
      NT(Value_Type.CELL_DEP),
      NT(Value_Type.SCRIPT),
      NT(Value_Type.CELL),
      NT(Value_Type.TRANSACTION),
      NT(Value_Type.HEADER),
    ],
    NodeTemplateGroup.list: [
      NT(Value_Type.APPLY),
      NT(Value_Type.REDUCE),
      NT(Value_Type.LIST),
      NT(Value_Type.QUERY_CELLS),
      NT(Value_Type.MAP),
      NT(Value_Type.FILTER),
    ],
    NodeTemplateGroup.cell: [
      NT(Value_Type.GET_CAPACITY),
      NT(Value_Type.GET_DATA),
      NT(Value_Type.GET_LOCK),
      NT(Value_Type.GET_TYPE),
      NT(Value_Type.GET_DATA_HASH),
      NT(Value_Type.GET_OUT_POINT),
    ],
    NodeTemplateGroup.script: [
      NT(Value_Type.GET_CODE_HASH),
      NT(Value_Type.GET_HASH_TYPE),
      NT(Value_Type.GET_ARGS),
    ],
    NodeTemplateGroup.transaction: [
      NT(Value_Type.GET_CELL_DEPS),
      NT(Value_Type.GET_HEADER_DEPS),
      NT(Value_Type.GET_INPUTS),
      NT(Value_Type.GET_OUTPUTS),
      NT(Value_Type.GET_WITNESSES),
    ],
    NodeTemplateGroup.header: [
      NT(Value_Type.GET_COMPACT_TARGET),
      NT(Value_Type.GET_TIMESTAMP),
      NT(Value_Type.GET_NUMBER),
      NT(Value_Type.GET_EPOCH),
      NT(Value_Type.GET_PARENT_HASH),
      NT(Value_Type.GET_TRANSACTIONS_ROOT),
      NT(Value_Type.GET_PROPOSALS_HASH),
      NT(Value_Type.GET_UNCLES_HASH),
      NT(Value_Type.GET_DAO),
      NT(Value_Type.GET_NONCE),
      NT(Value_Type.GET_HEADER),
    ],
  };
}

// Categorize nodes for grouping from places like object library.
enum NodeTemplateGroup {
  operation,
  prefab, // Special sets of common operations as a single node (e.g. `balance`)
  primitive,
  blockchain,
  list,
  cell,
  script,
  transaction,
  header,
}
