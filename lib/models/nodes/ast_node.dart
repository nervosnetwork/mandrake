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
  bool get isLeaf => leafValueTypes.contains(this);
  bool get isUnaryOperator => unaryOperatorValueTypes.contains(this);
  bool get isBinaryOperator => binaryOperatorValueTypes.contains(this);
  bool get isTernaryOperator => ternaryOperatorValueTypes.contains(this);
  bool get isList => listValueTypes.contains(this);

  int get minimumSlotCount {
    if (isLeaf) {
      return 0;
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
    if (isLeaf) {
      return 0;
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

  static const List<Value_Type> leafValueTypes = [
    Value_Type.NIL,
    Value_Type.UINT64,
    Value_Type.BOOL,
    Value_Type.BYTES,
    Value_Type.ERROR,
    Value_Type.ARG,
    Value_Type.PARAM,
  ];

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
