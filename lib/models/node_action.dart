import 'package:flutter/foundation.dart';

import 'document.dart';
import 'node.dart';

enum NodeAction {
  delete,
  deleteWithDescendants,
  disconnectFromParent,
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
    // TODO:
    return [
      NodeActionItem(
        value: NodeAction.disconnectFromParent,
        label: 'Disconnect from parent',
      ),
      NodeActionItem(
        value: NodeAction.delete,
        label: 'Delete node',
        danger: true,
      ),
      NodeActionItem(
        value: NodeAction.deleteWithDescendants,
        label: 'Delete node and descendants',
        danger: true,
      ),
    ];
  }
}
