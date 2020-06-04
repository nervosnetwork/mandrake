import 'helper.dart';

import '../../document.dart';
import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/get_op_node.dart';
import '../../nodes/primitive_node.dart';

AstNode convertMapCapacities(Document doc, PrefabNode node) {
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
  getCapacity.addChild(arg0, getCapacity.addSlot('arg0').id);

  final cells = PrefabNode(
    valueType: ValueType.prefabQueryCells,
    position: standByMe(mapCapacities, 2, 1),
  );
  mapCapacities.addChild(cells, mapCapacities.addSlot('cells').id);

  for (final node in mapCapacities.nodes) {
    doc.addNode(node);
  }

  return mapCapacities;
}
