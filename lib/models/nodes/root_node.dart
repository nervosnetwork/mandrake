import 'dart:collection';
import 'dart:ui' show Offset, Size, Rect;

import 'node_base.dart';

/// AST Root.
class RootNode extends Node {
  RootNode() : super('Root Node', Offset(80, 200));

  final List<ChildSlot> _callSlots = [];
  final List<ChildSlot> _streamSlots = [];
  UnmodifiableListView<ChildSlot> get callSlots => UnmodifiableListView(_callSlots);
  UnmodifiableListView<ChildSlot> get streamSlots => UnmodifiableListView(_streamSlots);

  static final ChildSlot _addCallChildSlot = ChildSlot();

  @override
  Size get size {
    return Size(
      180,
      titleHeight +
          subtitleHeight * 2 +
          actionRowHeight * 2 +
          slots.length * slotRowHeight +
          bottomPadding,
    );
  }

  /// Add a new slot for call node and return slot id.
  String addCallSlot([String name = 'unnamed call']) {
    final slot = addSlot(name);
    _callSlots.add(slot);
    return slot.id;
  }

  @override
  void addChild(Node child, [String slot_id]) {
    if (slot_id == _addCallChildSlot.id) {
      super.addChild(child, addCallSlot());
    } else {
      super.addChild(child, slot_id);
    }
  }

  @override
  Offset childConnectorPosition(Node child) {
    final callSlot = _callSlots.firstWhere((s) => s.child_id == child.id, orElse: () => null);
    if (callSlot != null) {
      return slotConnectorPosition(callSlot);
    }

    return position + Offset(size.width, 55); // Should not happen.
  }

  @override
  Offset slotConnectorPosition(ChildSlot slot) {
    final callsVerticalOffset = titleHeight + subtitleHeight;

    if (slot == _addCallChildSlot) {
      return position + Offset(
        size.width - 10,
        callsVerticalOffset + slotRowHeight * _callSlots.length + slotRowHeight / 2,
      );
    }

    return position + Offset(
      size.width - 10,
      callsVerticalOffset + slotRowHeight * _callSlots.indexOf(slot) + slotRowHeight / 2,
    );
  }

  @override
  ChildSlot hitTest(Offset point) {
    final callsVerticalOffset = titleHeight + subtitleHeight;
    final hitWidth = 25.0;

    for (var i = 0; i < _callSlots.length; i++) {
      if (_callSlots[i].isConnected) {
        // Already connected(filled), cannot link to another child.
        continue;
      }

      final rect = Rect.fromLTWH(
        size.width - hitWidth,
        callsVerticalOffset + slotRowHeight * i,
        hitWidth,
        slotRowHeight,
      );
      if (rect.contains(point)) {
        return _callSlots[i];
      }
    }
    final addCallButtonRect = Rect.fromLTWH(
      size.width - hitWidth,
      callsVerticalOffset + slotRowHeight * _callSlots.length,
      hitWidth,
      slotRowHeight,
    );
    if (addCallButtonRect.contains(point)) {
      return _addCallChildSlot;
    }

    return null;
  }
}
