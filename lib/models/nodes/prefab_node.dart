import 'dart:ui' show Offset, Size;

import 'ast_node.dart';
import 'prefabs/prefab_property.dart';
import 'prefabs/query_cells.dart';
import 'prefabs/map_capacities.dart';
import 'prefabs/get_balance.dart';
import 'prefabs/udt.dart';

export 'prefabs/prefab_property.dart';

part 'prefab_node.g.dart';

@JsonSerializable()
class PrefabNode extends AstNode {
  PrefabNode({ValueType valueType, Offset position})
      : properties = [],
        super(valueType: valueType, position: position);

  factory PrefabNode.fromJson(Map<String, dynamic> json) => _$PrefabNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$PrefabNodeToJson);

  @override
  Value toAstValue() => flatten().first.toAstValue();

  double get bodyHeight => 100;

  @override
  Size get size {
    return Size(
      180,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  String get description => valueType.description;

  List<PrefabProperty> properties;

  void updateProperty(String name, String newValue) {
    for (var v in properties) {
      if (v.name == name) {
        v.value = newValue;
      }
    }
    notifyListeners();
  }

  /// Convert to a tree of nodes. Once converted, that tree couldn't be
  /// converted back to the prefab node.
  /// In most cases flattened object should be a single ast node, but it could be
  /// multiple nodes, e.g. several nodes as a group of call results.
  List<AstNode> flatten() {
    final map = {
      ValueType.prefabSecp256k1GetBalance: convertGetBalance,
      ValueType.prefabSecp256k1MapCapacities: convertMapCapacities,
      ValueType.prefabSecp256k1QueryCells: convertQueryCells,
      ValueType.prefabUdt: convertUdt,
      ValueType.prefabUdtGetBalance: convertUdtGetBalance,
      ValueType.prefabUdtTransfer: convertUdtTransfer,
    };

    final convert = map[valueType];
    if (convert != null) {
      return convert(this);
    }

    throw UnimplementedError();
  }
}
