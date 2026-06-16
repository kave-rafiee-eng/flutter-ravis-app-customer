// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescriptionType _$DescriptionTypeFromJson(Map<String, dynamic> json) =>
    DescriptionType(
      english: json['english'] as String,
      persian: json['persian'] as String,
      arabic: json['arabic'] as String,
      turkish: json['turkish'] as String,
      russian: json['russian'] as String,
      german: json['german'] as String,
    );

Map<String, dynamic> _$DescriptionTypeToJson(DescriptionType instance) =>
    <String, dynamic>{
      'english': instance.english,
      'persian': instance.persian,
      'arabic': instance.arabic,
      'turkish': instance.turkish,
      'russian': instance.russian,
      'german': instance.german,
    };

MiniDescriptionType _$MiniDescriptionTypeFromJson(Map<String, dynamic> json) =>
    MiniDescriptionType(
      english: json['english'] as String,
      persian: json['persian'] as String,
    );

Map<String, dynamic> _$MiniDescriptionTypeToJson(
  MiniDescriptionType instance,
) => <String, dynamic>{
  'english': instance.english,
  'persian': instance.persian,
};

OptionType _$OptionTypeFromJson(Map<String, dynamic> json) => OptionType(
  value: json['value'] as String,
  description: MiniDescriptionType.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OptionTypeToJson(OptionType instance) =>
    <String, dynamic>{
      'value': instance.value,
      'description': instance.description,
    };

SettingOneParameterType _$SettingOneParameterTypeFromJson(
  Map<String, dynamic> json,
) => SettingOneParameterType(
  address: (json['address'] as num).toInt(),
  addition: (json['addition'] as num).toInt(),
  unit: json['unit'] as String,
  factor: (json['factor'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  minValue: (json['minValue'] as num).toInt(),
  maxValue: (json['maxValue'] as num).toInt(),
  label: json['label'] as String,
  description: DescriptionType.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  additional_description_for_ai_assistant: MiniDescriptionType.fromJson(
    json['additional_description_for_ai_assistant'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SettingOneParameterTypeToJson(
  SettingOneParameterType instance,
) => <String, dynamic>{
  'address': instance.address,
  'addition': instance.addition,
  'unit': instance.unit,
  'factor': instance.factor,
  'offset': instance.offset,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'label': instance.label,
  'description': instance.description,
  'additional_description_for_ai_assistant':
      instance.additional_description_for_ai_assistant,
};

SettingOneSelectType _$SettingOneSelectTypeFromJson(
  Map<String, dynamic> json,
) => SettingOneSelectType(
  address: (json['address'] as num).toInt(),
  options: (json['options'] as List<dynamic>)
      .map((e) => OptionType.fromJson(e as Map<String, dynamic>))
      .toList(),
  label: json['label'] as String,
  description: DescriptionType.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  additional_description_for_ai_assistant: MiniDescriptionType.fromJson(
    json['additional_description_for_ai_assistant'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SettingOneSelectTypeToJson(
  SettingOneSelectType instance,
) => <String, dynamic>{
  'address': instance.address,
  'options': instance.options,
  'label': instance.label,
  'description': instance.description,
  'additional_description_for_ai_assistant':
      instance.additional_description_for_ai_assistant,
};

SettingMultySelectType _$SettingMultySelectTypeFromJson(
  Map<String, dynamic> json,
) => SettingMultySelectType(
  addresses: (json['addresses'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  options: (json['options'] as List<dynamic>)
      .map((e) => OptionType.fromJson(e as Map<String, dynamic>))
      .toList(),
  itemLabels: (json['itemLabels'] as List<dynamic>)
      .map((e) => OptionType.fromJson(e as Map<String, dynamic>))
      .toList(),
  description: DescriptionType.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  additional_description_for_ai_assistant: MiniDescriptionType.fromJson(
    json['additional_description_for_ai_assistant'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SettingMultySelectTypeToJson(
  SettingMultySelectType instance,
) => <String, dynamic>{
  'addresses': instance.addresses,
  'options': instance.options,
  'itemLabels': instance.itemLabels,
  'description': instance.description,
  'additional_description_for_ai_assistant':
      instance.additional_description_for_ai_assistant,
};

SettingMultyGroupType _$SettingMultyGroupTypeFromJson(
  Map<String, dynamic> json,
) => SettingMultyGroupType(
  settingOneParameter: json['settingOneParameter'] == null
      ? null
      : SettingOneParameterType.fromJson(
          json['settingOneParameter'] as Map<String, dynamic>,
        ),
  settingOneSelect: json['settingOneSelect'] == null
      ? null
      : SettingOneSelectType.fromJson(
          json['settingOneSelect'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SettingMultyGroupTypeToJson(
  SettingMultyGroupType instance,
) => <String, dynamic>{
  'settingOneParameter': instance.settingOneParameter,
  'settingOneSelect': instance.settingOneSelect,
};

MenuDataType _$MenuDataTypeFromJson(Map<String, dynamic> json) => MenuDataType(
  settingOneParameter: json['settingOneParameter'] == null
      ? null
      : SettingOneParameterType.fromJson(
          json['settingOneParameter'] as Map<String, dynamic>,
        ),
  settingOneSelect: json['settingOneSelect'] == null
      ? null
      : SettingOneSelectType.fromJson(
          json['settingOneSelect'] as Map<String, dynamic>,
        ),
  settingMultySelect: json['settingMultySelect'] == null
      ? null
      : SettingMultySelectType.fromJson(
          json['settingMultySelect'] as Map<String, dynamic>,
        ),
  settingMultyGroup: (json['settingMultyGroup'] as List<dynamic>?)
      ?.map((e) => SettingMultyGroupType.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MenuDataTypeToJson(MenuDataType instance) =>
    <String, dynamic>{
      'settingOneParameter': instance.settingOneParameter,
      'settingOneSelect': instance.settingOneSelect,
      'settingMultySelect': instance.settingMultySelect,
      'settingMultyGroup': instance.settingMultyGroup,
    };

ParanetIdLableType _$ParanetIdLableTypeFromJson(Map<String, dynamic> json) =>
    ParanetIdLableType(
      id: json['id'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$ParanetIdLableTypeToJson(ParanetIdLableType instance) =>
    <String, dynamic>{'id': instance.id, 'label': instance.label};

MenuType _$MenuTypeFromJson(Map<String, dynamic> json) => MenuType(
  id: json['id'] as String,
  parentId: (json['parentId'] as List<dynamic>)
      .map((e) => ParanetIdLableType.fromJson(e as Map<String, dynamic>))
      .toList(),
  lable: json['lable'] as String?,
  type: $enumDecode(_$TypeMenuEnumEnumMap, json['type']),
  data: MenuDataType.fromJson(json['data'] as Map<String, dynamic>),
  description: DescriptionType.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  additional_description_for_ai_assistant: MiniDescriptionType.fromJson(
    json['additional_description_for_ai_assistant'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$MenuTypeToJson(MenuType instance) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'lable': instance.lable,
  'type': _$TypeMenuEnumEnumMap[instance.type]!,
  'data': instance.data,
  'description': instance.description,
  'additional_description_for_ai_assistant':
      instance.additional_description_for_ai_assistant,
};

const _$TypeMenuEnumEnumMap = {
  TypeMenuEnum.undefined: 'UNDEFINDED',
  TypeMenuEnum.submenu: 'SUBMENU',
  TypeMenuEnum.settingOnParameter: 'SETTING_ON_PARAMETER',
  TypeMenuEnum.settingOnSelect: 'SETTING_ON_SELECT',
  TypeMenuEnum.settingMultySelect: 'SETTING_MULTY_SELECT',
  TypeMenuEnum.settingMultyGroup: 'SETTING_MULTY_GROUP',
};
