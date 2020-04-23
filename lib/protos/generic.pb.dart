///
//  Generated code. Do not modify.
//  source: generic.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'ast.pb.dart' as $0;

class GenericParams extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GenericParams', package: const $pb.PackageName('generic'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..pc<$0.Value>(2, 'params', $pb.PbFieldType.PM, subBuilder: $0.Value.create)
    ..hasRequiredFields = false
  ;

  GenericParams._() : super();
  factory GenericParams() => create();
  factory GenericParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenericParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GenericParams clone() => GenericParams()..mergeFromMessage(this);
  GenericParams copyWith(void Function(GenericParams) updates) => super.copyWith((message) => updates(message as GenericParams));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenericParams create() => GenericParams._();
  GenericParams createEmptyInstance() => create();
  static $pb.PbList<GenericParams> createRepeated() => $pb.PbList<GenericParams>();
  @$core.pragma('dart2js:noInline')
  static GenericParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenericParams>(create);
  static GenericParams _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$0.Value> get params => $_getList(1);
}

class GenericServiceApi {
  $pb.RpcClient _client;
  GenericServiceApi(this._client);

  $async.Future<$0.Value> call($pb.ClientContext ctx, GenericParams request) {
    var emptyResponse = $0.Value();
    return _client.invoke<$0.Value>(ctx, 'GenericService', 'Call', request, emptyResponse);
  }
  $async.Future<$0.Value> stream($pb.ClientContext ctx, GenericParams request) {
    var emptyResponse = $0.Value();
    return _client.invoke<$0.Value>(ctx, 'GenericService', 'Stream', request, emptyResponse);
  }
}

