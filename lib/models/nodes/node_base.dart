import 'dart:collection';
import 'dart:ui' show Offset, Size;
import 'package:uuid/uuid.dart';

/// Base class for [Node], which describes an object representing part of
/// an AST tree, and its geometry information on a canvas.
abstract class NodeBase {
  NodeBase(this.name, this.position) : assert(position != null);

  final String id = Uuid().v4();
  String name;
  Offset position;

  Size get size {
    return Size(
      120,
      titleHeight +
          subtitleHeight +
          actionRowHeight +
          children.length * childRowHeight +
          bottomPadding,
    );
  }

  final List<Node> _children = [];
  UnmodifiableListView<Node> get children => UnmodifiableListView(_children);

  double get titleHeight => 30;
  double get subtitleHeight => 16;
  double get actionRowHeight => 24;
  double get childRowHeight => 24;
  double get bottomPadding => 5;

  @override
  bool operator ==(dynamic other) {
    return other is NodeBase && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Node extends NodeBase {
  Node([name = 'Node', position = Offset.zero]) : super(name, position);

  /// Full list as this node plus its children.
  UnmodifiableListView<Node> get nodes {
    final descendants =
        _children.map((e) => e.nodes).fold(<Node>[], (value, element) => value + element);
    return UnmodifiableListView([this] + descendants);
  }

  bool get canAddChild => true;

  void addChild(Node child) {
    assert(canAddChild);
    if (_children.contains(child)) {
      return;
    }

    _children.add(child);
  }
}
