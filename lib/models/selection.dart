import 'package:flutter/foundation.dart';

import 'node.dart';

/// Selection handler that keeps track of selection and hovering of nodes.
class Selection extends ChangeNotifier {
  String _selectedNodeId;
  String _hoveredNodeId;

  bool isNodeSelected(Node node) => node != null && _selectedNodeId == node.id;
  Node selectedNode(List<Node> nodes) {
    return nodes.firstWhere((node) => isNodeSelected(node), orElse: () => null);
  }

  bool isNodeHovered(Node node) => node != null && _hoveredNodeId == node.id;
  Node hoveredNode(List<Node> nodes) {
    return nodes.firstWhere((node) => isNodeHovered(node), orElse: () => null);
  }

  void select(Node node) {
    if (_selectedNodeId != node?.id) {
      _selectedNodeId = node?.id;
      notifyListeners();
    }
  }

  void hover(Node node) {
    if (_hoveredNodeId != node?.id) {
      _hoveredNodeId = node?.id;
      notifyListeners();
    }
  }
}
