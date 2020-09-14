import 'dart:ui' show Offset, Size, Rect;

import 'node_base.dart';

part 'root_node.g.dart';

/// AST Root.
@JsonSerializable()
class RootNode extends Node {
  RootNode() : super(name: 'Root', position: Offset(80, 250), maximumSlotCount: 100);

  factory RootNode.fromJson(Map<String, dynamic> json) => _$RootNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$RootNodeToJson);

  List<String> callSlotIds = [];
  List<String> streamSlotIds = [];

  List<ChildSlot> get callSlots {
    return callSlotIds.map((id) {
      return findSlot(id);
    }).toList();
  }

  List<ChildSlot> get streamSlots {
    return streamSlotIds.map((id) {
      return findSlot(id);
    }).toList();
  }

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
  ChildSlot addCallSlot([String name = 'call']) {
    final slot = addSlot(name);
    callSlotIds.add(slot.id);
    notifyListeners();
    return slot;
  }

  /// Add a new slot for stream node.
  ChildSlot addStreamSlot([String name = 'stream']) {
    final slot = addSlot(name);
    streamSlotIds.add(slot.id);
    notifyListeners();
    return slot;
  }

  @override
  void removeSlot(String slotId) {
    callSlotIds.remove(slotId);
    streamSlotIds.remove(slotId);

    super.removeSlot(slotId);
  }

  void attachCallSlot(ChildSlot slot, int index) {
    callSlotIds.insert(index, slot.id);
    attachSlot(slot, 0);
  }

  @override
  int indexOfSlot(ChildSlot slot) {
    final index = callSlotIds.indexOf(slot.id);
    if (index != -1) {
      return index;
    }
    return streamSlotIds.indexOf(slot.id);
  }

  bool isCallSlot(ChildSlot slot) => callSlotIds.contains(slot.id);

  void attachStreamSlot(ChildSlot slot, int index) {
    streamSlotIds.insert(index, slot.id);
    attachSlot(slot, 0);
  }

  @override
  void addChild(Node child, [String slotId]) {
    if (slotId == addCallChildSlot.id) {
      super.addChild(child, addCallSlot().id);
    } else if (slotId == addStreamChildSlot.id) {
      super.addChild(child, addStreamSlot().id);
    } else {
      super.addChild(child, slotId);
    }
  }

  @override
  Offset childConnectorPosition(Node child) {
    final callSlot = callSlots.firstWhere((s) => s.childId == child.id, orElse: () => null);
    if (callSlot != null) {
      return slotConnectorPosition(callSlot);
    }

    final streamSlot = streamSlots.firstWhere((s) => s.childId == child.id, orElse: () => null);
    if (streamSlot != null) {
      return slotConnectorPosition(streamSlot);
    }

    return super.childConnectorPosition(child);
  }

  @override
  Offset slotConnectorPosition(ChildSlot slot) {
    final callIndex = callSlotIds.indexOf(slot.id);
    if (callIndex != -1) {
      return position +
          Offset(
            size.width - 12,
            _callsVerticalOffset + slotRowHeight * callIndex + slotRowHeight / 2,
          );
    }

    final streamIndex = streamSlotIds.indexOf(slot.id);
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
            _callsVerticalOffset + slotRowHeight * callSlotIds.length + slotRowHeight / 2,
          );
    }

    if (slot == addStreamChildSlot) {
      return position +
          Offset(
            size.width - 12,
            _streamsVerticalOffset + slotRowHeight * streamSlotIds.length + slotRowHeight / 2,
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

    for (var i = 0; i < callSlots.length; i++) {
      if (callSlots[i].isConnected) {
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
        return callSlots[i];
      }
    }
    final addCallButtonRect = Rect.fromLTWH(
      size.width - hitWidth,
      _callsVerticalOffset + slotRowHeight * callSlots.length,
      hitWidth,
      slotRowHeight,
    );
    if (addCallButtonRect.contains(point)) {
      return addCallChildSlot;
    }

    for (var i = 0; i < streamSlots.length; i++) {
      if (streamSlots[i].isConnected) {
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
        return streamSlots[i];
      }
    }
    final addStreamButtonRect = Rect.fromLTWH(
      size.width - hitWidth,
      _streamsVerticalOffset + slotRowHeight * streamSlots.length,
      hitWidth,
      slotRowHeight,
    );
    if (addStreamButtonRect.contains(point)) {
      return addStreamChildSlot;
    }

    return null;
  }
}
