// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_op_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOpNode _$GetOpNodeFromJson(Map<String, dynamic> json) {
  return GetOpNode(
    valueType: json['value_type'] == null
        ? null
        : ValueType.fromJson(json['value_type'] as Map<String, dynamic>),
    position: OffsetJsonConverter.offsetFromJson(
        json['position'] as Map<String, dynamic>),
  )
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Node.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..slots = (json['slots'] as List)
        ?.map((e) =>
            e == null ? null : ChildSlot.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as String;
}

Map<String, dynamic> _$GetOpNodeToJson(GetOpNode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'children': instance.children,
      'slots': instance.slots,
      'value_type': instance.valueType,
      'type': instance.type,
    };
