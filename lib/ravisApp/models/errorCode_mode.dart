import 'package:json_annotation/json_annotation.dart';

part 'errorCode.g.dart';

/*
export enum ErrorOriginEnum {
  ONLY_ADVANCE = "ONLY_ADVANCE",
  ONLY_TERSE = "ONLY_TERSE",
  ADVANCE_TERSE = "ADVANCE_TERSE",
}
*/
enum ErrorOriginEnum {
  @JsonValue("ONLY_ADVANCE")
  ONLY_ADVANCE,
  @JsonValue("ONLY_TERSE")
  ONLY_TERSE,
  @JsonValue("ADVANCE_TERSE")
  ADVANCE_TERSE,
}

/*
export type errorCodeType = {
  code: string;
  origin: ErrorOriginEnum;
  name: string;
  description: DescriptionType | null;
  solution: DescriptionType | null;
  additional_description_for_ai_assistant: MiniDescriptionType | null;
};
*/
@JsonSerializable()
class ErrorCodeType {
  final String code;
  final ErrorOriginEnum origin;
  final String name;
  final TypeMenuEnum type;
  final DescriptionType description;
  final DescriptionType solution;
  final MiniDescriptionType additional_description_for_ai_assistant;

  ErrorCodeType({
    required this.code,
    required this.origin,
    required this.name,
    required this.type,
    required this.description,
    required this.solution,
    required this.additional_description_for_ai_assistant,

  });

  factory ErrorCodeType.fromJson(Map<String, dynamic> json) =>
      _$ErrorCodeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorCodeTypeToJson(this);
}