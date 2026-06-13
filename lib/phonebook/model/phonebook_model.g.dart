// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phonebook_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescriptionPhonebookType _$DescriptionPhonebookTypeFromJson(
  Map<String, dynamic> json,
) => DescriptionPhonebookType(
  english: json['english'] as String,
  persian: json['persian'] as String,
  arabic: json['arabic'] as String,
  turkish: json['turkish'] as String,
  russian: json['russian'] as String,
  german: json['german'] as String,
);

Map<String, dynamic> _$DescriptionPhonebookTypeToJson(
  DescriptionPhonebookType instance,
) => <String, dynamic>{
  'english': instance.english,
  'persian': instance.persian,
  'arabic': instance.arabic,
  'turkish': instance.turkish,
  'russian': instance.russian,
  'german': instance.german,
};

PhonebookType _$PhonebookTypeFromJson(Map<String, dynamic> json) =>
    PhonebookType(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      description: DescriptionPhonebookType.fromJson(
        json['description'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PhonebookTypeToJson(PhonebookType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'description': instance.description,
    };
