import 'dart:ui' show Offset, Size;

import 'node_base.dart';

/// AST Root.
class RootNode extends Node {
  RootNode() : super('Root Node', Offset(80, 200));

  @override
  Size get size {
    return Size(
      180,
      titleHeight +
          subtitleHeight * 2 +
          actionRowHeight * 2 +
          children.length * childRowHeight +
          bottomPadding,
    );
  }
}
