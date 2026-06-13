import 'package:json_annotation/json_annotation.dart';

part 'phonebook_model.g.dart';

@JsonSerializable()
class DescriptionPhonebookType {
  final String english;
  final String persian;
  final String arabic;
  final String turkish;
  final String russian;
  final String german;

  DescriptionPhonebookType({
    required this.english,
    required this.persian,
    required this.arabic,
    required this.turkish,
    required this.russian,
    required this.german,
  });

  factory DescriptionPhonebookType.fromJson(Map<String, dynamic> json) =>
      _$DescriptionPhonebookTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionPhonebookTypeToJson(this);
}

@JsonSerializable()
class PhonebookType {
  final String id;
  final String name;
  final String phone;
  final DescriptionPhonebookType description;

  PhonebookType({
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
  });

  factory PhonebookType.fromJson(Map<String, dynamic> json) =>
      _$PhonebookTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PhonebookTypeToJson(this);
}
