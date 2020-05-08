import 'dart:collection';
import 'dart:ui' show Offset, Size;

import 'node_base.dart';

/// AST Root.
class RootNode extends Node {
  RootNode() : super('Root Node', Offset(80, 200));

  final List<ChildSlot> _callSlots = [];
  final List<ChildSlot> _streamSlots = [];
  UnmodifiableListView<ChildSlot> get callSlots => UnmodifiableListView(_callSlots);
  UnmodifiableListView<ChildSlot> get streamSlots => UnmodifiableListView(_streamSlots);

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
  String addCallSlot(String name) {
    final slot = addSlot(name);
    _callSlots.add(slot);
    return slot.id;
  }
}
