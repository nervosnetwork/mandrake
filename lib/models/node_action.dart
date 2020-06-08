import 'package:flutter/foundation.dart';

import 'document.dart';
import 'selection.dart';
import 'node.dart';

enum NodeAction {
  disconnectFromParent,
  disconnectAllChildren,
  delete,
  deleteWithDescendants,
  flatten,
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
      if (_canFlatten)
        NodeActionItem(
          value: NodeAction.flatten,
          label: 'Flatten',
        ),
      if (_canDisconnectParents)
        NodeActionItem(
          value: NodeAction.disconnectFromParent,
          label: 'Disconnect from parent(s)',
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
  bool get _canFlatten => node is PrefabNode;

  bool get _canDisconnectParents => document.parentsOf(node).isNotEmpty;

  bool get _canDisconnectAllChildren => node.children.isNotEmpty;

  bool get _canDeleteWithDecendants => node.children.isNotEmpty;
}

class NodeActionExecutor {
  NodeActionExecutor(this.document, this.selection);

  final Document document;
  final Selection selection;
  Node get node => selection.selectedNode(document.nodes);

  void execute(NodeAction action) {
    switch (action) {
      case NodeAction.flatten:
        final flattened = document.flattenPrefabNode(node);
        selection.select(flattened);
        break;
      case NodeAction.disconnectFromParent:
        document.disconnectNodeFromParent(node);
        break;
      case NodeAction.disconnectAllChildren:
        document.disconnectAllChildren(node);
        break;
      case NodeAction.delete:
        document.deleteNode(node);
        selection.select(null);
        break;
      case NodeAction.deleteWithDescendants:
        document.deleteNodeAndDescendants(node);
        selection.select(null);
        break;
    }
  }
}
