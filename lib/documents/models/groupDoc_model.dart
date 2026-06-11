import 'package:json_annotation/json_annotation.dart';

part 'groupDoc_model.g.dart';

@JsonSerializable()
class DescriptionDocType {
  final String english;
  final String persian;
  final String arabic;
  final String turkish;
  final String russian;
  final String german;

  DescriptionDocType({
    required this.english,
    required this.persian,
    required this.arabic,
    required this.turkish,
    required this.russian,
    required this.german,
  });

  factory DescriptionDocType.fromJson(Map<String, dynamic> json) =>
      _$DescriptionDocTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionDocTypeToJson(this);
}

@JsonSerializable()
class PdfFileType {
  final DescriptionDocType name;
  final String fileName;

  PdfFileType({required this.name, required this.fileName});

  factory PdfFileType.fromJson(Map<String, dynamic> json) =>
      _$PdfFileTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PdfFileTypeToJson(this);
}

@JsonSerializable()
class GroupDocType {
  final String id;
  final List<PdfFileType> files;
  final DescriptionDocType category;

  GroupDocType({required this.id, required this.files, required this.category});

  factory GroupDocType.fromJson(Map<String, dynamic> json) =>
      _$GroupDocTypeFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDocTypeToJson(this);
}

/*
export type pdfFileType = {
  name: DescriptionType;
  fileName: string;
};
export type GroupDocType = {
  id: string;
  category: DescriptionType;
  files: pdfFileType[];
};
*/
