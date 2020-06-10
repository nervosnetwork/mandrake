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
        json['position'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RootNodeToJson(RootNode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': OffsetJsonConverter.offsetToJson(instance.position),
    };
