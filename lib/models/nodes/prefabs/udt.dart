import 'dart:ui' show Offset;

import 'helper.dart';

import '../ast_node.dart';
import '../prefab_node.dart';
// import '../primitive_node.dart';

List<AstNode> convertUdt(PrefabNode node) {
  return [
    _readyCall(node.position),
    _balanceCall(standBelowMe(node, 0)),
    _transferCall(standBelowMe(node, 1)),
  ];
}

AstNode _readyCall(Offset position) {
  // TODO
  return AstNode(
    valueType: ValueType.equal,
    position: position,
  );
}

AstNode _balanceCall(Offset position) {
  // TODO
  return AstNode(
    valueType: ValueType.reduce,
    position: position,
  );
}

AstNode _transferCall(Offset position) {
  // TODO
  return AstNode(
    valueType: ValueType.serializeToJson,
    position: position,
  );
}
