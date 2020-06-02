import 'dart:ui' show Offset;

import '../document.dart';
import '../nodes/ast_node.dart';
import '../nodes/op_node.dart';
import '../nodes/get_op_node.dart';
import '../nodes/primitive_node.dart';

class QueryCellExampleNode {
  static AstNode create(Document doc, Offset pos) {
    final queryCells = AstNode(valueType: ValueType.queryCells, position: pos);
    queryCells.setName('cells');

    final queryTest = AstNode(valueType: ValueType.and, position: _standByMe(queryCells, 1, 0));
    queryCells.addChild(queryTest, queryCells.addSlot('and').id);

    final codeHash = OperationNode(
      valueType: ValueType.equal,
      position: _standByMe(queryTest, 3, 0),
    );
    codeHash.setName('code hash');
    queryTest.addChild(codeHash, queryTest.addSlot('code hash').id);

    final codeHashValue = PrimitiveNode(
      valueType: ValueType.bytes,
      position: _standByMe(codeHash, 2, 0),
    );
    codeHashValue.setValue('0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8');
    codeHash.addChild(codeHashValue, codeHash.slots.first.id);
    final getCodeHash = GetOpNode(
      valueType: ValueType.getCodeHash,
      position: _standByMe(codeHash, 2, 1),
    );
    codeHash.addChild(getCodeHash, codeHash.slots.last.id);

    final lock = GetOpNode(
      valueType: ValueType.getLock,
      position: _standByMe(getCodeHash, 1, 0),
    );
    lock.setName('script lock');
    final arg0 = PrimitiveNode(
      valueType: ValueType.arg,
      position: _standByMe(lock, 1, 0),
    );
    arg0.setName('arg0 as cell');
    lock.addChild(arg0, lock.slots.first.id);

    getCodeHash.addChild(lock, getCodeHash.slots.first.id);

    final hashType = OperationNode(
      valueType: ValueType.equal,
      position: _standByMe(queryTest, 3, 1),
    );
    hashType.setName('hash type');
    queryTest.addChild(hashType, queryTest.addSlot('hash type').id);
    final hashTypeValue = PrimitiveNode(
      valueType: ValueType.uint64,
      position: _standByMe(hashType, 3, 1),
    );
    hashTypeValue.setValue('1');
    hashType.addChild(hashTypeValue, hashType.slots.first.id);
    final getHashType = GetOpNode(
      valueType: ValueType.getHashType,
      position: _standByMe(hashType, 3, 2),
    );
    getHashType.addChild(lock, getHashType.slots.first.id);
    hashType.addChild(getHashType, hashType.slots.last.id);

    final args = OperationNode(
      valueType: ValueType.equal,
      position: _standByMe(queryTest, 3, 2),
    );
    args.setName('args');
    queryTest.addChild(args, queryTest.addSlot('args').id);
    final getArgs = GetOpNode(
      valueType: ValueType.getArgs,
      position: _standByMe(args, 3, 2),
    );
    getArgs.addChild(lock, getArgs.slots.first.id);
    args.addChild(getArgs, args.slots.first.id);
    final param0 = PrimitiveNode(
      valueType: ValueType.param,
      position: _standByMe(args, 3, 3),
    );
    param0.setName('param0');
    args.addChild(param0, args.slots.last.id);

    for (final node in queryCells.nodes) {
      doc.addNode(node);
    }

    return queryCells;
  }

  static Offset _standByMe(AstNode parent, int childrenCount, int index) {
    final h = parent.size.width + 80;
    final v = (index - childrenCount / 2) * 160 + 80;
    return parent.position + Offset(h, v);
  }
}
