import 'dart:ui' show Offset, Size;

import '../document.dart';
import 'ast_node.dart';
import 'prefabs/query_cells.dart';
import 'prefabs/map_capacities.dart';
import 'prefabs/get_balance.dart';

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
    final map = {
      ValueType.prefabQueryCells: convertQueryCells,
      ValueType.prefabMapCapacities: convertMapCapacities,
      ValueType.prefabGetBalance: convertGetBalance,
    };

    final convert = map[valueType];
    if (convert != null) {
      return convert(document, this);
    }

    throw UnimplementedError();
  }
}
