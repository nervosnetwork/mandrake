// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValueType _$ValueTypeFromJson(Map<String, dynamic> json) {
  return ValueType(
    const Value_TypeJsonConverter().fromJson(json['raw_type'] as int),
    json['name'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$ValueTypeToJson(ValueType instance) => <String, dynamic>{
      'raw_type': const Value_TypeJsonConverter().toJson(instance.rawType),
      'name': instance.name,
      'description': instance.description,
    };
