import 'package:flutter/foundation.dart';

import 'document.dart';
import 'node.dart';

/// Selection handler that keeps track of selection and hovering of nodes.
class Selection extends ChangeNotifier {
  final Document _doc;
  Selection(this._doc);

  String _selectedNodeId;
  String _hoveredNodeId;

  bool isNodeSelected(Node node) => node != null && _selectedNodeId == node.id;
  Node get selectedNode => _doc.findNode(_selectedNodeId);

  bool isNodeHovered(Node node) => node != null && _hoveredNodeId == node.id;
  Node get hoveredNode => _doc.findNode(_hoveredNodeId);

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
