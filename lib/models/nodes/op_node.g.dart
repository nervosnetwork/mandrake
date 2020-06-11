// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationNode _$OperationNodeFromJson(Map<String, dynamic> json) {
  return OperationNode(
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
        ?.toList();
}

Map<String, dynamic> _$OperationNodeToJson(OperationNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'children': instance.children,
      'slots': instance.slots,
      'value_type': instance.valueType,
    };
