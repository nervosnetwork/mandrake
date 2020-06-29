import 'package:json_annotation/json_annotation.dart';

part 'prefab_value.g.dart';

@JsonSerializable()
class PrefabValue {
  PrefabValue(this.name, this.value);
  String name;
  String value;

  factory PrefabValue.fromJson(Map<String, dynamic> json) => _$PrefabValueFromJson(json);
  Map<String, dynamic> toJson() => _$PrefabValueToJson(this);
}
