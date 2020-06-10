// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document()..fileName = json['file_name'] as String;
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'file_name': instance.fileName,
    };
