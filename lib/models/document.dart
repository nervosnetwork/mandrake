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

  Document() {
    final root = RootNode();
    final slot = root.addCallSlot();
    addNode(root);
    final callResult = AstNode(
      AstNodeKind.primitive,
      Value_Type.NIL,
      root.position + Offset(root.size.width + 100, -50),
    );
    addNode(callResult);
    callResult.updateName('Call Result');
    connectNode(parent: root, child: callResult, slot_id: slot.id);
  }

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
    if (child is RootNode) {
      return false;
    }
    return _allNodes.contains(parent) && _topLevelNodes.contains(child);
  }

  void connectNode({@required Node parent, @required Node child, String slot_id}) {
    assert(canConnect(parent: parent, child: child));

    _topLevelNodes.remove(child);
    parent.addChild(child, slot_id);

    _rebuildNodes();
    _rebuildLinks();
    notifyListeners();
  }

  void disconnectNode({@required Node parent, @required String child_id, String slot_id}) {
    final child = nodes.firstWhere((n) => n.id == child_id, orElse: () => null);
    _topLevelNodes.add(child);
    parent.removeChild(child_id);

    _rebuildNodes();
    _rebuildLinks();
    notifyListeners();
  }

  /// Move a node by offset.
  void moveNodePosition(Node node, Offset offset) {
    assert(nodes.contains(node));
    node.moveTo(node.position + offset);
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
