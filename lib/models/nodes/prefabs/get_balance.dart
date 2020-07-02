import 'helper.dart';

import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/primitive_node.dart';

List<AstNode> convertGetBalance(PrefabNode node) {
  final balance = AstNode(valueType: ValueType.reduce, position: node.position);
  balance.name = 'balance';

  final func = AstNode(
    valueType: ValueType.add,
    position: standByMe(balance, 3, 0),
  );
  func.name = 'func';
  balance.addChild(func, balance.addSlot('func').id);

  final arg0 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(func, 2, 0),
  );
  arg0.name = 'arg0';
  arg0.value = '0';
  func.addChild(arg0, func.addSlot('arg0').id);

  final arg1 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(func, 2, 1),
  );
  arg1.name = 'arg1';
  arg1.value = '1';
  func.addChild(arg1, func.addSlot('arg1').id);

  final current = PrimitiveNode(
    valueType: ValueType.uint64,
    position: standByMe(balance, 3, 1),
  );
  current.name = 'current';
  current.value = '0';
  balance.addChild(current, balance.addSlot('current').id);

  final capacities = PrefabNode(
    valueType: ValueType.prefabMapCapacities,
    position: standByMe(balance, 3, 2),
  );
  capacities.name = 'capacities';
  balance.addChild(capacities, balance.addSlot('capacities').id);

  return [balance];
}
