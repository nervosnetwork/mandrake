import 'package:flutter/foundation.dart';

import 'document.dart';
import 'selection.dart';
import 'node.dart';
import 'command.dart';

enum NodeAction {
  disconnectFromParent,
  disconnectAllChildren,
  delete,
  deleteWithDescendants,
  flatten,
  autoLayout,
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
      NodeActionItem(
        value: NodeAction.autoLayout,
        label: 'Auto layout',
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
  Node get node => selection.selectedNode;

  void execute(NodeAction action) {
    switch (action) {
      case NodeAction.flatten:
        Command.flatten(document, selection, node).run();
        break;
      case NodeAction.disconnectFromParent:
        Command.disconnectParent(document, node).run();
        break;
      case NodeAction.disconnectAllChildren:
        Command.disconnectChildren(document, node).run();
        break;
      case NodeAction.delete:
        Command.deleteNode(document, selection, node).run();
        break;
      case NodeAction.deleteWithDescendants:
        Command.deleteNodeAndDescendants(document, selection, node).run();
        break;
      case NodeAction.autoLayout:
        Command.autoLayout(document, node).run();
        break;
    }
  }
}
