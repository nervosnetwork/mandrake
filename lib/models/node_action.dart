import 'package:flutter/foundation.dart';

import 'document.dart';
import 'node.dart';

enum NodeAction {
  disconnectFromParent,
  disconnectAllChildren,
  delete,
  deleteWithDescendants,
}

class NodeActionItem {
  NodeActionItem({@required this.value, @required this.label, this.danger = false});

  final NodeAction value;
  final String label;
  final bool danger;
}

class NodeActionBuilder {
  NodeActionBuilder(this.document, this.node);

  final Document document;
  final Node node;

  List<NodeActionItem> build() {
    if (node is AstNode) {
      return _buildAstNodeNode();
    }

    if (node is RootNode) {
      return _buildRootNode();
    }

    return [];
  }

  List<NodeActionItem> _buildAstNodeNode() {
    return [
      if (_canDisconnectParent)
        NodeActionItem(
          value: NodeAction.disconnectFromParent,
          label: 'Disconnect from parent',
        ),
      if (_canDisconnectAllChildren)
        NodeActionItem(
          value: NodeAction.disconnectAllChildren,
          label: 'Disconnect all children',
        ),
      NodeActionItem(
        value: NodeAction.delete,
        label: 'Delete node',
        danger: true,
      ),
      if (_canDeleteWithDecendants)
        NodeActionItem(
          value: NodeAction.deleteWithDescendants,
          label: 'Delete node and descendants',
          danger: true,
        ),
    ];
  }

  List<NodeActionItem> _buildRootNode() {
    return [
      if (_canDisconnectAllChildren)
        NodeActionItem(
          value: NodeAction.disconnectAllChildren,
          label: 'Disconnect all children',
        ),
    ];
  }
}

extension on NodeActionBuilder {
  bool get _canDisconnectParent => document.parentOf(node) != null;

  bool get _canDisconnectAllChildren => node.children.isNotEmpty;

  bool get _canDeleteWithDecendants => node.children.isNotEmpty;
}

class NodeActionExecutor {
  NodeActionExecutor(this.document, this.node);

  final Document document;
  final Node node;

  void execute(NodeAction action) {
    switch (action) {
      case NodeAction.disconnectFromParent:
        document.disconnectNodeFromParent(node);
        break;
      case NodeAction.disconnectAllChildren:
        document.disconnectAllChildren(node);
        break;
      case NodeAction.delete:
        document.deleteNode(node);
        break;
      case NodeAction.deleteWithDescendants:
        document.deleteNodeAndDescendants(node);
        break;
    }
  }
}
