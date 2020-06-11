// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Node _$NodeFromJson(Map<String, dynamic> json) {
  return Node(
    name: json['name'] as String,
    position: OffsetJsonConverter.offsetFromJson(
        json['position'] as Map<String, dynamic>),
    minimumSlotCount: json['minimum_slot_count'] as int,
    maximumSlotCount: json['maximum_slot_count'] as int,
  )
    ..id = json['id'] as String
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Node.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..slots = (json['slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'children': instance.children,
      'slots': instance.slots,
      'minimum_slot_count': instance.minimumSlotCount,
      'maximum_slot_count': instance.maximumSlotCount,
    };

ChildSlot _$ChildSlotFromJson(Map<String, dynamic> json) {
  return ChildSlot(
    name: json['name'] as String,
    childId: json['child_id'] as String,
  );
}

Map<String, dynamic> _$ChildSlotToJson(ChildSlot instance) => <String, dynamic>{
      'name': instance.name,
      'child_id': instance.childId,
    };
