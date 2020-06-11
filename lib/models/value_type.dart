import 'package:json_annotation/json_annotation.dart';
import 'package:mandrake/models/node.dart';
import '../protos/ast.pbenum.dart' show Value_Type;

part 'value_type.g.dart';

/// Encapsulate protos AST Value_Type class.
@JsonSerializable()
@Value_TypeJsonConverter()
class ValueType {
  const ValueType(this.rawType, [this.name = '', this.description = '']);

  factory ValueType.fromJson(Map<String, dynamic> json) {
    final parsed = _$ValueTypeFromJson(json);

    /// Map to static constants to make sure each value type only has one instance in use.
    for (final v in values) {
      if (v.rawType?.value == parsed.rawType?.value && v.name == parsed.name) {
        return v;
      }
    }
    return parsed;
  }
  Map<String, dynamic> toJson() => _$ValueTypeToJson(this);

  final Value_Type rawType;
  final String name;
  final String description;

  @override
  String toString() => rawType?.toString() ?? name;

  String get uiName {
    final separated = toString().split('_');
    return separated.map((w) {
      if (['JSON', 'DAO'].contains(w)) {
        return w;
      }
      return w[0] + w.substring(1).toLowerCase();
    }).join(' ');
  }

  static const ValueType prefabQueryCells = ValueType(
    null,
    'PREFAB_QUERY_CELLS',
    'Get all cells (default secp256k1_blake160).',
  );
  static const ValueType prefabMapCapacities = ValueType(
    null,
    'PREFAB_MAP_CAPACITIES',
    'Get cell capacities.',
  );
  static const ValueType prefabGetBalance = ValueType(
    null,
    'PREFAB_GET_BALANCE',
    'Calculate balance as total capacities.',
  );

  static const ValueType nil = ValueType(Value_Type.NIL);
  static const ValueType uint64 = ValueType(Value_Type.UINT64);
  static const ValueType bool = ValueType(Value_Type.BOOL);
  static const ValueType bytes = ValueType(Value_Type.BYTES);
  static const ValueType error = ValueType(Value_Type.ERROR);
  static const ValueType arg = ValueType(Value_Type.ARG);
  static const ValueType param = ValueType(Value_Type.PARAM);
  static const ValueType outPoint = ValueType(Value_Type.OUT_POINT);
  static const ValueType cellInput = ValueType(Value_Type.CELL_INPUT);
  static const ValueType cellDep = ValueType(Value_Type.CELL_DEP);
  static const ValueType script = ValueType(Value_Type.SCRIPT);
  static const ValueType cell = ValueType(Value_Type.CELL);
  static const ValueType transaction = ValueType(Value_Type.TRANSACTION);
  static const ValueType header = ValueType(Value_Type.HEADER);
  static const ValueType apply = ValueType(Value_Type.APPLY);
  static const ValueType reduce = ValueType(Value_Type.REDUCE);
  static const ValueType list = ValueType(Value_Type.LIST);
  static const ValueType queryCells = ValueType(Value_Type.QUERY_CELLS);
  static const ValueType map = ValueType(Value_Type.MAP);
  static const ValueType filter = ValueType(Value_Type.FILTER);
  static const ValueType getCapacity = ValueType(Value_Type.GET_CAPACITY);
  static const ValueType getData = ValueType(Value_Type.GET_DATA);
  static const ValueType getLock = ValueType(Value_Type.GET_LOCK);
  static const ValueType getType = ValueType(Value_Type.GET_TYPE);
  static const ValueType getDataHash = ValueType(Value_Type.GET_DATA_HASH);
  static const ValueType getOutPoint = ValueType(Value_Type.GET_OUT_POINT);
  static const ValueType getCodeHash = ValueType(Value_Type.GET_CODE_HASH);
  static const ValueType getHashType = ValueType(Value_Type.GET_HASH_TYPE);
  static const ValueType getArgs = ValueType(Value_Type.GET_ARGS);
  static const ValueType getCellDeps = ValueType(Value_Type.GET_CELL_DEPS);
  static const ValueType getHeaderDeps = ValueType(Value_Type.GET_HEADER_DEPS);
  static const ValueType getInputs = ValueType(Value_Type.GET_INPUTS);
  static const ValueType getOutputs = ValueType(Value_Type.GET_OUTPUTS);
  static const ValueType getWitnesses = ValueType(Value_Type.GET_WITNESSES);
  static const ValueType getCompactTarget = ValueType(Value_Type.GET_COMPACT_TARGET);
  static const ValueType getTimestamp = ValueType(Value_Type.GET_TIMESTAMP);
  static const ValueType getNumber = ValueType(Value_Type.GET_NUMBER);
  static const ValueType getEpoch = ValueType(Value_Type.GET_EPOCH);
  static const ValueType getParentHash = ValueType(Value_Type.GET_PARENT_HASH);
  static const ValueType getTransactionsRoot = ValueType(Value_Type.GET_TRANSACTIONS_ROOT);
  static const ValueType getProposalsHash = ValueType(Value_Type.GET_PROPOSALS_HASH);
  static const ValueType getUnclesHash = ValueType(Value_Type.GET_UNCLES_HASH);
  static const ValueType getDao = ValueType(Value_Type.GET_DAO);
  static const ValueType getNonce = ValueType(Value_Type.GET_NONCE);
  static const ValueType getHeader = ValueType(Value_Type.GET_HEADER);
  static const ValueType hash = ValueType(Value_Type.HASH);
  static const ValueType serializeToCore = ValueType(Value_Type.SERIALIZE_TO_CORE);
  static const ValueType serializeToJson = ValueType(Value_Type.SERIALIZE_TO_JSON);
  static const ValueType not = ValueType(Value_Type.NOT);
  static const ValueType and = ValueType(Value_Type.AND);
  static const ValueType or = ValueType(Value_Type.OR);
  static const ValueType equal = ValueType(Value_Type.EQUAL);
  static const ValueType less = ValueType(Value_Type.LESS);
  static const ValueType len = ValueType(Value_Type.LEN);
  static const ValueType slice = ValueType(Value_Type.SLICE);
  static const ValueType index = ValueType(Value_Type.INDEX);
  static const ValueType add = ValueType(Value_Type.ADD);
  static const ValueType subtract = ValueType(Value_Type.SUBTRACT);
  static const ValueType multiply = ValueType(Value_Type.MULTIPLY);
  static const ValueType divide = ValueType(Value_Type.DIVIDE);
  static const ValueType mod = ValueType(Value_Type.MOD);
  static const ValueType cond = ValueType(Value_Type.COND);
  static const ValueType tailRecursion = ValueType(Value_Type.TAIL_RECURSION);

  static List<ValueType> values = [
    prefabQueryCells,
    prefabMapCapacities,
    prefabGetBalance,
    nil,
    uint64,
    bool,
    bytes,
    error,
    arg,
    param,
    outPoint,
    cellInput,
    cellDep,
    script,
    cell,
    transaction,
    header,
    apply,
    reduce,
    list,
    queryCells,
    map,
    filter,
    getCapacity,
    getData,
    getLock,
    getType,
    getDataHash,
    getOutPoint,
    getCodeHash,
    getHashType,
    getArgs,
    getCellDeps,
    getHeaderDeps,
    getInputs,
    getOutputs,
    getWitnesses,
    getCompactTarget,
    getTimestamp,
    getNumber,
    getEpoch,
    getParentHash,
    getTransactionsRoot,
    getProposalsHash,
    getUnclesHash,
    getDao,
    getNonce,
    getHeader,
    hash,
    serializeToCore,
    serializeToJson,
    not,
    and,
    or,
    equal,
    less,
    len,
    slice,
    index,
    add,
    subtract,
    multiply,
    divide,
    mod,
    cond,
    tailRecursion,
  ];
}
