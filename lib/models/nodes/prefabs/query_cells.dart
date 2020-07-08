import 'helper.dart';

import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/op_node.dart';
import '../../nodes/get_op_node.dart';
import '../../nodes/primitive_node.dart';

List<AstNode> convertQueryCells(PrefabNode node) {
  final queryCells = AstNode(valueType: ValueType.queryCells);
  queryCells.name = 'cells';

  final queryTest = AstNode(valueType: ValueType.and);
  queryCells.addChild(queryTest, queryCells.addSlot('and').id);

  final codeHash = OperationNode(valueType: ValueType.equal);
  codeHash.name = 'code hash';
  queryTest.addChild(codeHash, queryTest.addSlot('code hash').id);

  final getCodeHash = GetOpNode(valueType: ValueType.getCodeHash);
  codeHash.addChild(getCodeHash, codeHash.slots.first.id);
  final codeHashValue = PrimitiveNode(valueType: ValueType.bytes);
  codeHashValue.value = secpTypeHash;
  codeHash.addChild(codeHashValue, codeHash.slots.last.id);

  final lock = GetOpNode(valueType: ValueType.getLock);
  lock.name = 'script lock';
  final arg0 = PrimitiveNode(valueType: ValueType.arg);
  arg0.name = 'arg0 as cell';
  arg0.value = '0';
  lock.addChild(arg0, lock.slots.first.id);

  getCodeHash.addChild(lock, getCodeHash.slots.first.id);

  final hashType = OperationNode(valueType: ValueType.equal);
  hashType.name = 'hash type';
  queryTest.addChild(hashType, queryTest.addSlot('hash type').id);
  final getHashType = GetOpNode(valueType: ValueType.getHashType);
  getHashType.addChild(lock, getHashType.slots.first.id);
  hashType.addChild(getHashType, hashType.slots.first.id);
  final hashTypeValue = PrimitiveNode(valueType: ValueType.uint64);
  hashTypeValue.value = '1';
  hashType.addChild(hashTypeValue, hashType.slots.last.id);

  final args = OperationNode(valueType: ValueType.equal);
  args.name = 'args';
  queryTest.addChild(args, queryTest.addSlot('args').id);
  final getArgs = GetOpNode(valueType: ValueType.getArgs);
  getArgs.addChild(lock, getArgs.slots.first.id);
  args.addChild(getArgs, args.slots.first.id);
  final param0 = PrimitiveNode(valueType: ValueType.param);
  param0.name = 'param0';
  args.addChild(param0, args.slots.last.id);

  return [autoLayout(queryCells, initialPosition: node.position)];
}
