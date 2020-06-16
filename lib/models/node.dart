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

class _NodeType {
  static const String rootNode = 'RootNode';
  static const String prefabNode = 'PrefabNode';
  static const String operationNode = 'OperationNode';
  static const String primitiveNode = 'PrimitiveNode';
  static const String getOpNode = 'GetOpNode';
  static const String astNode = 'AstNode';
  static const String node = 'Node';

  static String nodeType(Node node) {
    switch (node.runtimeType) {
      case RootNode:
        return rootNode;
      case PrefabNode:
        return prefabNode;
      case OperationNode:
        return operationNode;
      case PrimitiveNode:
        return primitiveNode;
      case GetOpNode:
        return getOpNode;
      case AstNode:
        return astNode;
      default:
        return _NodeType.node;
    }
  }
}

typedef JsonToNode<T> = T Function(Map<String, dynamic> json);
typedef NodeToJson<T> = Map<String, dynamic> Function(T node);

class NodeDeserializer {
  static Node fromTypedJson(Map<String, dynamic> json) {
    switch (json['node_type'] as String) {
      case _NodeType.rootNode:
        return RootNode.fromJson(json);
      case _NodeType.prefabNode:
        return PrefabNode.fromJson(json);
      case _NodeType.operationNode:
        return OperationNode.fromJson(json);
      case _NodeType.primitiveNode:
        return PrimitiveNode.fromJson(json);
      case _NodeType.getOpNode:
        return GetOpNode.fromJson(json);
      case _NodeType.astNode:
        return AstNode.fromJson(json);
    }
    assert(false, 'Fail to parse node JSON node_type: ${json["node_type"]}');
    return null;
  }
}

class NodeSerializer {
  static Map<String, dynamic> toTypedJson<T>(T node, NodeToJson<T> toJson) {
    final json = toJson(node);
    json['node_type'] = _NodeType.nodeType(node as Node);
    return json;
  }
}
