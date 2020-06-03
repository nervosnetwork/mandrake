import 'dart:ui' show Offset, Size;

import '../document.dart';
import 'ast_node.dart';
import 'prefabs/query_cells.dart';

class PrefabNode extends AstNode {
  PrefabNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position);

  double get bodyHeight => 50;

  @override
  Size get size {
    return Size(
      180,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  /// Convert to a tree of nodes. Once converted, that tree couldn't be
  /// converted back to the prefab node.
  AstNode flatten(Document document) {
    if (valueType == ValueType.prefabQueryCell) {
      return convertQueryCells(document, this);
    }

    throw UnimplementedError();
  }
}
