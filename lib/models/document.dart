import 'package:flutter/material.dart';

import 'node.dart';

class Document extends ChangeNotifier {
  final List<Node> _nodes = [];

  List<Node> get nodes => _nodes;

  void addNode(Node node) {
    _nodes.add(node);
    notifyListeners();
  }

  void moveNodePosition(Node node, Offset offset) {
    node.position += offset;
    notifyListeners();
  }
}