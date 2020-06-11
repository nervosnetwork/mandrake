import 'dart:collection';
import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'node.dart';
import 'link.dart';

part 'document.g.dart';

@JsonSerializable()
class Document with ChangeNotifier {
  final List<Node> topLevelNodes; // Reference to top level nodes only
  final List<Node> _allNodes = [];
  final List<Link> _links = [];

  String _fileName = '';

  UnmodifiableListView<Node> get nodes => UnmodifiableListView(_allNodes);
  UnmodifiableListView<Link> get links => UnmodifiableListView(_links);

  String get fileName {
    var name = 'Untitled';
    if (_fileName.isNotEmpty) {
      name = _fileName;
    } else if (root.name.isNotEmpty) {
      name = root.name;
    }

    if (name.endsWith(fileExtension)) {
      return name;
    }
    return '$name$fileExtension';
  }

  set fileName(String name) {
    _fileName = name;
    if (!_fileName.endsWith(fileExtension)) {
      _fileName += fileExtension;
    }
  }

  String get fileExtension => '.json';

  RootNode get root => _allNodes.firstWhere((n) => n is RootNode);

  Document({this.topLevelNodes});

  factory Document.template() {
    final doc = Document(topLevelNodes: []);
    final root = RootNode();
    final callResult = NodeCreator.create(
      NodeTemplate(ValueType.uint64),
      root.position + Offset(root.size.width + 100, -50),
    );
    callResult.name = 'Call Result';
    root.addChild(callResult, root.addCallSlot('call result').id);
    doc.addNode(root);

    return doc;
  }

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  void addNode(Node node, {Node parent}) {
    if (parent != null) {
      assert(_allNodes.contains(parent));
      parent.addChild(node);
    } else {
      topLevelNodes.add(node);
    }

    _nodesChanged();
  }

  bool canConnect({@required Node parent, @required Node child}) {
    if (parent == null || child == null) {
      return false;
    }
    if (parent == child) {
      return false;
    }
    if (parent.children.contains(child)) {
      return false;
    }
    if (child.nodes.contains(parent)) {
      return false;
    }
    if (child is RootNode) {
      return false;
    }
    return _allNodes.contains(parent); // && _topLevelNodes.contains(child);
  }

  List<Node> parentsOf(Node node) {
    return _allNodes.where((n) => n.children.contains(node)).toList();
  }

  void connectNode({@required Node parent, @required Node child, String slotId}) {
    assert(canConnect(parent: parent, child: child));

    topLevelNodes.remove(child);
    parent.addChild(child, slotId);

    _nodesChanged();
  }

  void disconnectNode({@required Node parent, @required String childId}) {
    final child = _allNodes.firstWhere((n) => n.id == childId, orElse: () => null);
    if (parentsOf(child).length == 1) {
      topLevelNodes.add(child);
    }
    parent?.removeChild(childId);

    _nodesChanged();
  }

  void disconnectNodeFromParent(Node node) {
    for (final parent in parentsOf(node)) {
      disconnectNode(parent: parent, childId: node.id);
    }
  }

  void disconnectAllChildren(Node node) {
    final childIds = node.children.map((c) => c.id).toList();
    for (final childId in childIds) {
      disconnectNode(parent: node, childId: childId);
    }
  }

  void deleteNode(Node node) {
    disconnectNodeFromParent(node);
    disconnectAllChildren(node);

    topLevelNodes.removeWhere((n) => n == node);

    _nodesChanged();
  }

  void deleteNodeAndDescendants(Node node) {
    disconnectNodeFromParent(node);
    for (final n in node.nodes) {
      topLevelNodes.removeWhere((e) => e == n);
    }

    _nodesChanged();
  }

  AstNode flattenPrefabNode(PrefabNode node) {
    var flattened = node.flatten();
    flattened.name = node.name;

    final parents = parentsOf(node);
    if (parents.isNotEmpty) {
      for (final parent in parents) {
        parent.replaceChild(node.id, flattened);
      }
    } else {
      final index = topLevelNodes.indexOf(node);
      topLevelNodes[index] = flattened;
    }

    _nodesChanged();

    return flattened;
  }

  /// Move a node by offset.
  void moveNodePosition(Node node, Offset offset) {
    assert(nodes.contains(node));
    node.position = node.position + offset;
    notifyListeners();
  }

  void rebuild() {
    _rebuildNodes();
    _rebuildLinks();
  }

  void _nodesChanged() {
    rebuild();
    notifyListeners();
  }

  void _rebuildNodes() {
    _allNodes.clear();
    for (final root in topLevelNodes) {
      for (final child in root.nodes) {
        if (!_allNodes.contains(child)) {
          _allNodes.add(child);
        }
      }
    }
  }

  void _rebuildLinks() {
    _links.clear();
    for (final root in topLevelNodes) {
      _links.addAll(Link.linksOf(root));
    }
  }
}
