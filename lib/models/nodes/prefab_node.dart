import 'dart:ui' show Offset, Size;

import 'ast_node.dart';
import 'prefabs/prefab_value.dart';
import 'prefabs/query_cells.dart';
import 'prefabs/map_capacities.dart';
import 'prefabs/get_balance.dart';

export 'prefabs/prefab_value.dart';

part 'prefab_node.g.dart';

@JsonSerializable()
class PrefabNode extends AstNode {
  PrefabNode({ValueType valueType, Offset position})
      : values = [],
        super(valueType: valueType, position: position);

  factory PrefabNode.fromJson(Map<String, dynamic> json) => _$PrefabNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$PrefabNodeToJson);

  @override
  Value toAstValue() => flatten().toAstValue();

  double get bodyHeight => 100;

  @override
  Size get size {
    return Size(
      180,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  String get description => valueType.description;

  List<PrefabValue> values;

  void updateValue(String name, String newValue) {
    for (var v in values) {
      if (v.name == name) {
        v.value = newValue;
      }
    }
    notifyListeners();
  }

  /// Convert to a tree of nodes. Once converted, that tree couldn't be
  /// converted back to the prefab node.
  AstNode flatten() {
    final map = {
      ValueType.prefabQueryCells: convertQueryCells,
      ValueType.prefabMapCapacities: convertMapCapacities,
      ValueType.prefabGetBalance: convertGetBalance,
    };

    final convert = map[valueType];
    if (convert != null) {
      return convert(this);
    }

    throw UnimplementedError();
  }
}
