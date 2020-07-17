import 'dart:ui' show Offset;

import 'ast_node.dart';

part 'op_node.g.dart';

@JsonSerializable()
class OperationNode extends AstNode {
  OperationNode({ValueType valueType, Offset position})
      : super(valueType: valueType, position: position) {
    _addSlots();
  }

  factory OperationNode.fromJson(Map<String, dynamic> json) => _$OperationNodeFromJson(json);
  @override
  Map<String, dynamic> toJson() => NodeSerializer.toTypedJson(this, _$OperationNodeToJson);

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
        renameSlot(slots[i].id, 'operand ${i + 1}');
      }
    }
  }

  void _addSlots() {
    final expectedSlots = _slotNameMap[valueType];
    if (expectedSlots != null) {
      for (final name in expectedSlots) {
        addSlot(name);
      }
    } else {
      for (var i = 0; i < valueType.minimumSlotCount; i++) {
        addSlot('operand ${i + 1}');
      }
    }
  }

  static final _slotNameMap = {
    ValueType.hash: ['hash'],
    ValueType.len: ['bytes'],
    ValueType.index: ['index', 'list'],
    ValueType.slice: ['start', 'end', 'bytes'],
    ValueType.cond: ['condition', 'expr1', 'expr1'],
  };
}
