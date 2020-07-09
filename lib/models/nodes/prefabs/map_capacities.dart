import 'package:fixnum/fixnum.dart';

import 'helper.dart';

import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/get_op_node.dart';

List<AstNode> convertMapCapacities(PrefabNode node) {
  final mapCapacities = AstNode(valueType: ValueType.map, position: node.position);
  mapCapacities.name = 'capacities';

  final getCapacity = GetOpNode(valueType: ValueType.getCapacity);
  mapCapacities.addChild(getCapacity, mapCapacities.addSlot('get capacity').id);

  final arg0 = arg(Int64(0));
  arg0.name = 'arg0';
  getCapacity.addChild(arg0, getCapacity.slots.first.id);

  final cells = PrefabNode(valueType: ValueType.prefabQueryCells);
  mapCapacities.addChild(cells, mapCapacities.addSlot('cells').id);

  return [autoLayout(mapCapacities, initialPosition: node.position)];
}
