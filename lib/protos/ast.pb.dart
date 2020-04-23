///
//  Generated code. Do not modify.
//  source: ast.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'ast.pbenum.dart';

export 'ast.pbenum.dart';

enum Value_Primitive {
  b, 
  u, 
  raw, 
  notSet
}

class Value extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Value_Primitive> _Value_PrimitiveByTag = {
    2 : Value_Primitive.b,
    3 : Value_Primitive.u,
    4 : Value_Primitive.raw,
    0 : Value_Primitive.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Value', package: const $pb.PackageName('ast'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..e<Value_Type>(1, 't', $pb.PbFieldType.OE, defaultOrMaker: Value_Type.NIL, valueOf: Value_Type.valueOf, enumValues: Value_Type.values)
    ..aOB(2, 'b')
    ..a<$fixnum.Int64>(3, 'u', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(4, 'raw', $pb.PbFieldType.OY)
    ..pc<Value>(8, 'children', $pb.PbFieldType.PM, subBuilder: Value.create)
    ..hasRequiredFields = false
  ;

  Value._() : super();
  factory Value() => create();
  factory Value.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Value.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Value clone() => Value()..mergeFromMessage(this);
  Value copyWith(void Function(Value) updates) => super.copyWith((message) => updates(message as Value));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Value create() => Value._();
  Value createEmptyInstance() => create();
  static $pb.PbList<Value> createRepeated() => $pb.PbList<Value>();
  @$core.pragma('dart2js:noInline')
  static Value getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Value>(create);
  static Value _defaultInstance;

  Value_Primitive whichPrimitive() => _Value_PrimitiveByTag[$_whichOneof(0)];
  void clearPrimitive() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Value_Type get t => $_getN(0);
  @$pb.TagNumber(1)
  set t(Value_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasT() => $_has(0);
  @$pb.TagNumber(1)
  void clearT() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get b => $_getBF(1);
  @$pb.TagNumber(2)
  set b($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasB() => $_has(1);
  @$pb.TagNumber(2)
  void clearB() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get u => $_getI64(2);
  @$pb.TagNumber(3)
  set u($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasU() => $_has(2);
  @$pb.TagNumber(3)
  void clearU() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get raw => $_getN(3);
  @$pb.TagNumber(4)
  set raw($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRaw() => $_has(3);
  @$pb.TagNumber(4)
  void clearRaw() => clearField(4);

  @$pb.TagNumber(8)
  $core.List<Value> get children => $_getList(4);
}

class Call extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Call', package: const $pb.PackageName('ast'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOM<Value>(3, 'result', subBuilder: Value.create)
    ..hasRequiredFields = false
  ;

  Call._() : super();
  factory Call() => create();
  factory Call.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Call.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Call clone() => Call()..mergeFromMessage(this);
  Call copyWith(void Function(Call) updates) => super.copyWith((message) => updates(message as Call));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Call create() => Call._();
  Call createEmptyInstance() => create();
  static $pb.PbList<Call> createRepeated() => $pb.PbList<Call>();
  @$core.pragma('dart2js:noInline')
  static Call getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call>(create);
  static Call _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(3)
  Value get result => $_getN(1);
  @$pb.TagNumber(3)
  set result(Value v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(3)
  void clearResult() => clearField(3);
  @$pb.TagNumber(3)
  Value ensureResult() => $_ensure(1);
}

class Stream extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Stream', package: const $pb.PackageName('ast'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOM<Value>(2, 'filter', subBuilder: Value.create)
    ..hasRequiredFields = false
  ;

  Stream._() : super();
  factory Stream() => create();
  factory Stream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Stream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Stream clone() => Stream()..mergeFromMessage(this);
  Stream copyWith(void Function(Stream) updates) => super.copyWith((message) => updates(message as Stream));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Stream create() => Stream._();
  Stream createEmptyInstance() => create();
  static $pb.PbList<Stream> createRepeated() => $pb.PbList<Stream>();
  @$core.pragma('dart2js:noInline')
  static Stream getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stream>(create);
  static Stream _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  Value get filter => $_getN(1);
  @$pb.TagNumber(2)
  set filter(Value v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilter() => clearField(2);
  @$pb.TagNumber(2)
  Value ensureFilter() => $_ensure(1);
}

class Root extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Root', package: const $pb.PackageName('ast'), createEmptyInstance: create)
    ..pc<Call>(1, 'calls', $pb.PbFieldType.PM, subBuilder: Call.create)
    ..pc<Stream>(2, 'streams', $pb.PbFieldType.PM, subBuilder: Stream.create)
    ..hasRequiredFields = false
  ;

  Root._() : super();
  factory Root() => create();
  factory Root.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Root.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Root clone() => Root()..mergeFromMessage(this);
  Root copyWith(void Function(Root) updates) => super.copyWith((message) => updates(message as Root));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Root create() => Root._();
  Root createEmptyInstance() => create();
  static $pb.PbList<Root> createRepeated() => $pb.PbList<Root>();
  @$core.pragma('dart2js:noInline')
  static Root getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Root>(create);
  static Root _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Call> get calls => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<Stream> get streams => $_getList(1);
}

