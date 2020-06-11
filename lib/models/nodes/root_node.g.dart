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
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Node.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..slots = (json['slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..callSlots = (json['call_slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..streamSlots = (json['stream_slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$RootNodeToJson(RootNode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'children': instance.children,
      'slots': instance.slots,
      'call_slots': instance.callSlots,
      'stream_slots': instance.streamSlots,
    };
