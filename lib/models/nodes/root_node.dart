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

  /// Child slots binding to 'add call' and 'add stream' buttons to allow
  /// recognizing them as connectors and dragging connecting link from them.
  static final ChildSlot addCallChildSlot = ChildSlot();
  static final ChildSlot addStreamChildSlot = ChildSlot();

  double get _callsVerticalOffset => titleHeight + subtitleHeight;
  double get _streamsVerticalOffset =>
      _callsVerticalOffset + callSlots.length * slotRowHeight + actionRowHeight + subtitleHeight;

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

  /// Add a new slot for call node.
  ChildSlot addCallSlot([String name = 'unnamed call']) {
    final slot = addSlot(name);
    _callSlots.add(slot);
    notifyListeners();
    return slot;
  }

  /// Add a new slot for stream node.
  ChildSlot addStreamSlot([String name = 'unnamed stream']) {
    final slot = addSlot(name);
    _streamSlots.add(slot);
    notifyListeners();
    return slot;
  }

  @override
  void removeSlot(String slot_id) {
    _callSlots.removeWhere((s) => s.id == slot_id);
    _streamSlots.removeWhere((s) => s.id == slot_id);

    super.removeSlot(slot_id);
  }

  @override
  void addChild(Node child, [String slot_id]) {
    if (slot_id == addCallChildSlot.id) {
      super.addChild(child, addCallSlot().id);
    } else if (slot_id == addStreamChildSlot.id) {
      super.addChild(child, addStreamSlot().id);
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

    final streamSlot = _streamSlots.firstWhere((s) => s.child_id == child.id, orElse: () => null);
    if (streamSlot != null) {
      return slotConnectorPosition(streamSlot);
    }

    return super.childConnectorPosition(child);
  }

  @override
  Offset slotConnectorPosition(ChildSlot slot) {
    final callIndex = _callSlots.indexOf(slot);
    if (callIndex != -1) {
      return position +
          Offset(
            size.width - 12,
            _callsVerticalOffset + slotRowHeight * callIndex + slotRowHeight / 2,
          );
    }

    final streamIndex = _streamSlots.indexOf(slot);
    if (streamIndex != -1) {
      return position +
          Offset(
            size.width - 12,
            _streamsVerticalOffset + slotRowHeight * streamIndex + slotRowHeight / 2,
          );
    }

    if (slot == addCallChildSlot) {
      return position +
          Offset(
            size.width - 12,
            _callsVerticalOffset + slotRowHeight * _callSlots.length + slotRowHeight / 2,
          );
    }

    if (slot == addStreamChildSlot) {
      return position +
          Offset(
            size.width - 12,
            _streamsVerticalOffset + slotRowHeight * _streamSlots.length + slotRowHeight / 2,
          );
    }

    return null;
  }

  /// Return one of the followings if it exists but not is not connected to
  /// a child node yet:
  ///   * Call slot connector
  ///   * Add call button
  ///   * Stream slot connector
  ///   * Add stream button
  @override
  ChildSlot hitTest(Offset point) {
    final hitWidth = 25.0;

    for (var i = 0; i < _callSlots.length; i++) {
      if (_callSlots[i].isConnected) {
        // Already connected(filled), cannot link to another child.
        continue;
      }

      final rect = Rect.fromLTWH(
        size.width - hitWidth,
        _callsVerticalOffset + slotRowHeight * i,
        hitWidth,
        slotRowHeight,
      );
      if (rect.contains(point)) {
        return _callSlots[i];
      }
    }
    final addCallButtonRect = Rect.fromLTWH(
      size.width - hitWidth,
      _callsVerticalOffset + slotRowHeight * _callSlots.length,
      hitWidth,
      slotRowHeight,
    );
    if (addCallButtonRect.contains(point)) {
      return addCallChildSlot;
    }

    for (var i = 0; i < _streamSlots.length; i++) {
      if (_streamSlots[i].isConnected) {
        // Already connected(filled), cannot link to another child.
        continue;
      }

      final rect = Rect.fromLTWH(
        size.width - hitWidth,
        _streamsVerticalOffset + slotRowHeight * i,
        hitWidth,
        slotRowHeight,
      );
      if (rect.contains(point)) {
        return _streamSlots[i];
      }
    }
    final addStreamButtonRect = Rect.fromLTWH(
      size.width - hitWidth,
      _streamsVerticalOffset + slotRowHeight * _streamSlots.length,
      hitWidth,
      slotRowHeight,
    );
    if (addStreamButtonRect.contains(point)) {
      return addStreamChildSlot;
    }

    return null;
  }
}
