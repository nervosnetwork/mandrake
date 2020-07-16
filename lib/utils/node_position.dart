import 'dart:ui' show Offset;

import '../models/node.dart';

Offset standByMe(AstNode parent, int childrenCount, int index) {
  final h = parent.size.width + 80;
  final v = (index - childrenCount / 2) * 160 + 80;
  return parent.position + Offset(h, v);
}

Offset standBelowMe(AstNode node, int index) {
  final v = (index + 1.0) * 160 + 80;
  return node.position + Offset(0, v);
}

AstNode autoLayout(AstNode node, {Offset initialPosition, double firstChildPositionY}) {
  if (initialPosition != null) {
    node.position = initialPosition;
  }

  final count = node.children.length;
  final margin = 30.0;
  AstNode lastChildOfPrevious;
  for (var i = 0; i < count; i++) {
    final child = node.children[i];
    double vPos;
    if (i == 0) {
      if (firstChildPositionY != null) {
        vPos = firstChildPositionY;
      } else {
        var totalHeight =
            node.children.map((e) => e.size.height).fold(0, (prev, ele) => prev + ele);
        totalHeight += (count - 1) * margin;
        vPos = node.position.dy + node.size.height / 2 - totalHeight * 0.6;
      }
    } else {
      vPos = node.children[i - 1].position.dy + node.children[i - 1].size.height + margin;
    }

    final firstChildPosition = lastChildOfPrevious != null
        ? lastChildOfPrevious.position.dy + lastChildOfPrevious.size.height + margin
        : null;
    autoLayout(
      child,
      initialPosition: Offset(node.position.dx + node.size.width + 80, vPos),
      firstChildPositionY: firstChildPosition,
    );

    if (child.children.isNotEmpty) {
      lastChildOfPrevious = child.children.last;
    } else {
      lastChildOfPrevious = null;
    }
  }

  return node;
}
