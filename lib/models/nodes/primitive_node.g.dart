// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primitive_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimitiveNode _$PrimitiveNodeFromJson(Map<String, dynamic> json) {
  return PrimitiveNode(
    valueType: json['value_type'] == null
        ? null
        : ValueType.fromJson(json['value_type'] as Map<String, dynamic>),
    position: OffsetJsonConverter.offsetFromJson(
        json['position'] as Map<String, dynamic>),
  )
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..slots = (json['slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..value = json['value'] as String;
}

Map<String, dynamic> _$PrimitiveNodeToJson(PrimitiveNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'slots': instance.slots,
      'value_type': instance.valueType,
      'value': instance.value,
    };
