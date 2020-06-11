import 'dart:ui' show Offset;

import 'package:mandrake/models/nodes/op_node.dart';

import 'nodes/node_base.dart';
import 'nodes/root_node.dart';
import 'nodes/ast_node.dart';
import 'nodes/prefab_node.dart';
import 'nodes/primitive_node.dart';
import 'nodes/get_op_node.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';
export 'nodes/ast_node.dart';
export 'nodes/prefab_node.dart';
export 'nodes/op_node.dart';
export 'nodes/primitive_node.dart';
export 'nodes/get_op_node.dart';

class NodeCreator {
  static Node create(NodeTemplate template, Offset pos) {
    final valueType = template.valueType;

    if (valueType.isPrefab) {
      return PrefabNode(valueType: valueType, position: pos);
    }

    if (valueType.isOperation) {
      return OperationNode(valueType: valueType, position: pos);
    }

    if (valueType.isPrimitiveField) {
      return PrimitiveNode(valueType: valueType, position: pos);
    }

    if (valueType.isGetOperator) {
      return GetOpNode(valueType: valueType, position: pos);
    }

    final node = AstNode(valueType: valueType, position: pos);
    for (var i = 0; i < node.minimumSlotCount; i++) {
      node.addSlot('child ${i + 1}');
    }
    return node;
  }
}

class NodeDeserializer {
  static Node fromJson(Map<String, dynamic> json) {
    switch (json['node_type'] as String) {
      case 'RootNode':
        return RootNode.fromJson(json);
      case 'PrefabNode':
        return PrefabNode.fromJson(json);
      case 'OperationNode':
        return OperationNode.fromJson(json);
      case 'PrimitiveNode':
        return PrimitiveNode.fromJson(json);
      case 'GetOpNode':
        return GetOpNode.fromJson(json);
      case 'AstNode':
        return AstNode.fromJson(json);
    }
    assert(false, 'Fail to parse node JSON ${json["node_type"]}');
    return null;
  }
}
