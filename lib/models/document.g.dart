// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
    topLevelNodes: (json['top_level_nodes'] as List)
        ?.map(
            (e) => e == null ? null : Node.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    allNodes: (json['all_nodes'] as List)
        ?.map(
            (e) => e == null ? null : Node.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..fileName = json['file_name'] as String;
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'top_level_nodes': instance.topLevelNodes,
      'all_nodes': instance.allNodes,
      'file_name': instance.fileName,
    };
