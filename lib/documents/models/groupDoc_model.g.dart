// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupDoc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DescriptionDocType _$DescriptionDocTypeFromJson(Map<String, dynamic> json) =>
    DescriptionDocType(
      english: json['english'] as String,
      persian: json['persian'] as String,
      arabic: json['arabic'] as String,
      turkish: json['turkish'] as String,
      russian: json['russian'] as String,
      german: json['german'] as String,
    );

Map<String, dynamic> _$DescriptionDocTypeToJson(DescriptionDocType instance) =>
    <String, dynamic>{
      'english': instance.english,
      'persian': instance.persian,
      'arabic': instance.arabic,
      'turkish': instance.turkish,
      'russian': instance.russian,
      'german': instance.german,
    };

PdfFileType _$PdfFileTypeFromJson(Map<String, dynamic> json) => PdfFileType(
  name: DescriptionDocType.fromJson(json['name'] as Map<String, dynamic>),
  fileName: json['fileName'] as String,
);

Map<String, dynamic> _$PdfFileTypeToJson(PdfFileType instance) =>
    <String, dynamic>{'name': instance.name, 'fileName': instance.fileName};

GroupDocType _$GroupDocTypeFromJson(Map<String, dynamic> json) => GroupDocType(
  id: json['id'] as String,
  files: (json['files'] as List<dynamic>)
      .map((e) => PdfFileType.fromJson(e as Map<String, dynamic>))
      .toList(),
  category: DescriptionDocType.fromJson(
    json['category'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GroupDocTypeToJson(GroupDocType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'files': instance.files,
      'category': instance.category,
    };
