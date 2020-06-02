import '../protos/ast.pbenum.dart' show Value_Type;

/// Encapsulate protos AST Value_Type class.
class ValueType {
  const ValueType._(this._rawType);
  final Value_Type _rawType;

  Value_Type get rawValueType => _rawType;

  @override
  String toString() => rawValueType.toString();

  static const ValueType nil = ValueType._(Value_Type.NIL);
  static const ValueType uint64 = ValueType._(Value_Type.UINT64);
  static const ValueType bool = ValueType._(Value_Type.BOOL);
  static const ValueType bytes = ValueType._(Value_Type.BYTES);
  static const ValueType error = ValueType._(Value_Type.ERROR);
  static const ValueType arg = ValueType._(Value_Type.ARG);
  static const ValueType param = ValueType._(Value_Type.PARAM);
  static const ValueType outPoint = ValueType._(Value_Type.OUT_POINT);
  static const ValueType cellInput = ValueType._(Value_Type.CELL_INPUT);
  static const ValueType cellDep = ValueType._(Value_Type.CELL_DEP);
  static const ValueType script = ValueType._(Value_Type.SCRIPT);
  static const ValueType cell = ValueType._(Value_Type.CELL);
  static const ValueType transaction = ValueType._(Value_Type.TRANSACTION);
  static const ValueType header = ValueType._(Value_Type.HEADER);
  static const ValueType apply = ValueType._(Value_Type.APPLY);
  static const ValueType reduce = ValueType._(Value_Type.REDUCE);
  static const ValueType list = ValueType._(Value_Type.LIST);
  static const ValueType queryCells = ValueType._(Value_Type.QUERY_CELLS);
  static const ValueType map = ValueType._(Value_Type.MAP);
  static const ValueType filter = ValueType._(Value_Type.FILTER);
  static const ValueType getCapacity = ValueType._(Value_Type.GET_CAPACITY);
  static const ValueType getData = ValueType._(Value_Type.GET_DATA);
  static const ValueType getLock = ValueType._(Value_Type.GET_LOCK);
  static const ValueType getType = ValueType._(Value_Type.GET_TYPE);
  static const ValueType getDataHash = ValueType._(Value_Type.GET_DATA_HASH);
  static const ValueType getOutPoint = ValueType._(Value_Type.GET_OUT_POINT);
  static const ValueType getCodeHash = ValueType._(Value_Type.GET_CODE_HASH);
  static const ValueType getHashType = ValueType._(Value_Type.GET_HASH_TYPE);
  static const ValueType getArgs = ValueType._(Value_Type.GET_ARGS);
  static const ValueType getCellDeps = ValueType._(Value_Type.GET_CELL_DEPS);
  static const ValueType getHeaderDeps = ValueType._(Value_Type.GET_HEADER_DEPS);
  static const ValueType getInputs = ValueType._(Value_Type.GET_INPUTS);
  static const ValueType getOutputs = ValueType._(Value_Type.GET_OUTPUTS);
  static const ValueType getWitnesses = ValueType._(Value_Type.GET_WITNESSES);
  static const ValueType getCompactTarget = ValueType._(Value_Type.GET_COMPACT_TARGET);
  static const ValueType getTimestamp = ValueType._(Value_Type.GET_TIMESTAMP);
  static const ValueType getNumber = ValueType._(Value_Type.GET_NUMBER);
  static const ValueType getEpoch = ValueType._(Value_Type.GET_EPOCH);
  static const ValueType getParentHash = ValueType._(Value_Type.GET_PARENT_HASH);
  static const ValueType getTransactionsRoot = ValueType._(Value_Type.GET_TRANSACTIONS_ROOT);
  static const ValueType getProposalsHash = ValueType._(Value_Type.GET_PROPOSALS_HASH);
  static const ValueType getUnclesHash = ValueType._(Value_Type.GET_UNCLES_HASH);
  static const ValueType getDao = ValueType._(Value_Type.GET_DAO);
  static const ValueType getNonce = ValueType._(Value_Type.GET_NONCE);
  static const ValueType getHeader = ValueType._(Value_Type.GET_HEADER);
  static const ValueType hash = ValueType._(Value_Type.HASH);
  static const ValueType serializeToCore = ValueType._(Value_Type.SERIALIZE_TO_CORE);
  static const ValueType serializeToJson = ValueType._(Value_Type.SERIALIZE_TO_JSON);
  static const ValueType not = ValueType._(Value_Type.NOT);
  static const ValueType and = ValueType._(Value_Type.AND);
  static const ValueType or = ValueType._(Value_Type.OR);
  static const ValueType equal = ValueType._(Value_Type.EQUAL);
  static const ValueType less = ValueType._(Value_Type.LESS);
  static const ValueType len = ValueType._(Value_Type.LEN);
  static const ValueType slice = ValueType._(Value_Type.SLICE);
  static const ValueType index = ValueType._(Value_Type.INDEX);
  static const ValueType add = ValueType._(Value_Type.ADD);
  static const ValueType subtract = ValueType._(Value_Type.SUBTRACT);
  static const ValueType multiply = ValueType._(Value_Type.MULTIPLY);
  static const ValueType divide = ValueType._(Value_Type.DIVIDE);
  static const ValueType mod = ValueType._(Value_Type.MOD);
  static const ValueType cond = ValueType._(Value_Type.COND);
  static const ValueType tailRecursion = ValueType._(Value_Type.TAIL_RECURSION);
}
