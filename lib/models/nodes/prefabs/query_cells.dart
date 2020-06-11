import 'helper.dart';

import '../../nodes/ast_node.dart';
import '../../nodes/prefab_node.dart';
import '../../nodes/op_node.dart';
import '../../nodes/get_op_node.dart';
import '../../nodes/primitive_node.dart';

AstNode convertQueryCells(PrefabNode node) {
  final queryCells = AstNode(valueType: ValueType.queryCells, position: node.position);
  queryCells.name = 'cells';

  final queryTest = AstNode(valueType: ValueType.and, position: standByMe(queryCells, 1, 0));
  queryCells.addChild(queryTest, queryCells.addSlot('and').id);

  final codeHash = OperationNode(
    valueType: ValueType.equal,
    position: standByMe(queryTest, 3, 0),
  );
  codeHash.name = 'code hash';
  queryTest.addChild(codeHash, queryTest.addSlot('code hash').id);

  final codeHashValue = PrimitiveNode(
    valueType: ValueType.bytes,
    position: standByMe(codeHash, 2, 0),
  );
  codeHashValue.value = '0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8';
  codeHash.addChild(codeHashValue, codeHash.slots.first.id);
  final getCodeHash = GetOpNode(
    valueType: ValueType.getCodeHash,
    position: standByMe(codeHash, 2, 1),
  );
  codeHash.addChild(getCodeHash, codeHash.slots.last.id);

  final lock = GetOpNode(
    valueType: ValueType.getLock,
    position: standByMe(getCodeHash, 1, 0),
  );
  lock.name = 'script lock';
  final arg0 = PrimitiveNode(
    valueType: ValueType.arg,
    position: standByMe(lock, 1, 0),
  );
  arg0.name = 'arg0 as cell';
  lock.addChild(arg0, lock.slots.first.id);

  getCodeHash.addChild(lock, getCodeHash.slots.first.id);

  final hashType = OperationNode(
    valueType: ValueType.equal,
    position: standByMe(queryTest, 3, 1),
  );
  hashType.name = 'hash type';
  queryTest.addChild(hashType, queryTest.addSlot('hash type').id);
  final hashTypeValue = PrimitiveNode(
    valueType: ValueType.uint64,
    position: standByMe(hashType, 3, 1),
  );
  hashTypeValue.value = '1';
  hashType.addChild(hashTypeValue, hashType.slots.first.id);
  final getHashType = GetOpNode(
    valueType: ValueType.getHashType,
    position: standByMe(hashType, 3, 2),
  );
  getHashType.addChild(lock, getHashType.slots.first.id);
  hashType.addChild(getHashType, hashType.slots.last.id);

  final args = OperationNode(
    valueType: ValueType.equal,
    position: standByMe(queryTest, 3, 2),
  );
  args.name = 'args';
  queryTest.addChild(args, queryTest.addSlot('args').id);
  final getArgs = GetOpNode(
    valueType: ValueType.getArgs,
    position: standByMe(args, 3, 2),
  );
  getArgs.addChild(lock, getArgs.slots.first.id);
  args.addChild(getArgs, args.slots.first.id);
  final param0 = PrimitiveNode(
    valueType: ValueType.param,
    position: standByMe(args, 3, 3),
  );
  param0.name = 'param0';
  args.addChild(param0, args.slots.last.id);

  return queryCells;
}
