// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RootNode _$RootNodeFromJson(Map<String, dynamic> json) {
  return RootNode()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..position = OffsetJsonConverter.offsetFromJson(
        json['position'] as Map<String, dynamic>)
    ..slots = (json['slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..callSlotIds =
        (json['call_slot_ids'] as List)?.map((e) => e as String)?.toList()
    ..streamSlotIds =
        (json['stream_slot_ids'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$RootNodeToJson(RootNode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'slots': instance.slots,
      'call_slot_ids': instance.callSlotIds,
      'stream_slot_ids': instance.streamSlotIds,
    };
