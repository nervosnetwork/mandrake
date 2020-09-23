// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AstNode _$AstNodeFromJson(Map<String, dynamic> json) {
  return AstNode(
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
        ?.toList();
}

Map<String, dynamic> _$AstNodeToJson(AstNode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
      'slots': instance.slots,
      'value_type': instance.valueType,
    };
