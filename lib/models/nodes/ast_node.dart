import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'node_base.dart';

class AstNode extends Node {
  AstNode({
    this.valueType,
    Offset position,
  }) : super(
          name: valueType.uiName,
          position: position,
          minimumSlotCount: valueType.minimumSlotCount,
          maximumSlotCount: valueType.maximumSlotCount,
        );

  final Value_Type valueType;
}

/// Just for short constructor
NodeTemplate NT(Value_Type valueType) => NodeTemplate(valueType);

class NodeTemplate {
  NodeTemplate(this.valueType);

  final Value_Type valueType;

  @override
  bool operator ==(dynamic other) => other is NodeTemplate && other.valueType == valueType;

  @override
  int get hashCode => valueType.hashCode;

  String get title => valueType.uiName;
  NodeTemplateGroup get group {
    for (final group in NodeTemplateGroup.values) {
      if (grouped[group].contains(this)) {
        return group;
      }
    }
    return NodeTemplateGroup.operation;
  }

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
      // TODO: to which category arg and param should belong?
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

extension ValueTypeName on Value_Type {
  String get uiName {
    final separated = toString().split('_');
    return separated.map((w) {
      if (['JSON', 'DAO'].contains(w)) {
        return w;
      }
      return w[0] + w.substring(1).toLowerCase();
    }).join(' ');
  }
}

extension VelueTypeKind on Value_Type {
  bool get isPrimitiveField => NT(this).group == NodeTemplateGroup.primitive;
  bool get isGetOperator {
    return isCellGetOp || isScriptGetOp || isTxGetOp || isHeaderGetOp;
  }

  bool get isCellGetOp => NT(this).group == NodeTemplateGroup.cell;
  bool get isScriptGetOp => NT(this).group == NodeTemplateGroup.script;
  bool get isTxGetOp => NT(this).group == NodeTemplateGroup.transaction;
  bool get isHeaderGetOp => NT(this).group == NodeTemplateGroup.header;

  bool get isUnaryOperator => unaryOperatorValueTypes.contains(this);
  bool get isBinaryOperator => binaryOperatorValueTypes.contains(this);
  bool get isTernaryOperator => ternaryOperatorValueTypes.contains(this);
  bool get isList => listValueTypes.contains(this);

  int get minimumSlotCount {
    if (isPrimitiveField) {
      return 0;
    }
    if (isGetOperator) {
      return 1;
    }
    if (isUnaryOperator) {
      return 1;
    }
    if (isBinaryOperator) {
      return 2;
    }
    if (isList) {
      return 2;
    }
    if (isTernaryOperator) {
      return 3;
    }
    return 1;
  }

  int get maximumSlotCount {
    if (isPrimitiveField) {
      return 0;
    }
    if (isGetOperator) {
      return 1;
    }
    if (isUnaryOperator) {
      return 1;
    }
    if (isBinaryOperator) {
      return 2;
    }
    if (isTernaryOperator) {
      return 3;
    }
    return NodeBase.maxAllowedSlotCount;
  }

  static const List<Value_Type> unaryOperatorValueTypes = [
    Value_Type.HASH,
    Value_Type.SERIALIZE_TO_CORE,
    Value_Type.SERIALIZE_TO_JSON,
    Value_Type.NOT,
  ];

  static const List<Value_Type> binaryOperatorValueTypes = [
    Value_Type.EQUAL,
    Value_Type.LESS,
    Value_Type.ADD,
    Value_Type.SUBTRACT,
    Value_Type.MULTIPLY,
    Value_Type.DIVIDE,
    Value_Type.MOD,
    Value_Type.INDEX,
  ];

  static const List<Value_Type> ternaryOperatorValueTypes = [
    Value_Type.COND,
    Value_Type.SLICE,
  ];

  static const List<Value_Type> listValueTypes = [
    Value_Type.AND,
    Value_Type.OR,
    Value_Type.LIST,
    Value_Type.MAP,
    Value_Type.FILTER,
  ];
}
