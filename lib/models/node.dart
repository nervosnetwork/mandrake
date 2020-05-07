import 'dart:collection';
import 'dart:ui' show Offset;
import 'package:uuid/uuid.dart';

class Node {
  final String id = Uuid().v4();
  final List<Node> _children = [];
  UnmodifiableListView<Node> get children => UnmodifiableListView(_children);

  Offset position;

  Node([this.position = Offset.zero]);

  /// Full list of this node plus its children.
  UnmodifiableListView<Node> get nodes {
    final descendants = _children.map((e) => e.nodes).fold(<Node>[], (value, element) => value + element);
    return UnmodifiableListView([this] + descendants);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final Node typedOther = other;
    return typedOther.id == id;
  }

  void addChild(Node child) {
    if (_children.contains(child)) {
      return;
    }

    _children.add(child);
  }
}
