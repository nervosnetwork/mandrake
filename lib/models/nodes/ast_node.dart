import 'dart:ui' show Offset;

import '../../utils/node_position.dart' as position;
import '../../protos/ast.pb.dart';
import '../value_type.dart';
import 'node_base.dart';

export '../../protos/ast.pb.dart';
export '../value_type.dart';
export 'node_base.dart';

part 'ast_node.g.dart';

@JsonSerializable()
class AstNode extends Node {
  AstNode({
    ValueType valueType,
    Offset position,
  })  : _valueType = valueType,
        super(
          name: valueType.uiName,
          position: position,
          minimumSlotCount: valueType.minimumSlotCount,
          maximumSlotCount: valueType.maximumSlotCount,
        );

  factory AstNode.fromJson(Map<String, dynamic> json) => _$AstNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$AstNodeToJson);

  /// Subtypes should implement this if necessary.
  Value toAstValue() {
    final value = Value();
    value.t = valueType.rawType;

    final slotWithChild = slots.where((s) => s.childId != null);
    final childrenAst = slotWithChild.map((s) {
      final child = findChild(s.childId);
      return (child as AstNode).toAstValue();
    }).toList();
    value.children.addAll(childrenAst);

    return value;
  }

  ValueType _valueType;
  ValueType get valueType => _valueType;
  set valueType(ValueType newValueType) {
    if (!exchangeableValueTypes.contains(newValueType)) {
      return;
    }
    if (valueType == newValueType) {
      return;
    }

    if (name == valueType.uiName) {
      name = newValueType.uiName;
    }
    _valueType = newValueType;

    updateValueAfterTypeChange();
    notifyListeners();
  }

  void autoLayout() => position.autoLayout(this);

  /// Value Types this node can be changed to.
  List<ValueType> get exchangeableValueTypes {
    final templates = NodeTemplate.grouped[NT(valueType).group];
    return templates.map<ValueType>((e) => e.valueType).toList();
  }

  void updateValueAfterTypeChange() {}
}

/// Just for short constructor
NodeTemplate NT(ValueType valueType) => NodeTemplate(valueType);

class NodeTemplate {
  NodeTemplate(this.valueType);

  final ValueType valueType;

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
      NT(ValueType.hash),
      NT(ValueType.serializeToCore),
      NT(ValueType.serializeToJson),
      NT(ValueType.not),
      NT(ValueType.and),
      NT(ValueType.or),
      NT(ValueType.equal),
      NT(ValueType.less),
      NT(ValueType.len),
      NT(ValueType.slice),
      NT(ValueType.index),
      NT(ValueType.add),
      NT(ValueType.subtract),
      NT(ValueType.multiply),
      NT(ValueType.divide),
      NT(ValueType.mod),
      NT(ValueType.cond),
      NT(ValueType.tailRecursion),
    ],
    NodeTemplateGroup.prefab: [
      NT(ValueType.prefabSecp256k1GetBalance),
      NT(ValueType.prefabSecp256k1MapCapacities),
      NT(ValueType.prefabSecp256k1QueryCells),
      NT(ValueType.prefabUdt),
      NT(ValueType.prefabUdtGetBalance),
      NT(ValueType.prefabUdtTransfer),
    ],
    NodeTemplateGroup.primitive: [
      NT(ValueType.nil),
      NT(ValueType.uint64),
      NT(ValueType.bool),
      NT(ValueType.bytes),
      NT(ValueType.error),
      NT(ValueType.arg),
      NT(ValueType.param),
    ],
    NodeTemplateGroup.blockchain: [
      NT(ValueType.outPoint),
      NT(ValueType.cellInput),
      NT(ValueType.cellDep),
      NT(ValueType.script),
      NT(ValueType.cell),
      NT(ValueType.transaction),
      NT(ValueType.header),
    ],
    NodeTemplateGroup.list: [
      NT(ValueType.apply),
      NT(ValueType.reduce),
      NT(ValueType.list),
      NT(ValueType.queryCells),
      NT(ValueType.map),
      NT(ValueType.filter),
    ],
    NodeTemplateGroup.cell: [
      NT(ValueType.getCapacity),
      NT(ValueType.getData),
      NT(ValueType.getLock),
      NT(ValueType.getType),
      NT(ValueType.getDataHash),
      NT(ValueType.getOutPoint),
    ],
    NodeTemplateGroup.script: [
      NT(ValueType.getCodeHash),
      NT(ValueType.getHashType),
      NT(ValueType.getArgs),
    ],
    NodeTemplateGroup.transaction: [
      NT(ValueType.getCellDeps),
      NT(ValueType.getHeaderDeps),
      NT(ValueType.getInputs),
      NT(ValueType.getOutputs),
      NT(ValueType.getWitnesses),
    ],
    NodeTemplateGroup.header: [
      NT(ValueType.getCompactTarget),
      NT(ValueType.getTimestamp),
      NT(ValueType.getNumber),
      NT(ValueType.getEpoch),
      NT(ValueType.getParentHash),
      NT(ValueType.getTransactionsRoot),
      NT(ValueType.getProposalsHash),
      NT(ValueType.getUnclesHash),
      NT(ValueType.getDao),
      NT(ValueType.getNonce),
      NT(ValueType.getHeader),
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

extension VelueTypeKind on ValueType {
  bool get isPrefab => NT(this).group == NodeTemplateGroup.prefab;
  bool get isOperation => NT(this).group == NodeTemplateGroup.operation;
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
    if (isPrimitiveField || isPrefab) {
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
    if (isPrimitiveField || isPrefab) {
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
    return Node.maxAllowedSlotCount;
  }

  static const List<ValueType> unaryOperatorValueTypes = [
    ValueType.hash,
    ValueType.serializeToCore,
    ValueType.serializeToJson,
    ValueType.not,
    ValueType.len,
  ];

  static const List<ValueType> binaryOperatorValueTypes = [
    ValueType.equal,
    ValueType.less,
    ValueType.add,
    ValueType.subtract,
    ValueType.multiply,
    ValueType.divide,
    ValueType.mod,
    ValueType.index,
  ];

  static const List<ValueType> ternaryOperatorValueTypes = [
    ValueType.cond,
    ValueType.slice,
  ];

  static const List<ValueType> listValueTypes = [
    ValueType.and,
    ValueType.or,
    ValueType.list,
    ValueType.map,
    ValueType.filter,
  ];
}
