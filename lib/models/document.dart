import 'dart:collection';
import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

import 'node.dart';
import 'link.dart';

class Document extends ChangeNotifier {
  final List<Node> _topLevelNodes = []; // Reference to top level nodes only
  final List<Node> _allNodes = [];
  final List<Link> _links = [];

  UnmodifiableListView<Node> get nodes => UnmodifiableListView(_allNodes);
  UnmodifiableListView<Link> get links => UnmodifiableListView(_links);

  void addNode(Node node, {Node parent}) {
    if (parent != null) {
      assert(_allNodes.contains(parent));
      parent.addChild(node);
    } else {
      _topLevelNodes.add(node);
    }

    _rebuildNodes();
    _rebuildLinks();
    notifyListeners();
  }

  bool canConnect({@required Node parent, @required Node child}) {
    if (parent == null || child == null) {
      return false;
    }
    if (parent == child) {
      return false;
    }
    if (child.nodes.contains(parent)) {
      return false;
    }
    return _topLevelNodes.contains(child);
  }

  void connectNode({@required Node parent, @required Node child}) {
    assert(_allNodes.contains(parent));
    assert(_topLevelNodes.contains(child));

    _topLevelNodes.remove(child);
    parent.addChild(child);

    _rebuildNodes();
    _rebuildLinks();
    notifyListeners();
  }

  void moveNodePosition(Node node, Offset offset) {
    assert(nodes.contains(node));
    node.position += offset;
    notifyListeners();
  }

  void _rebuildNodes() {
    _allNodes.clear();
    for (final root in _topLevelNodes) {
      _allNodes.addAll(root.nodes);
    }
  }

  void _rebuildLinks() {
    _links.clear();
    for (final root in _topLevelNodes) {
      _links.addAll(Link.linksOf(root));
    }
  }
}
