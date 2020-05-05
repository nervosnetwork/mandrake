import 'dart:collection';
import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

import 'node.dart';

class Document extends ChangeNotifier {
  final List<Node> _nodes = [];

  UnmodifiableListView<Node> get nodes => UnmodifiableListView(_nodes);

  void addNode(Node node) {
    _nodes.add(node);
    notifyListeners();
  }

  void moveNodePosition(Node node, Offset offset) {
    assert(nodes.contains(node));
    node.position += offset;
    notifyListeners();
  }
}