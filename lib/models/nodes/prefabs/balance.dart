import 'package:fixnum/fixnum.dart';

import 'helper.dart';
import '../../../utils/node_position.dart';
import '../../node.dart';
import '../ast_node.dart';
import '../prefab_node.dart';
import '../primitive_node.dart';

/// Secp256k1 get balance
List<AstNode> convertGetBalance(PrefabNode node) {
  final balance = AstNode(valueType: ValueType.reduce);
  balance.name = 'balance';
  node.doc.addNode(balance);

  final func = AstNode(valueType: ValueType.add);
  func.name = 'func';
  balance.addChild(func, balance.addSlot('func').id);

  final arg0 = PrimitiveNode(valueType: ValueType.arg);
  arg0.name = 'arg0';
  arg0.value = '0';
  func.addChild(arg0, func.addSlot('arg0').id);

  final arg1 = PrimitiveNode(valueType: ValueType.arg);
  arg1.name = 'arg1';
  arg1.value = '1';
  func.addChild(arg1, func.addSlot('arg1').id);

  final current = PrimitiveNode(valueType: ValueType.uint64);
  current.name = 'current';
  current.value = '0';
  balance.addChild(current, balance.addSlot('current').id);

  final capacities = PrefabNode(valueType: ValueType.prefabSecp256k1MapCapacities);
  capacities.name = 'capacities';
  balance.addChild(capacities, balance.addSlot('capacities').id);

  return [autoLayout(balance, initialPosition: node.position)];
}

List<AstNode> convertMapCapacities(PrefabNode node) {
  final mapCapacities = AstNode(valueType: ValueType.map, position: node.position);
  mapCapacities.name = 'capacities';
  node.doc.addNode(mapCapacities);

  final getCapacity = GetOpNode(valueType: ValueType.getCapacity);
  mapCapacities.addChild(getCapacity, mapCapacities.addSlot('get capacity').id);

  final arg0 = arg(Int64(0));
  arg0.name = 'arg0';
  getCapacity.addChild(arg0, getCapacity.slots.first.id);

  final cells = PrefabNode(valueType: ValueType.prefabSecp256k1QueryCells);
  mapCapacities.addChild(cells, mapCapacities.addSlot('cells').id);

  return [autoLayout(mapCapacities, initialPosition: node.position)];
}

/// Secp256k1 query cells
List<AstNode> convertQueryCells(PrefabNode node) {
  final queryCells = AstNode(valueType: ValueType.queryCells);
  queryCells.name = 'cells';
  node.doc.addNode(queryCells);

  final queryTest = AstNode(valueType: ValueType.and);
  queryCells.addChild(queryTest, queryCells.addSlot('and').id);

  final getCodeHash = GetOpNode(valueType: ValueType.getCodeHash);
  final codeHashValue = PrimitiveNode(valueType: ValueType.bytes);
  codeHashValue.value = findPropValue(node.properties, 'Secp256k1 lock hash') ?? secpTypeHash;
  final codeHash = equal(getCodeHash, codeHashValue, node.doc);
  codeHash.name = 'code hash';
  queryTest.addChild(codeHash, queryTest.addSlot('code hash').id);

  final lock = GetOpNode(valueType: ValueType.getLock);
  lock.name = 'script lock';
  getCodeHash.addChild(lock, getCodeHash.slots.first.id);
  final arg0 = arg(Int64(0));
  arg0.name = 'arg0 as cell';
  lock.addChild(arg0, lock.slots.first.id);

  final getHashType = GetOpNode(valueType: ValueType.getHashType);
  final hashTypeValue = uintValue(Int64(1));
  final hashType = equal(getHashType, hashTypeValue, node.doc);
  getHashType.addChild(lock, getHashType.slots.first.id);
  hashType.name = 'hash type';
  queryTest.addChild(hashType, queryTest.addSlot('hash type').id);

  final getArgs = GetOpNode(valueType: ValueType.getArgs);
  final param0 = param(Int64(0));
  param0.name = 'param0';
  final args = equal(getArgs, param0, node.doc);
  args.name = 'args';
  getArgs.addChild(lock, getArgs.slots.first.id);
  queryTest.addChild(args, queryTest.addSlot('args').id);

  return [autoLayout(queryCells, initialPosition: node.position)];
}
