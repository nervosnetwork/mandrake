import 'dart:collection';
import 'dart:ui' show Offset, Size, Rect;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../document.dart';
import '../offset_json_converter.dart';
import '../dirty_tracker.dart';
import '../node.dart' show NodeDeserializer, NodeSerializer;

export 'package:json_annotation/json_annotation.dart';
export '../offset_json_converter.dart';
export '../node.dart' show NodeSerializer;

part 'node_base.g.dart';

/// Base class for [Node], which describes an object representing part of
/// an AST tree, and its geometry information on a canvas.
@JsonSerializable()
class Node with ChangeNotifier, DirtyTracker {
  Node({
    String name = '',
    Offset position = Offset.zero,
    this.minimumSlotCount = 0,
    this.maximumSlotCount = 5,
  })  : _id = Uuid().v4(),
        _name = name,
        _position = position ?? Offset.zero;

  factory Node.fromJson(Map<String, dynamic> json) {
    if (json['node_type'] == 'Node') {
      return _$NodeFromJson(json);
    }
    return NodeDeserializer.fromTypedJson(json);
  }
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$NodeToJson);

  String _id;
  String _name;
  Offset _position;

  @JsonKey(ignore: true)
  Document doc; // Delegate child nodes query and other use

  String get id => _id;
  set id(String id) {
    _id = id;
    markDirty();
    notifyListeners();
  }

  String get name => _name;
  set name(String name) {
    _name = name;
    markDirty();
    notifyListeners();
  }

  @JsonKey(
    fromJson: OffsetJsonConverter.offsetFromJson,
    toJson: OffsetJsonConverter.offsetToJson,
  )
  Offset get position => _position;
  set position(Offset position) {
    _position = position;
    markDirty();
    notifyListeners();
  }

  Size get size {
    final height = titleHeight + subtitleHeight + slots.length * slotRowHeight + bottomPadding;
    return Size(
      140,
      canAddSlot ? height + actionRowHeight : height,
    );
  }

  List<Node> get children {
    final slotWithChild = slots.where((s) => s.childId != null);
    return slotWithChild.map((s) {
      return findChild(s.childId);
    }).toList();
  }

  final List<ChildSlot> _slots = [];
  List<ChildSlot> get slots => UnmodifiableListView(_slots);
  set slots(List<ChildSlot> value) {
    _slots.clear();
    _slots.addAll(value);
  }

  /// Number of child slots the node must keep. Subclass of a specified node
  /// should overide [minmimSlotCount] and/or [maximumSlotCount] to limit
  /// adding/removing children/slots operations. For example a node for `+`
  /// operator should have both values fixed to `2`.
  final int minimumSlotCount;
  final int maximumSlotCount;
  bool get canAddChild => children.length < maximumSlotCount;
  bool get canAddSlot => slots.length < maximumSlotCount;
  bool get canRemoveSlot => slots.length > minimumSlotCount;

  double get titleHeight => 30;
  double get subtitleHeight => 16;
  double get actionRowHeight => 24;
  double get slotRowHeight => 24;
  double get bottomPadding => 5;

  static const int maxAllowedSlotCount = 100; // Is this even big enough?

  /// Full list as this node plus its children.
  UnmodifiableListView<Node> get nodes {
    final descendants =
        children.map((e) => e.nodes).fold(<Node>[], (value, element) => value + element);
    return UnmodifiableListView([this] + descendants);
  }

  /// Assign a virtual slot to the add child button so that one can drag
  /// from the add child button to another node to connect.
  static final ChildSlot addChildSlot = ChildSlot();

  @override
  bool operator ==(dynamic other) => other is Node && other.id == id;

  @override
  int get hashCode => id.hashCode;

  ChildSlot addSlot(String name) {
    final slot = ChildSlot(name: name);
    _slots.add(slot);
    markDirty();
    notifyListeners();
    return slot;
  }

  void attachSlot(ChildSlot slot, int index) {
    _slots.insert(index, slot);
    markDirty();
    notifyListeners();
  }

  int indexOfSlot(ChildSlot slot) => _slots.indexOf(slot);
  ChildSlot findSlot(String slotId) => _slots.firstWhere((s) => s.id == slotId, orElse: () => null);

  /// Remove both the slot and the child if there's one connected.
  void removeSlot(String slotId) {
    final slot = slots.firstWhere((s) => s.id == slotId, orElse: () => null);
    if (slot != null) {
      _slots.remove(slot);

      markDirty();
      notifyListeners();
    }
  }

  String slotIdForChild(Node child) {
    final slot = slots.firstWhere((s) => s.childId == child.id);
    return slot?.id;
  }

  void _fillSlot(Node child, String slotId) {
    final slot = slots.firstWhere((s) => s.id == slotId && !s.isConnected, orElse: () => null);
    assert(slot != null);
    slot.childId = child.id;
  }

  void renameSlot(String slotId, String name) {
    final slot = slots.firstWhere((s) => s.id == slotId, orElse: () => null);
    assert(slot != null);
    slot.name = name;

    markDirty();
    notifyListeners();
  }

  /// Add a child. If slotId is provided fill the child to that slot.
  void addChild(Node child, [String slotId]) {
    assert(canAddChild);
    if (slotId == addChildSlot.id) {
      _fillSlot(child, addSlot('new child').id);
    } else if (slotId != null) {
      _fillSlot(child, slotId);
    }

    markDirty();
    notifyListeners();
  }

  /// Remove a child from this node. Not this merely deletes the connection
  /// between this node and its child. It would keep the slot.
  void removeChild(String childId) {
    if (childId == null) {
      return;
    }

    final slot = slots.firstWhere((s) => s.childId == childId, orElse: () => null);
    if (slot != null) {
      slot.childId = null;
    }

    markDirty();
    notifyListeners();
  }

  Node findChild(String childId) => doc?.findNode(childId);

  void replaceChild(String childId, Node newChild) {
    if (childId == null) {
      return;
    }

    final slot = slots.firstWhere((s) => s.childId == childId, orElse: () => null);
    if (slot != null) {
      slot.childId = newChild.id;
    }

    markDirty();
    notifyListeners();
  }

  Offset childConnectorPosition(Node child) {
    final callSlot = slots.firstWhere((s) => s.childId == child.id, orElse: () => null);
    if (callSlot != null) {
      return slotConnectorPosition(callSlot);
    }

    return position + Offset(size.width, 55); // Should not happen.
  }

  Offset slotConnectorPosition(ChildSlot slot) {
    final verticalOffset = titleHeight + subtitleHeight;

    if (slot == addChildSlot) {
      return position +
          Offset(
            size.width - 12,
            verticalOffset + slotRowHeight * slots.length + slotRowHeight / 2,
          );
    }

    final index = slots.indexOf(slot);
    if (index != -1) {
      return position +
          Offset(
            size.width - 12,
            verticalOffset + slotRowHeight * slots.indexOf(slot) + slotRowHeight / 2,
          );
    }

    return null;
  }

  /// Return a child slot if pointer is inside its add button area.
  /// Param point is local position of node within Offset(0, 0) and Size(size).
  ChildSlot hitTest(Offset point) {
    final verticalOffset = titleHeight + subtitleHeight;
    final hitWidth = 25.0;

    for (var i = 0; i < slots.length; i++) {
      if (slots[i].isConnected) {
        // Already connected(filled), cannot link to another child.
        continue;
      }

      final rect = Rect.fromLTWH(
        size.width - hitWidth,
        verticalOffset + slotRowHeight * i,
        hitWidth,
        slotRowHeight,
      );
      if (rect.contains(point)) {
        return slots[i];
      }
    }

    if (canAddSlot) {
      final addSlotButtonRect = Rect.fromLTWH(
        size.width - hitWidth,
        verticalOffset + slotRowHeight * slots.length,
        hitWidth,
        slotRowHeight,
      );
      if (addSlotButtonRect.contains(point)) {
        return addChildSlot;
      }
    }

    return null;
  }
}

/// A slot of a [Node] can either hold a reference to a child, or empty
/// before connecting to child.
@JsonSerializable()
class ChildSlot {
  ChildSlot({this.name = '', this.childId}) : id = Uuid().v4();

  factory ChildSlot.fromJson(Map<String, dynamic> json) => _$ChildSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ChildSlotToJson(this);

  String id;
  String name;
  String childId;

  bool get isConnected => childId != null;

  @override
  bool operator ==(dynamic other) => other is ChildSlot && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
