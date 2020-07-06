import 'dart:ui' show Offset;
import 'package:fixnum/fixnum.dart';
import 'package:mandrake/models/node.dart';

import '../../nodes/ast_node.dart';

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

AstNode argValue(Int64 index) {
  final value = PrimitiveNode(valueType: ValueType.arg);
  value.value = index.toString();
  return value;
}

AstNode paramValue(Int64 index) {
  final value = PrimitiveNode(valueType: ValueType.param);
  value.value = index.toString();
  return value;
}
