import 'helper.dart';

import '../../document.dart';
import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/primitive_node.dart';

AstNode convertGetBalance(Document doc, PrefabNode node) {
  final balance = AstNode(valueType: ValueType.reduce, position: node.position);

  final func = AstNode(
    valueType: ValueType.add,
    position: standByMe(balance, 3, 0),
  );
  func.setName('current');
  balance.addChild(func, balance.addSlot('current').id);

  final arg0 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(func, 2, 0),
  );
  arg0.setName('arg0');
  func.addChild(arg0, func.addSlot('arg0').id);

  final arg1 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(func, 2, 1),
  );
  arg1.setName('arg1');
  func.addChild(arg1, func.addSlot('arg1').id);

  final current = PrimitiveNode(
    valueType: ValueType.uint64,
    position: standByMe(balance, 3, 1),
  );
  current.setName('current');
  current.setValue('0');
  balance.addChild(current, balance.addSlot('current').id);

  final capacities = PrefabNode(
    valueType: ValueType.prefabMapCapacities,
    position: standByMe(balance, 3, 2),
  );
  capacities.setName('capacities');
  balance.addChild(capacities, balance.addSlot('capacities').id);

  for (final node in balance.nodes) {
    doc.addNode(node);
  }

  return balance;
}
