import 'dart:ui' show Offset;

import 'ast_node.dart';

class OperationNode extends AstNode {
  OperationNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position) {
    _addSlots();
  }

  @override
  List<ValueType> get exchangeableValueTypes {
    final all = super.exchangeableValueTypes;
    return all.where((t) {
      return t.minimumSlotCount == valueType.minimumSlotCount &&
          t.maximumSlotCount == valueType.maximumSlotCount;
    }).toList();
  }

  @override
  void updateValueAfterTypeChange() {
    final expectedSlots = _slotNameMap[valueType];
    if (expectedSlots != null) {
      for (var i = 0; i < expectedSlots.length; i++) {
        renameSlot(slots[i].id, expectedSlots[i]);
      }
    } else {
      for (var i = 0; i < slots.length; i++) {
        renameSlot(slots[i].id, 'Operand ${i + 1}');
      }
    }
  }

  /// TODO: override canConnect to limit child types

  void _addSlots() {
    final expectedSlots = _slotNameMap[valueType];
    if (expectedSlots != null) {
      for (final name in expectedSlots) {
        addSlot(name);
      }
    } else {
      for (var i = 0; i < valueType.minimumSlotCount; i++) {
        addSlot('Operand ${i + 1}');
      }
    }
  }

  static final _slotNameMap = {
    ValueType.hash: ['Hash'],
    ValueType.len: ['Bytes'],
    ValueType.index: ['Index', 'List'],
    ValueType.slice: ['Start', 'End', 'Bytes'],
    ValueType.cond: ['Condition', 'Expr1', 'Expr1'],
  };
}
