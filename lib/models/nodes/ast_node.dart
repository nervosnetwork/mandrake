import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'node_base.dart';

/// primitive: ..< ast.Value_ARG
/// list op:   ast.Value_LIST ..< ast.Value_GET_CAPACITY
/// get op:    ast.Value_GET_CAPACITY ..< ast.Value_HASH
/// op:        ast.Value_HASH ..< ast.Value_COND
enum AstNodeKind {
  primitive,
  arg,
  data,
  listOp,
  cellGetOp,
  scriptGetOp,
  txGetOp,
  headerGetOp,
  op, // Unary, Binary, Ternary or List
  specialOp,
}

class AstNode extends Node {
  AstNode({
    this.kind,
    this.valueType,
    Offset position,
    minimumSlotCount = 1,
    maximumSlotCount = 1,
  }) : super(
          name: valueType.toString(),
          position: position,
          minimumSlotCount: minimumSlotCount,
          maximumSlotCount: maximumSlotCount,
        );

  final AstNodeKind kind;
  final Value_Type valueType;
}
