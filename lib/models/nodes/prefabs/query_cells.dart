import 'package:fixnum/fixnum.dart';

import 'helper.dart';

import '../../../utils/node_position.dart';
import '../../node.dart';

/// Secp256k1 query cells
List<AstNode> convertQueryCells(PrefabNode node) {
  final queryCells = AstNode(valueType: ValueType.queryCells);
  queryCells.name = 'cells';

  final queryTest = AstNode(valueType: ValueType.and);
  queryCells.addChild(queryTest, queryCells.addSlot('and').id);

  final getCodeHash = GetOpNode(valueType: ValueType.getCodeHash);
  final codeHashValue = PrimitiveNode(valueType: ValueType.bytes);
  codeHashValue.value = secpTypeHash;
  final codeHash = equal(getCodeHash, codeHashValue);
  codeHash.name = 'code hash';
  queryTest.addChild(codeHash, queryTest.addSlot('code hash').id);

  final lock = GetOpNode(valueType: ValueType.getLock);
  lock.name = 'script lock';
  final arg0 = arg(Int64(0));
  arg0.name = 'arg0 as cell';
  lock.addChild(arg0, lock.slots.first.id);

  getCodeHash.addChild(lock, getCodeHash.slots.first.id);

  final getHashType = GetOpNode(valueType: ValueType.getHashType);
  getHashType.addChild(lock, getHashType.slots.first.id);
  final hashTypeValue = uintValue(Int64(1));
  final hashType = equal(getHashType, hashTypeValue);
  hashType.name = 'hash type';
  queryTest.addChild(hashType, queryTest.addSlot('hash type').id);

  final getArgs = GetOpNode(valueType: ValueType.getArgs);
  getArgs.addChild(lock, getArgs.slots.first.id);
  final param0 = param(Int64(0));
  param0.name = 'param0';
  final args = equal(getArgs, param0);
  args.name = 'args';
  queryTest.addChild(args, queryTest.addSlot('args').id);

  return [autoLayout(queryCells, initialPosition: node.position)];
}
