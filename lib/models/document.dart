import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'node.dart';
import 'link.dart';
import 'dirty_tracker.dart';

part 'document.g.dart';

@JsonSerializable()
class Document with ChangeNotifier, DirtyTracker {
  final Map<String, Node> allNodes;

  UnmodifiableListView<Node> get nodes => UnmodifiableListView(allNodes.values);
  UnmodifiableListView<Link> get links => UnmodifiableListView(_links);
  RootNode get root => nodes.firstWhere((n) => n is RootNode);

  final List<Link> _links = [];

  String _fileName = '';
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

  bool get isDirty {
    if (dirty) {
      return true;
    }

    for (final node in nodes) {
      if (node.dirty) {
        return true;
      }
    }

    return false;
  }

  void markNotDirty() {
    markClean();

    for (var node in nodes) {
      node.markClean();
    }
  }

  Document({this.allNodes});

  factory Document.fromJson(Map<String, dynamic> json) {
    final doc = _$DocumentFromJson(json);
    for (final node in doc.allNodes.values) {
      node.doc = doc;
    }
    return doc;
  }
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  Node findNode(String nodeId) => allNodes[nodeId];

  void addNode(Node node) {
    node.doc = this;
    allNodes[node.id] = node;

    _nodesChanged();
  }

  void deleteNode(Node node) {
    disconnectNodeFromParent(node);
    disconnectAllChildren(node);

    allNodes.remove(node.id);

    _nodesChanged();
  }

  void deleteNodeAndDescendants(Node node) {
    disconnectNodeFromParent(node);

    final childNodeIds = Set<String>.from(node.nodes.map((n) => n.id));
    final otherNodeIds = Set<String>.from(allNodes.keys).difference(childNodeIds);
    final otherNodes = otherNodeIds.map((id) => findNode(id)).toList();

    final hasOutsideParent = (Node node) {
      return otherNodes.any((n) => n.childIds.contains(node.id));
    };

    void processChildren(List<Node> children) {
      for (final child in children) {
        if (child != null && !hasOutsideParent(child)) {
          processChildren(child.children);
          allNodes.remove(child.id);
        }
      }
    }

    processChildren(node.children);
    allNodes.remove(node.id);

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
    return allNodes[parent.id] != null;
  }

  List<Node> parentsOf(Node node) {
    return nodes.where((n) => n.children.contains(node)).toList();
  }

  void connectNode({@required Node parent, @required Node child, String slotId}) {
    assert(canConnect(parent: parent, child: child));

    parent.addChild(child, slotId);

    _nodesChanged();
  }

  void disconnectNode({@required Node parent, @required String childId, deleteSlot = false}) {
    final child = findNode(childId);
    if (deleteSlot) {
      final slotId = parent?.slotIdForChild(child);
      parent?.removeSlot(slotId);
    }
    parent?.removeChild(childId);

    _nodesChanged();
  }

  void disconnectNodeFromParent(Node node, {deleteSlot = false}) {
    for (final parent in parentsOf(node)) {
      disconnectNode(parent: parent, childId: node.id, deleteSlot: deleteSlot);
    }
  }

  void disconnectAllChildren(Node node) {
    final childIds = node.children.map((c) => c.id).toList();
    for (final childId in childIds) {
      disconnectNode(parent: node, childId: childId);
    }
  }

  List<AstNode> flattenPrefabNode(PrefabNode node) {
    final flattened = node.flatten();
    var first = flattened.first;
    if (flattened.length == 1) {
      first.name = node.name;
    }

    final parents = parentsOf(node);
    if (parents.isNotEmpty) {
      for (final parent in parents) {
        parent.replaceChild(node.id, first);
      }
    }

    for (final other in flattened.sublist(1)) {
      addNode(other);
    }

    allNodes.remove(node.id);

    _nodesChanged();

    return flattened;
  }

  void forceRedraw() {
    notifyListeners();
  }

  void rebuild() {
    _links.clear();
    for (final node in nodes) {
      for (final childId in node.childIds) {
        final child = findNode(childId);
        if (child != null) {
          _links.add(Link(parent: node, child: child));
        }
      }
    }
  }

  void _nodesChanged() {
    rebuild();
    markDirty();
    notifyListeners();
  }
}
