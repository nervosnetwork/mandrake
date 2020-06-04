import 'helper.dart';

import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/get_op_node.dart';
import '../../nodes/primitive_node.dart';

AstNode convertMapCapacities(PrefabNode node) {
  final mapCapacities = AstNode(valueType: ValueType.map, position: node.position);
  mapCapacities.setName('capacities');

  final getCapacity = GetOpNode(
    valueType: ValueType.getCapacity,
    position: standByMe(mapCapacities, 2, 0),
  );
  mapCapacities.addChild(getCapacity, mapCapacities.addSlot('get capacity').id);

  final arg0 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(getCapacity, 1, 0),
  );
  arg0.setName('arg0');
  getCapacity.addChild(arg0, getCapacity.slots.first.id);

  final cells = PrefabNode(
    valueType: ValueType.prefabQueryCells,
    position: standByMe(mapCapacities, 2, 1),
  );
  mapCapacities.addChild(cells, mapCapacities.addSlot('cells').id);

  return mapCapacities;
}
