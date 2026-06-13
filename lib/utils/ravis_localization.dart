import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/models/groupDoc_model.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/phonebook/model/phonebook_model.dart';

TextDirection textDirection(LanguageEnum language) {
  if (language == LanguageEnum.persian || language == LanguageEnum.arabic) {
    return TextDirection.rtl;
  }
  return TextDirection.ltr;
}

String localizedDescriptionDoc(
  LanguageEnum language,
  DescriptionDocType description,
) {
  switch (language) {
    case LanguageEnum.english:
      return description.english;
    case LanguageEnum.persian:
      return description.persian;
    case LanguageEnum.arabic:
      return description.arabic;
    case LanguageEnum.turkish:
      return description.turkish;
    case LanguageEnum.russian:
      return description.russian;
    case LanguageEnum.german:
      return description.german;
  }
}

String localizedDescriptionPhonebook(
  LanguageEnum language,
  DescriptionPhonebookType description,
) {
  switch (language) {
    case LanguageEnum.english:
      return description.english;
    case LanguageEnum.persian:
      return description.persian;
    case LanguageEnum.arabic:
      return description.arabic;
    case LanguageEnum.turkish:
      return description.turkish;
    case LanguageEnum.russian:
      return description.russian;
    case LanguageEnum.german:
      return description.german;
  }
}

String localizedPageText(
  LanguageEnum language,
  Map<String, Map<LanguageEnum, String>> texts,
  String key,
) {
  return texts[key]![language] ?? texts[key]![LanguageEnum.english]!;
}

String bilingualText(String persian, String english, LanguageEnum language) {
  if (language == LanguageEnum.persian) {
    return persian;
  }
  return english;
}
