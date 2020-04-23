import 'dart:ffi';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:convert/convert.dart';

import 'protos/ast.pb.dart';

// The [animagus balance](https://github.com/xxuejie/animagus/tree/master/examples/balance) example.

Value queryCellNode() {
  var cell = Value();
  cell.t = Value_Type.ARG;
  cell.u = Int64();
  var script = Value();
  script.t = Value_Type.GET_LOCK;
  script.children.add(cell);

  var codeHashValue = Value();
  codeHashValue.t = Value_Type.BYTES;
  codeHashValue.raw = hex.decode('9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8');
  var codeHash = Value();
  codeHash.t = Value_Type.GET_CODE_HASH;
  codeHash.children.add(script);
  var codeHashTest = Value();
  codeHashTest.t = Value_Type.EQUAL;
  codeHashTest.children.add(codeHash);
  codeHashTest.children.add(codeHashValue);

  var hashTypeValue = Value();
  hashTypeValue.t = Value_Type.UINT64;
  hashTypeValue.u = Int64(1);
  var hashType = Value();
  hashType.t = Value_Type.GET_HASH_TYPE;
  hashType.children.add(script);
  var hashTypeTest = Value();
  hashTypeTest.t = Value_Type.EQUAL;
  hashTypeTest.children.add(hashType);
  hashTypeTest.children.add(hashTypeValue);

  var argsValue = Value();
  argsValue.t = Value_Type.PARAM;
  argsValue.u = Int64();
  var args = Value();
  args.t = Value_Type.GET_ARGS;
  args.children.add(script);
  var argsTest = Value();
  argsTest.t = Value_Type.EQUAL;
  argsTest.children.add(args);
  argsTest.children.add(argsValue);

  Value and = Value();
  and.t = Value_Type.AND;
  and.children.add(codeHashTest);
  and.children.add(hashTypeTest);
  and.children.add(argsTest);

  Value result = Value();
  result.t = Value_Type.QUERY_CELLS;
  result.children.add(and);
  return result;
}

Value executionNode(Value queryCellNode) {
  var addBalance = Value();
  addBalance.t = Value_Type.ADD;
  var arg1 = Value();
  arg1.t = Value_Type.ARG;
  arg1.u = Int64();
  addBalance.children.add(arg1);
  var arg2 = Value();
  arg2.t = Value_Type.ARG;
  arg2.u = Int64(1);
  addBalance.children.add(arg2);

  var initialBalance = Value();
  initialBalance.t = Value_Type.UINT64;
  initialBalance.u = Int64();

  var getCapacity = Value();
  getCapacity.t = Value_Type.GET_CAPACITY;
  var arg = Value();
  arg.t = Value_Type.ARG;
  arg.u = Int64();
  getCapacity.children.add(arg);
  var capacities = Value();
  capacities.t = Value_Type.MAP;
  capacities.children.addAll([getCapacity, queryCellNode]);

  Value result = Value();
  result.t = Value_Type.REDUCE;
  result.children.addAll([
    addBalance,
    initialBalance,
    capacities,
  ]);
  return result;
}

Root buildRoot(String name, Value node) {
  Call call = Call();
  call.name = name;
  call.result = node;
  Root result = Root();
  result.calls.add(call);
  return result;
}

Uint8List output() {
  Root root = buildRoot(
    'balance',
    executionNode(queryCellNode())
  );
  return root.writeToBuffer();
}
