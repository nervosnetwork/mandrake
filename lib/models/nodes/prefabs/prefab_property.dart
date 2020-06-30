import 'package:json_annotation/json_annotation.dart';

part 'prefab_property.g.dart';

@JsonSerializable()
class PrefabProperty {
  PrefabProperty(this.name, this.value);
  String name;
  String value;

  factory PrefabProperty.fromJson(Map<String, dynamic> json) => _$PrefabPropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PrefabPropertyToJson(this);
}
