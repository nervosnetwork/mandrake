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
      titleHeight + subtitleHeight + actionRowHeight + slots.length * slotRowHeight + bottomPadding,
    );
  }

  final List<Node> _children = [];
  UnmodifiableListView<Node> get children => UnmodifiableListView(_children);

  final List<ChildSlot> _slots = [];
  UnmodifiableListView<ChildSlot> get slots => UnmodifiableListView(_slots);

  double get titleHeight => 30;
  double get subtitleHeight => 16;
  double get actionRowHeight => 24;
  double get slotRowHeight => 24;
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

  void addChild(Node child, [String slot_id]) {
    assert(canAddChild);
    if (_children.contains(child)) {
      return;
    }

    _children.add(child);
    _fillSlot(child, slot_id);
  }

  Offset childConnectorPosition(Node child) {
    /// TODO: query child connector start for proper vertical position.
    return position + Offset(size.width, 55);
  }

  Offset slotConnectorPosition(ChildSlot slot) {
    /// TODO: query slot connector start for proper vertical position.
    return position + Offset(size.width, 55);
  }

  ChildSlot addSlot(String name) {
    final slot = ChildSlot(name: name);
    _slots.add(slot);
    return slot;
  }

  /// Return a child slot if pointer is inside its add button area.
  ChildSlot hitTest(Offset position) => null; // TODO: default impl.

  void _fillSlot(Node child, String slot_id) {
    final slot = slots.firstWhere((s) => s.id == slot_id && !s.isConnected, orElse: () => null);
    if (slot != null) {
      slot.child_id = child.id;
    }
  }
}

/// A slot of a [Node] can either hold a reference to a child, or empty
/// before connecting to child.
class ChildSlot {
  ChildSlot({this.name = '', this.child_id});

  final String id = Uuid().v4();
  String name;
  String child_id;

  bool get isConnected => child_id != null;

  @override
  bool operator ==(dynamic other) {
    return other is ChildSlot && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
