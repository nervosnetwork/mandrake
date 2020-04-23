///
//  Generated code. Do not modify.
//  source: ast.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Value$json = const {
  '1': 'Value',
  '2': const [
    const {'1': 't', '3': 1, '4': 1, '5': 14, '6': '.ast.Value.Type', '10': 't'},
    const {'1': 'b', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'b'},
    const {'1': 'u', '3': 3, '4': 1, '5': 4, '9': 0, '10': 'u'},
    const {'1': 'raw', '3': 4, '4': 1, '5': 12, '9': 0, '10': 'raw'},
    const {'1': 'children', '3': 8, '4': 3, '5': 11, '6': '.ast.Value', '10': 'children'},
  ],
  '4': const [Value_Type$json],
  '8': const [
    const {'1': 'primitive'},
  ],
};

const Value_Type$json = const {
  '1': 'Type',
  '2': const [
    const {'1': 'NIL', '2': 0},
    const {'1': 'UINT64', '2': 1},
    const {'1': 'BOOL', '2': 2},
    const {'1': 'BYTES', '2': 3},
    const {'1': 'ERROR', '2': 4},
    const {'1': 'ARG', '2': 16},
    const {'1': 'PARAM', '2': 17},
    const {'1': 'OUT_POINT', '2': 18},
    const {'1': 'CELL_INPUT', '2': 19},
    const {'1': 'CELL_DEP', '2': 20},
    const {'1': 'SCRIPT', '2': 21},
    const {'1': 'CELL', '2': 22},
    const {'1': 'TRANSACTION', '2': 23},
    const {'1': 'HEADER', '2': 24},
    const {'1': 'APPLY', '2': 25},
    const {'1': 'REDUCE', '2': 26},
    const {'1': 'LIST', '2': 27},
    const {'1': 'QUERY_CELLS', '2': 28},
    const {'1': 'MAP', '2': 29},
    const {'1': 'FILTER', '2': 30},
    const {'1': 'GET_CAPACITY', '2': 48},
    const {'1': 'GET_DATA', '2': 49},
    const {'1': 'GET_LOCK', '2': 50},
    const {'1': 'GET_TYPE', '2': 51},
    const {'1': 'GET_DATA_HASH', '2': 52},
    const {'1': 'GET_OUT_POINT', '2': 53},
    const {'1': 'GET_CODE_HASH', '2': 54},
    const {'1': 'GET_HASH_TYPE', '2': 55},
    const {'1': 'GET_ARGS', '2': 56},
    const {'1': 'GET_CELL_DEPS', '2': 57},
    const {'1': 'GET_HEADER_DEPS', '2': 58},
    const {'1': 'GET_INPUTS', '2': 59},
    const {'1': 'GET_OUTPUTS', '2': 60},
    const {'1': 'GET_WITNESSES', '2': 61},
    const {'1': 'GET_COMPACT_TARGET', '2': 62},
    const {'1': 'GET_TIMESTAMP', '2': 63},
    const {'1': 'GET_NUMBER', '2': 64},
    const {'1': 'GET_EPOCH', '2': 65},
    const {'1': 'GET_PARENT_HASH', '2': 66},
    const {'1': 'GET_TRANSACTIONS_ROOT', '2': 67},
    const {'1': 'GET_PROPOSALS_HASH', '2': 68},
    const {'1': 'GET_UNCLES_HASH', '2': 69},
    const {'1': 'GET_DAO', '2': 70},
    const {'1': 'GET_NONCE', '2': 71},
    const {'1': 'GET_HEADER', '2': 72},
    const {'1': 'HASH', '2': 73},
    const {'1': 'SERIALIZE_TO_CORE', '2': 74},
    const {'1': 'SERIALIZE_TO_JSON', '2': 75},
    const {'1': 'NOT', '2': 76},
    const {'1': 'AND', '2': 77},
    const {'1': 'OR', '2': 78},
    const {'1': 'EQUAL', '2': 80},
    const {'1': 'LESS', '2': 81},
    const {'1': 'LEN', '2': 82},
    const {'1': 'SLICE', '2': 83},
    const {'1': 'INDEX', '2': 84},
    const {'1': 'ADD', '2': 85},
    const {'1': 'SUBTRACT', '2': 86},
    const {'1': 'MULTIPLY', '2': 87},
    const {'1': 'DIVIDE', '2': 88},
    const {'1': 'MOD', '2': 89},
    const {'1': 'COND', '2': 120},
    const {'1': 'TAIL_RECURSION', '2': 121},
  ],
};

const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'result', '3': 3, '4': 1, '5': 11, '6': '.ast.Value', '10': 'result'},
  ],
};

const Stream$json = const {
  '1': 'Stream',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'filter', '3': 2, '4': 1, '5': 11, '6': '.ast.Value', '10': 'filter'},
  ],
};

const Root$json = const {
  '1': 'Root',
  '2': const [
    const {'1': 'calls', '3': 1, '4': 3, '5': 11, '6': '.ast.Call', '10': 'calls'},
    const {'1': 'streams', '3': 2, '4': 3, '5': 11, '6': '.ast.Stream', '10': 'streams'},
  ],
};

