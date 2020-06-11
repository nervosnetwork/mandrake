import 'dart:ui' show Offset;

import 'package:mandrake/models/node.dart';

import '../protos/ast.pbenum.dart' show Value_Type;

class OffsetJsonConverter {
  static Offset offsetFromJson(Map<String, dynamic> json) {
    return Offset((json['dx'] as int).toDouble(), (json['dy'] as int).toDouble());
  }

  static Map<String, dynamic> offsetToJson(Offset offset) => {
        'dx': offset.dx.round(),
        'dy': offset.dy.round(),
      };
}

class Value_TypeJsonConverter implements JsonConverter<Value_Type, int> {
  const Value_TypeJsonConverter();

  @override
  Value_Type fromJson(int json) {
    if (json == null) {
      return null;
    }
    return Value_Type.valueOf(json);
  }

  @override
  int toJson(Value_Type object) {
    return object?.value;
  }
}
