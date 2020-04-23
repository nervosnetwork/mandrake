///
//  Generated code. Do not modify.
//  source: generic.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'ast.pbjson.dart' as $0;

const GenericParams$json = const {
  '1': 'GenericParams',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'params', '3': 2, '4': 3, '5': 11, '6': '.ast.Value', '10': 'params'},
  ],
};

const GenericServiceBase$json = const {
  '1': 'GenericService',
  '2': const [
    const {'1': 'Call', '2': '.generic.GenericParams', '3': '.ast.Value', '4': const {}},
    const {'1': 'Stream', '2': '.generic.GenericParams', '3': '.ast.Value', '4': const {}, '6': true},
  ],
};

const GenericServiceBase$messageJson = const {
  '.generic.GenericParams': GenericParams$json,
  '.ast.Value': $0.Value$json,
};

