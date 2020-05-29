import 'dart:ui' show Offset, Size;
import 'package:string_validator/string_validator.dart';
import 'package:basic_utils/basic_utils.dart';

import '../../protos/ast.pb.dart' show Value_Type;
import 'ast_node.dart';

class PrimitiveNode extends AstNode {
  PrimitiveNode({Value_Type valueType, Offset position})
      : super(valueType: valueType, position: position) {
    if (valueType == Value_Type.NIL) {
      _value = 'NIL';
    } else if (valueType == Value_Type.BOOL) {
      _value = 'true';
    } else if (valueType == Value_Type.BYTES) {
      _value = '0x';
    } else if (valueType == Value_Type.ERROR) {
      _value = 'Error message';
    } else {
      _value = '0';
    }
  }

  String _value = '';

  double get bodyHeight {
    if (valueType == Value_Type.BYTES || valueType == Value_Type.ERROR) {
      return 110;
    }
    return 45;
  }

  @override
  Size get size {
    return Size(
      200,
      titleHeight + bodyHeight + bottomPadding,
    );
  }

  String get value => _value;
  bool get editableAsText {
    return [Value_Type.BYTES, Value_Type.ERROR, Value_Type.UINT64, Value_Type.ARG, Value_Type.PARAM]
        .contains(valueType);
  }

  int get allowedEditLines {
    if (valueType == Value_Type.BYTES || valueType == Value_Type.ERROR) {
      return 5;
    }
    return 1;
  }

  void setValue(String v) {
    _value = normalize(v);
    notifyListeners();
  }

  String normalize(String v) {
    var normalized = v.trim();

    if (valueType == Value_Type.UINT64 ||
        valueType == Value_Type.ARG ||
        valueType == Value_Type.PARAM) {
      if (!StringUtils.isDigit(normalized)) {
        normalized = '0';
      }
    }

    if (valueType == Value_Type.BYTES) {
      if (normalized.substring(0, 1) != '0x' && !isHexadecimal(normalized.substring(2))) {
        normalized = '0x';
      }
    }
    // TODO: other format validation

    return normalized;
  }
}
