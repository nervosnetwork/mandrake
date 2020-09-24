import 'package:fixnum/fixnum.dart';

import 'helper.dart';

import '../../node.dart';
import '../../../utils/node_position.dart';

List<AstNode> convertUdtGetBalance(PrefabNode node) => _UdtConverter(node).convertGetBalance();

List<AstNode> convertUdtTransfer(PrefabNode node) => _UdtConverter(node).convertTransfer();

List<AstNode> convertUdt(PrefabNode node) => _UdtConverter(node).convert();

class _UdtConverter {
  _UdtConverter(this.node);

  final PrefabNode node;
  List<PrefabProperty> get props => node.properties;

  List<AstNode> convertGetBalance() {
    return [
      autoLayout(_balance()..name = 'balance', initialPosition: node.position),
    ];
  }

  List<AstNode> convertTransfer() {
    return [
      autoLayout(_transfer()..name = 'transfer', initialPosition: node.position),
    ];
  }

  List<AstNode> convert() {
    return [
      autoLayout(
        _ready()..name = 'ready',
        initialPosition: node.position,
      ),
      autoLayout(
        PrefabNode(valueType: ValueType.prefabUdtGetBalance)..name = 'balance',
        initialPosition: standBelowMe(node, 1),
      ),
      autoLayout(
        applyDefaultPrefabProperties(PrefabNode(valueType: ValueType.prefabUdtTransfer))
          ..name = 'transfer',
        initialPosition: standBelowMe(node, 3),
      ),
    ];
  }

  AstNode _ready() {
    final ready = AstNode(valueType: ValueType.equal);

    final typeCellsLength = OperationNode(valueType: ValueType.len);
    typeCellsLength.addChild(
      _typeCells(),
      typeCellsLength.slots.first.id,
    );

    final lengthValue = PrimitiveNode(valueType: ValueType.uint64);
    lengthValue.value = '1';

    ready.addChild(typeCellsLength, ready.addSlot('type cells length').id);
    ready.addChild(lengthValue, ready.addSlot('1').id);

    return ready;
  }

  AstNode _balance() {
    final add = AstNode(valueType: ValueType.add);
    add.addChild(arg(Int64(0)), add.addSlot('arg0').id);
    add.addChild(arg(Int64(1)), add.addSlot('arg1').id);

    final mapFuns = (AstNode aList, List<AstNode> funcs) {
      var list = aList;
      for (final func in funcs) {
        final newList = AstNode(valueType: ValueType.map);
        newList.addChild(func, newList.addSlot('func').id);
        newList.addChild(list, newList.addSlot('list').id);
        list = newList;
      }
      return list;
    };

    final slice = AstNode(valueType: ValueType.slice);
    slice.addChild(uintValue(Int64(0)), slice.addSlot('0').id);
    slice.addChild(uintValue(Int64(16)), slice.addSlot('16').id);
    slice.addChild(arg(Int64(0)), slice.addSlot('arg0').id);
    final tokens = mapFuns(_inputCells(), [
      getField(ValueType.getData, arg(Int64(0)), node.doc),
      slice,
    ]);

    final reduce = AstNode(valueType: ValueType.reduce);
    reduce.addChild(add, reduce.addSlot('func').id);
    reduce.addChild(
      bytesValue('0x00000000000000000000000000000000'),
      reduce.addSlot('zero bytes').id,
    );
    reduce.addChild(tokens, reduce.addSlot('tokens').id);

    final result = AstNode(valueType: ValueType.slice);
    result.addChild(uintValue(Int64(0)), result.addSlot('0').id);
    result.addChild(uintValue(Int64(16)), result.addSlot('16').id);
    result.addChild(reduce, result.addSlot('added').id);
    return result;
  }

  AstNode _transfer() {
    final transaction = AstNode(valueType: ValueType.transaction);
    transaction.addChild(
      _inputCells(),
      transaction.addSlot('inputs').id,
    );

    final outputs = AstNode(valueType: ValueType.list);
    outputs.addChild(_transferCell(), outputs.addSlot('transfer').id);
    outputs.addChild(_changeCell(), outputs.addSlot('change').id);
    transaction.addChild(
      outputs,
      transaction.addSlot('outputs').id,
    );

    final cellDeps = AstNode(valueType: ValueType.list);
    cellDeps.addChild(
      _assembleSecpCellDep(),
      cellDeps.addSlot('secp cell dep').id,
    );
    final index = AstNode(valueType: ValueType.index);
    final indexValue = PrimitiveNode(valueType: ValueType.uint64);
    indexValue.value = '0';
    index.addChild(indexValue, index.addSlot('0').id);
    index.addChild(
      _typeCells(),
      index.addSlot('type cells').id,
    );
    cellDeps.addChild(index, cellDeps.addSlot('index').id);
    transaction.addChild(
      cellDeps,
      transaction.addSlot('cell deps').id,
    );

    final result = OperationNode(valueType: ValueType.serializeToJson);
    result.addChild(_adjustFee(transaction), result.slots.first.id);
    return result;
  }

  AstNode _adjustFee(AstNode tx) {
    final serialized = OperationNode(valueType: ValueType.serializeToCore);
    serialized.addChild(tx, serialized.slots.first.id);
    final length = OperationNode(valueType: ValueType.len);
    length.addChild(serialized, length.slots.first.id);
    final addedLength = add(length, uintValue(Int64(100)), node.doc);
    final fee = OperationNode(valueType: ValueType.multiply);
    fee.addChild(addedLength, fee.slots.first.id);
    fee.addChild(uintValue(Int64(1)), fee.slots.last.id);

    final changeCell = tx.children[1].children[1];
    final adjustedChangeCell = OperationNode(valueType: ValueType.cell);
    adjustedChangeCell.addChild(
      subtract(changeCell.children[0], fee, node.doc),
      adjustedChangeCell.slots.first.id,
    );
    adjustedChangeCell.addChild(
      changeCell.children[1],
      adjustedChangeCell.addSlot('secp lock').id,
    );
    adjustedChangeCell.addChild(
      changeCell.children[2],
      adjustedChangeCell.addSlot('udt type').id,
    );
    adjustedChangeCell.addChild(
      changeCell.children[3],
      adjustedChangeCell.addSlot('tokens').id,
    );

    final outputs = AstNode(valueType: ValueType.list);
    outputs.addChild(tx.children[1].children[0], outputs.addSlot('amount').id);
    outputs.addChild(adjustedChangeCell, outputs.addSlot('change').id);
    final result = AstNode(valueType: ValueType.transaction);
    result.addChild(tx.children[0], result.addSlot('inputs').id);
    result.addChild(outputs, result.addSlot('outputs').id);
    result.addChild(tx.children[2], result.addSlot('cell deps').id);
    return result;
  }

  AstNode _typeCells() {
    final queryCells = AstNode(valueType: ValueType.queryCells);
    queryCells.name = 'type cells';

    final dataHashTest = OperationNode(valueType: ValueType.equal);
    dataHashTest.name = 'data hash';
    queryCells.addChild(dataHashTest, queryCells.addSlot('data hash').id);

    final getDataHash = GetOpNode(valueType: ValueType.getDataHash);

    getDataHash.addChild(arg(Int64(0)), getDataHash.slots.first.id);

    final codeHash = PrimitiveNode(valueType: ValueType.bytes);
    codeHash.value = findPropValue(props, 'UDT code hash') ?? defaultUdtCodeHash;

    dataHashTest.addChild(getDataHash, dataHashTest.slots.first.id);
    dataHashTest.addChild(codeHash, dataHashTest.slots.last.id);

    return queryCells;
  }

  AstNode _inputCells() {
    final queryCells = AstNode(valueType: ValueType.queryCells);
    final and = OperationNode(valueType: ValueType.and);
    and.addChild(
        _isDefaultSecpCell(
          Int64(0),
        ),
        and.slots.first.id);
    and.addChild(
      _isSimpleUdtCell(
        Int64(0),
        Int64(0),
        findPropValue(props, 'UDT code hash') ?? defaultUdtCodeHash,
      ),
      and.slots.last.id,
    );
    queryCells.addChild(and, queryCells.addSlot('cells').id);
    return queryCells;
  }

  AstNode _transferCell() {
    final result = AstNode(valueType: ValueType.cell);
    result.addChild(_transferValue(), result.addSlot('value').id);
    result.addChild(
        _assembleSecpLock(
          Int64(2),
        ),
        result.addSlot('secp lock').id);
    result.addChild(
        _assembleUdtType(
          Int64(0),
        ),
        result.addSlot('udt type').id);
    result.addChild(_transferTokens(), result.addSlot('tokens').id);
    return result;
  }

  AstNode _changeCell() {
    final result = AstNode(valueType: ValueType.cell);
    result.addChild(_changeCapacities(), result.addSlot('value').id);
    result.addChild(
        _assembleSecpLock(
          Int64(1),
        ),
        result.addSlot('secp lock').id);
    result.addChild(
        _assembleUdtType(
          Int64(0),
        ),
        result.addSlot('udt type').id);
    result.addChild(_changeTokens(), result.addSlot('tokens').id);
    return result;
  }

  AstNode _transferTokens() {
    final result = AstNode(valueType: ValueType.slice);
    result.addChild(uintValue(Int64(0)), result.addSlot('0').id);
    result.addChild(uintValue(Int64(16)), result.addSlot('16').id);
    result.addChild(
      add(bytesValue('0x00000000000000000000000000000000'), param(Int64(3)), node.doc),
      result.addSlot('add').id,
    );
    return result;
  }

  AstNode _totalCapacities() {
    final map = AstNode(valueType: ValueType.map);
    map.addChild(
      getField(ValueType.getCapacity, arg(Int64(0)), node.doc),
      map.addSlot('get capacity').id,
    );
    map.addChild(_inputCells(), map.addSlot('cells').id);

    final result = AstNode(valueType: ValueType.reduce);
    result.addChild(
      add(arg(Int64(0)), arg(Int64(1)), node.doc),
      result.addSlot('arg0 + arg1').id,
    );
    result.addChild(
      uintValue(Int64(0)),
      result.addSlot('0').id,
    );
    result.addChild(
      map,
      result.addSlot('map get capacity').id,
    );
    return result;
  }

  AstNode _transferValue() {
    return uintValue(Int64(142 * 100000000));
  }

  AstNode _changeCapacities() {
    return subtract(_totalCapacities(), _transferValue(), node.doc);
  }

  AstNode _changeTokens() {
    final result = AstNode(valueType: ValueType.slice);
    result.addChild(uintValue(Int64(0)), result.addSlot('0').id);
    result.addChild(uintValue(Int64(16)), result.addSlot('16').id);
    result.addChild(
        subtract(_balance(), _transferTokens(), node.doc), result.addSlot('change token').id);
    return result;
  }

  AstNode _isDefaultSecpCell(
    Int64 argIndex,
  ) {
    final lock = getField(ValueType.getLock, arg(argIndex), node.doc);

    final codeHash = equal(
      getField(ValueType.getCodeHash, lock, node.doc),
      bytesValue(findPropValue(props, 'Secp256k1 lock hash') ?? secpTypeHash),
      node.doc,
    );
    final hashType = equal(
      getField(ValueType.getHashType, lock, node.doc),
      uintValue(Int64(1)),
      node.doc,
    );
    final args = equal(
      getField(ValueType.getArgs, lock, node.doc),
      param(Int64(1)),
      node.doc,
    );

    final result = OperationNode(valueType: ValueType.and);
    result.addChild(codeHash, result.slots.first.id);
    result.addChild(hashType, result.slots.last.id);
    result.addChild(args, result.addSlot('args').id);
    return result;
  }

  AstNode _isSimpleUdtCell(Int64 argIndex, Int64 paramIndex, String udtCodeHash) {
    final getType = getField(ValueType.getType, arg(argIndex), node.doc);

    final codeHash = equal(
      getField(ValueType.getCodeHash, getType, node.doc),
      bytesValue(udtCodeHash),
      node.doc,
    );
    final hashType = equal(
      getField(ValueType.getHashType, getType, node.doc),
      uintValue(Int64(0)),
      node.doc,
    );
    final args = equal(
      getField(ValueType.getArgs, getType, node.doc),
      param(paramIndex),
      node.doc,
    );

    final result = OperationNode(valueType: ValueType.and);
    result.addChild(codeHash, result.slots.first.id);
    result.addChild(hashType, result.slots.last.id);
    result.addChild(args, result.addSlot('args').id);
    return result;
  }

  AstNode _assembleSecpLock(
    Int64 paramIndex,
  ) {
    final result = AstNode(valueType: ValueType.script);
    result.addChild(
      bytesValue(findPropValue(props, 'Secp256k1 lock hash') ?? secpTypeHash),
      result.addSlot('sepc type hash').id,
    );
    result.addChild(uintValue(Int64(1)), result.addSlot('1').id);
    result.addChild(param(paramIndex), result.addSlot('param').id);
    return result;
  }

  AstNode _assembleUdtType(
    Int64 paramIndex,
  ) {
    final result = AstNode(valueType: ValueType.script);
    result.addChild(
      bytesValue(findPropValue(props, 'UDT code hash') ?? defaultUdtCodeHash),
      result.addSlot('udt code hash').id,
    );
    result.addChild(uintValue(Int64(0)), result.addSlot('0').id);
    result.addChild(param(paramIndex), result.addSlot('param').id);
    return result;
  }

  AstNode _assembleSecpCellDep() {
    final result = AstNode(valueType: ValueType.cellDep);

    final outPoint = AstNode(valueType: ValueType.outPoint);
    final secpCellBytes =
        bytesValue(findPropValue(props, 'Secp256k1 cell dep') ?? secpCellDepDevnet);
    outPoint.addChild(secpCellBytes, outPoint.addSlot('secp cell dep').id);
    final outPointIndex = uintValue(Int64(0));
    outPoint.addChild(outPointIndex, outPoint.addSlot('0').id);
    result.addChild(outPoint, result.addSlot('out point').id);

    final indexValue = uintValue(Int64(1));
    result.addChild(indexValue, result.addSlot('1').id);

    return result;
  }
}
