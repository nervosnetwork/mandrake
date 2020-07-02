// import 'helper.dart';

import '../ast_node.dart';
import '../prefab_node.dart';
import '../primitive_node.dart';

AstNode convertUdt(PrefabNode node) {
  final todo = PrimitiveNode(
    valueType: ValueType.arg,
    position: node.position,
  );
  return todo;
}
