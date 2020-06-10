// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeBase _$NodeBaseFromJson(Map<String, dynamic> json) {
  return NodeBase(
    json['name'] as String,
    OffsetJsonConverter.offsetFromJson(json['position'] as String),
    json['minimum_slot_count'] as int,
    json['maximum_slot_count'] as int,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$NodeBaseToJson(NodeBase instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'minimum_slot_count': instance.minimumSlotCount,
      'maximum_slot_count': instance.maximumSlotCount,
    };

Node _$NodeFromJson(Map<String, dynamic> json) {
  return Node(
    name: json['name'],
    position: OffsetJsonConverter.offsetFromJson(json['position'] as String),
    minimumSlotCount: json['minimum_slot_count'] as int,
    maximumSlotCount: json['maximum_slot_count'] as int,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
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
