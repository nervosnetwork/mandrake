import 'package:flutter/foundation.dart';

import 'node.dart';

class Selection extends ChangeNotifier {
  String _selectedNodeId;

  bool isNodeSelected(Node node) => node != null && _selectedNodeId == node.id;
  Node selectedNode(List<Node> nodes) {
    return nodes.firstWhere((node) => isNodeSelected(node), orElse: () => null);
  }

  void select(Node node) {
    if (_selectedNodeId != node?.id) {
      _selectedNodeId = node?.id;
      notifyListeners();
    }
  }
}
