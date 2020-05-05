import 'package:flutter/foundation.dart';

import 'node.dart';

class Selection extends ChangeNotifier {
  String _selectedNodeId;

  bool isNodeSelected(Node node) => _selectedNodeId == node.id;
  Node selectedNode(List<Node> nodes) {
    return nodes.firstWhere((node) => isNodeSelected(node), orElse: () => null);
  }

  void select(Node node) {
    _selectedNodeId = node?.id;
    notifyListeners();
  }
}
