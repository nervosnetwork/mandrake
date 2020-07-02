import 'dart:ui' show Offset;

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
