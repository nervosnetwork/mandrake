///
//  Generated code. Do not modify.
//  source: generic.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'generic.pb.dart' as $1;
import 'ast.pb.dart' as $0;
import 'generic.pbjson.dart';

export 'generic.pb.dart';

abstract class GenericServiceBase extends $pb.GeneratedService {
  $async.Future<$0.Value> call($pb.ServerContext ctx, $1.GenericParams request);
  $async.Future<$0.Value> stream($pb.ServerContext ctx, $1.GenericParams request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Call': return $1.GenericParams();
      case 'Stream': return $1.GenericParams();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Call': return this.call(ctx, request);
      case 'Stream': return this.stream(ctx, request);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => GenericServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => GenericServiceBase$messageJson;
}

