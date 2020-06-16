import 'dart:ui' show Offset;

import 'ast_node.dart';

part 'get_op_node.g.dart';

@JsonSerializable()
class GetOpNode extends AstNode {
  GetOpNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position) {
    addSlot(_getType(valueType));
  }

  factory GetOpNode.fromJson(Map<String, dynamic> json) => _$GetOpNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$GetOpNodeToJson);

  String type;

  String _getType(ValueType valueType) {
    if (valueType.isCellGetOp) {
      return 'cell';
    }
    if (valueType.isScriptGetOp) {
      return 'script';
    }
    if (valueType.isTxGetOp) {
      return 'transaction';
    }
    if (valueType.isHeaderGetOp) {
      return 'header';
    }

    return '';
  }
}
