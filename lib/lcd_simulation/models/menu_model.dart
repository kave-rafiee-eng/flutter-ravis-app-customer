import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu_model.g.dart';

// --------------------- Enum ---------------------

enum TypeMenuEnum {
  @JsonValue("UNDEFINDED")
  undefined,
  @JsonValue("SUBMENU")
  submenu,
  @JsonValue("SETTING_ON_PARAMETER")
  settingOnParameter,
  @JsonValue("SETTING_ON_SELECT")
  settingOnSelect,
  @JsonValue("SETTING_MULTY_SELECT")
  settingMultySelect,
  @JsonValue("SETTING_MULTY_GROUP")
  settingMultyGroup,
}

// --------------------- Models ---------------------

@JsonSerializable()
class DescriptionType {
  final String english;
  final String persian;
  final String arabic;
  final String turkish;
  final String russian;
  final String german;

  DescriptionType({
    required this.english,
    required this.persian,
    required this.arabic,
    required this.turkish,
    required this.russian,
    required this.german,
  });

  factory DescriptionType.fromJson(Map<String, dynamic> json) =>
      _$DescriptionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionTypeToJson(this);
}

@JsonSerializable()
class MiniDescriptionType {
  final String english;
  final String persian;

  MiniDescriptionType({required this.english, required this.persian});

  factory MiniDescriptionType.fromJson(Map<String, dynamic> json) =>
      _$MiniDescriptionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$MiniDescriptionTypeToJson(this);
}

@JsonSerializable()
class OptionType {
  final String value;
  final MiniDescriptionType description;

  OptionType({required this.value, required this.description});

  factory OptionType.fromJson(Map<String, dynamic> json) =>
      _$OptionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$OptionTypeToJson(this);
}

@JsonSerializable()
class SettingOneParameterType {
  final int address;
  final int addition;
  final String unit;
  final int factor;
  final int offset;
  final int minValue;
  final int maxValue;
  final String label;
  final DescriptionType description;
  final MiniDescriptionType additional_description_for_ai_assistant;

  SettingOneParameterType({
    required this.address,
    required this.addition,
    required this.unit,
    required this.factor,
    required this.offset,
    required this.minValue,
    required this.maxValue,
    required this.label,
    required this.description,
    required this.additional_description_for_ai_assistant,
  });

  factory SettingOneParameterType.fromJson(Map<String, dynamic> json) =>
      _$SettingOneParameterTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SettingOneParameterTypeToJson(this);
}

@JsonSerializable()
class SettingOneSelectType {
  final int address;
  final List<OptionType> options;
  final String label;
  final DescriptionType description;
  final MiniDescriptionType additional_description_for_ai_assistant;

  SettingOneSelectType({
    required this.address,
    required this.options,
    required this.label,
    required this.description,
    required this.additional_description_for_ai_assistant,
  });

  factory SettingOneSelectType.fromJson(Map<String, dynamic> json) =>
      _$SettingOneSelectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SettingOneSelectTypeToJson(this);
}

@JsonSerializable()
class SettingMultySelectType {
  final List<int> addresses;
  final List<OptionType> options;
  final List<OptionType> itemLabels;
  final DescriptionType description;
  final MiniDescriptionType additional_description_for_ai_assistant;

  SettingMultySelectType({
    required this.addresses,
    required this.options,
    required this.itemLabels,
    required this.description,
    required this.additional_description_for_ai_assistant,
  });

  factory SettingMultySelectType.fromJson(Map<String, dynamic> json) =>
      _$SettingMultySelectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SettingMultySelectTypeToJson(this);
}

@JsonSerializable()
class SettingMultyGroupType {
  final SettingOneParameterType? settingOneParameter;
  final SettingOneSelectType? settingOneSelect;

  SettingMultyGroupType({this.settingOneParameter, this.settingOneSelect});

  factory SettingMultyGroupType.fromJson(Map<String, dynamic> json) =>
      _$SettingMultyGroupTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SettingMultyGroupTypeToJson(this);
}

@JsonSerializable()
class MenuDataType {
  final SettingOneParameterType? settingOneParameter;
  final SettingOneSelectType? settingOneSelect;
  final SettingMultySelectType? settingMultySelect;
  final List<SettingMultyGroupType>? settingMultyGroup;

  MenuDataType({
    this.settingOneParameter,
    this.settingOneSelect,
    this.settingMultySelect,
    this.settingMultyGroup,
  });

  factory MenuDataType.fromJson(Map<String, dynamic> json) =>
      _$MenuDataTypeFromJson(json);

  Map<String, dynamic> toJson() => _$MenuDataTypeToJson(this);
}

@JsonSerializable()
class ParanetIdLableType {
  final String id;
  final String label;

  ParanetIdLableType({required this.id, required this.label});

  factory ParanetIdLableType.fromJson(Map<String, dynamic> json) =>
      _$ParanetIdLableTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ParanetIdLableTypeToJson(this);
}

@JsonSerializable()
class MenuType {
  final String id;
  final List<ParanetIdLableType> parentId;
  final String? lable;
  final TypeMenuEnum type;
  final MenuDataType data;
  final DescriptionType description;
  final MiniDescriptionType additional_description_for_ai_assistant;

  MenuType({
    required this.id,
    required this.parentId,
    this.lable,
    required this.type,
    required this.data,
    required this.description,
    required this.additional_description_for_ai_assistant,
  });

  factory MenuType.fromJson(Map<String, dynamic> json) =>
      _$MenuTypeFromJson(json);

  Map<String, dynamic> toJson() => _$MenuTypeToJson(this);
}
