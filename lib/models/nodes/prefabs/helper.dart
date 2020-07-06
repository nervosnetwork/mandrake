import 'dart:ui' show Offset;
import 'package:fixnum/fixnum.dart';
import 'package:mandrake/models/node.dart';

import '../../nodes/ast_node.dart';

String secpCellDepDevnet = '0xace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708';
String secpTypeHash = '0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8';
String udtCodeHash = '0x57dd0067814dab356e05c6def0d094bb79776711e68ffdfad2df6a7f877f7db6';

Offset standByMe(AstNode parent, int childrenCount, int index) {
  final h = parent.size.width + 80;
  final v = (index - childrenCount / 2) * 160 + 80;
  return parent.position + Offset(h, v);
}

Offset standBelowMe(AstNode node, int index) {
  final v = (index + 1.0) * 160 + 80;
  return node.position + Offset(0, v);
}

AstNode autoLayout(AstNode node, [Offset initialPosition]) {
  if (initialPosition != null) {
    node.position = initialPosition;
  }

  final count = node.children.length;
  for (var i = 0; i < count; i++) {
    final child = node.children[i];
    child.position = standByMe(node, count, i);
    autoLayout(child);
  }

  return node;
}

AstNode bytesValue(String bytes) {
  final value = PrimitiveNode(valueType: ValueType.bytes);
  value.value = bytes;
  return value;
}

AstNode uintValue(Int64 val) {
  final value = PrimitiveNode(valueType: ValueType.uint64);
  value.value = val.toString();
  return value;
}

AstNode arg(Int64 index) {
  final value = PrimitiveNode(valueType: ValueType.arg);
  value.value = index.toString();
  return value;
}

AstNode param(Int64 index) {
  final value = PrimitiveNode(valueType: ValueType.param);
  value.value = index.toString();
  return value;
}

AstNode equal(AstNode lhs, AstNode rhs) {
  final result = OperationNode(valueType: ValueType.equal);
  result.addChild(lhs, result.slots.first.id);
  result.addChild(rhs, result.slots.last.id);
  return result;
}

AstNode add(AstNode lhs, AstNode rhs) {
  final result = OperationNode(valueType: ValueType.add);
  result.addChild(lhs, result.slots.first.id);
  result.addChild(rhs, result.slots.last.id);
  return result;
}

AstNode getField(ValueType valueType, AstNode value) {
  final result = GetOpNode(valueType: valueType);
  result.addChild(value, result.slots.first.id);
  return result;
}
