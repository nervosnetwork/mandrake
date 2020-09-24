// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
    allNodes: (json['all_nodes'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e == null ? null : Node.fromJson(e as Map<String, dynamic>)),
    ),
  )..fileName = json['file_name'] as String;
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'all_nodes': instance.allNodes,
      'file_name': instance.fileName,
    };
