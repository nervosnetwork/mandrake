///
//  Generated code. Do not modify.
//  source: ast.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Value_Type extends $pb.ProtobufEnum {
  static const Value_Type NIL = Value_Type._(0, 'NIL');
  static const Value_Type UINT64 = Value_Type._(1, 'UINT64');
  static const Value_Type BOOL = Value_Type._(2, 'BOOL');
  static const Value_Type BYTES = Value_Type._(3, 'BYTES');
  static const Value_Type ERROR = Value_Type._(4, 'ERROR');
  static const Value_Type ARG = Value_Type._(16, 'ARG');
  static const Value_Type PARAM = Value_Type._(17, 'PARAM');
  static const Value_Type OUT_POINT = Value_Type._(18, 'OUT_POINT');
  static const Value_Type CELL_INPUT = Value_Type._(19, 'CELL_INPUT');
  static const Value_Type CELL_DEP = Value_Type._(20, 'CELL_DEP');
  static const Value_Type SCRIPT = Value_Type._(21, 'SCRIPT');
  static const Value_Type CELL = Value_Type._(22, 'CELL');
  static const Value_Type TRANSACTION = Value_Type._(23, 'TRANSACTION');
  static const Value_Type HEADER = Value_Type._(24, 'HEADER');
  static const Value_Type APPLY = Value_Type._(25, 'APPLY');
  static const Value_Type REDUCE = Value_Type._(26, 'REDUCE');
  static const Value_Type LIST = Value_Type._(27, 'LIST');
  static const Value_Type QUERY_CELLS = Value_Type._(28, 'QUERY_CELLS');
  static const Value_Type MAP = Value_Type._(29, 'MAP');
  static const Value_Type FILTER = Value_Type._(30, 'FILTER');
  static const Value_Type GET_CAPACITY = Value_Type._(48, 'GET_CAPACITY');
  static const Value_Type GET_DATA = Value_Type._(49, 'GET_DATA');
  static const Value_Type GET_LOCK = Value_Type._(50, 'GET_LOCK');
  static const Value_Type GET_TYPE = Value_Type._(51, 'GET_TYPE');
  static const Value_Type GET_DATA_HASH = Value_Type._(52, 'GET_DATA_HASH');
  static const Value_Type GET_OUT_POINT = Value_Type._(53, 'GET_OUT_POINT');
  static const Value_Type GET_CODE_HASH = Value_Type._(54, 'GET_CODE_HASH');
  static const Value_Type GET_HASH_TYPE = Value_Type._(55, 'GET_HASH_TYPE');
  static const Value_Type GET_ARGS = Value_Type._(56, 'GET_ARGS');
  static const Value_Type GET_CELL_DEPS = Value_Type._(57, 'GET_CELL_DEPS');
  static const Value_Type GET_HEADER_DEPS = Value_Type._(58, 'GET_HEADER_DEPS');
  static const Value_Type GET_INPUTS = Value_Type._(59, 'GET_INPUTS');
  static const Value_Type GET_OUTPUTS = Value_Type._(60, 'GET_OUTPUTS');
  static const Value_Type GET_WITNESSES = Value_Type._(61, 'GET_WITNESSES');
  static const Value_Type GET_COMPACT_TARGET = Value_Type._(62, 'GET_COMPACT_TARGET');
  static const Value_Type GET_TIMESTAMP = Value_Type._(63, 'GET_TIMESTAMP');
  static const Value_Type GET_NUMBER = Value_Type._(64, 'GET_NUMBER');
  static const Value_Type GET_EPOCH = Value_Type._(65, 'GET_EPOCH');
  static const Value_Type GET_PARENT_HASH = Value_Type._(66, 'GET_PARENT_HASH');
  static const Value_Type GET_TRANSACTIONS_ROOT = Value_Type._(67, 'GET_TRANSACTIONS_ROOT');
  static const Value_Type GET_PROPOSALS_HASH = Value_Type._(68, 'GET_PROPOSALS_HASH');
  static const Value_Type GET_UNCLES_HASH = Value_Type._(69, 'GET_UNCLES_HASH');
  static const Value_Type GET_DAO = Value_Type._(70, 'GET_DAO');
  static const Value_Type GET_NONCE = Value_Type._(71, 'GET_NONCE');
  static const Value_Type GET_HEADER = Value_Type._(72, 'GET_HEADER');
  static const Value_Type HASH = Value_Type._(73, 'HASH');
  static const Value_Type SERIALIZE_TO_CORE = Value_Type._(74, 'SERIALIZE_TO_CORE');
  static const Value_Type SERIALIZE_TO_JSON = Value_Type._(75, 'SERIALIZE_TO_JSON');
  static const Value_Type NOT = Value_Type._(76, 'NOT');
  static const Value_Type AND = Value_Type._(77, 'AND');
  static const Value_Type OR = Value_Type._(78, 'OR');
  static const Value_Type EQUAL = Value_Type._(80, 'EQUAL');
  static const Value_Type LESS = Value_Type._(81, 'LESS');
  static const Value_Type LEN = Value_Type._(82, 'LEN');
  static const Value_Type SLICE = Value_Type._(83, 'SLICE');
  static const Value_Type INDEX = Value_Type._(84, 'INDEX');
  static const Value_Type ADD = Value_Type._(85, 'ADD');
  static const Value_Type SUBTRACT = Value_Type._(86, 'SUBTRACT');
  static const Value_Type MULTIPLY = Value_Type._(87, 'MULTIPLY');
  static const Value_Type DIVIDE = Value_Type._(88, 'DIVIDE');
  static const Value_Type MOD = Value_Type._(89, 'MOD');
  static const Value_Type COND = Value_Type._(120, 'COND');
  static const Value_Type TAIL_RECURSION = Value_Type._(121, 'TAIL_RECURSION');

  static const $core.List<Value_Type> values = <Value_Type> [
    NIL,
    UINT64,
    BOOL,
    BYTES,
    ERROR,
    ARG,
    PARAM,
    OUT_POINT,
    CELL_INPUT,
    CELL_DEP,
    SCRIPT,
    CELL,
    TRANSACTION,
    HEADER,
    APPLY,
    REDUCE,
    LIST,
    QUERY_CELLS,
    MAP,
    FILTER,
    GET_CAPACITY,
    GET_DATA,
    GET_LOCK,
    GET_TYPE,
    GET_DATA_HASH,
    GET_OUT_POINT,
    GET_CODE_HASH,
    GET_HASH_TYPE,
    GET_ARGS,
    GET_CELL_DEPS,
    GET_HEADER_DEPS,
    GET_INPUTS,
    GET_OUTPUTS,
    GET_WITNESSES,
    GET_COMPACT_TARGET,
    GET_TIMESTAMP,
    GET_NUMBER,
    GET_EPOCH,
    GET_PARENT_HASH,
    GET_TRANSACTIONS_ROOT,
    GET_PROPOSALS_HASH,
    GET_UNCLES_HASH,
    GET_DAO,
    GET_NONCE,
    GET_HEADER,
    HASH,
    SERIALIZE_TO_CORE,
    SERIALIZE_TO_JSON,
    NOT,
    AND,
    OR,
    EQUAL,
    LESS,
    LEN,
    SLICE,
    INDEX,
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    MOD,
    COND,
    TAIL_RECURSION,
  ];

  static final $core.Map<$core.int, Value_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Value_Type valueOf($core.int value) => _byValue[value];

  const Value_Type._($core.int v, $core.String n) : super(v, n);
}

