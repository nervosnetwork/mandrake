import 'dart:ui' show Offset, Size;
import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:convert/convert.dart';
import 'package:string_validator/string_validator.dart';
import 'package:basic_utils/basic_utils.dart';

import 'ast_node.dart';

part 'primitive_node.g.dart';

@JsonSerializable()
class PrimitiveNode extends AstNode {
  PrimitiveNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position) {
    if (valueType == ValueType.nil) {
      _value = 'NIL';
    } else if (valueType == ValueType.bool) {
      _value = 'true';
    } else if (valueType == ValueType.bytes) {
      _value = '0x';
    } else if (valueType == ValueType.error) {
      _value = 'Error message';
    } else {
      _value = '0';
    }
  }

  factory PrimitiveNode.fromJson(Map<String, dynamic> json) => _$PrimitiveNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$PrimitiveNodeToJson);

  @override
  Value toAstValue() {
    final value = Value();
    value.t = valueType.rawType;

    if (valueType == ValueType.nil) {
    } else if (valueType == ValueType.bool) {
      value.b = _value == 'true';
    } else if (valueType == ValueType.bytes) {
      value.raw = hex.decode(_value.substring(2));
    } else if (valueType == ValueType.error) {
      value.raw = utf8.encode(_value);
    } else {
      value.u = Int64.parseInt(_value);
    }

    return value;
  }

  String _value = '';
  String get value => _value;
  set value(String v) {
    _value = normalize(v);
    notifyListeners();
  }

  double get bodyWidth {
    if (valueType == ValueType.bytes || valueType == ValueType.error) {
      return 250;
    }
    return 200;
  }

  double get bodyHeight {
    if (valueType == ValueType.bytes || valueType == ValueType.error) {
      return 110;
    }
    return 45;
  }

  @override
  Size get size {
    return Size(
      bodyWidth,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  bool get editableAsText {
    return [ValueType.bytes, ValueType.error, ValueType.uint64, ValueType.arg, ValueType.param]
        .contains(valueType);
  }

  int get allowedEditLines {
    if (valueType == ValueType.bytes || valueType == ValueType.error) {
      return 4;
    }
    return 1;
  }

  String normalize(String v) {
    var normalized = v.trim();

    if (valueType == ValueType.nil) {
      normalized = 'NIL';
    }

    if (valueType == ValueType.bool) {
      if (!['true', 'false'].contains(normalized)) {
        normalized = 'true';
      }
    }

    if (valueType == ValueType.uint64 ||
        valueType == ValueType.arg ||
        valueType == ValueType.param) {
      if (!StringUtils.isDigit(normalized)) {
        normalized = '0';
      }
    }

    if (valueType == ValueType.bytes) {
      if (normalized.substring(0, 1) != '0x' && !isHexadecimal(normalized.substring(2))) {
        normalized = '0x';
      }
    }

    return normalized;
  }

  @override
  void updateValueAfterTypeChange() {
    _value = normalize(_value);
  }
}
