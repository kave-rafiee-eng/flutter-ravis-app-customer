import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

String extranctDescription(LanguageEnum language, DescriptionType description) {
  String localizedDescription = '';
  switch (language) {
    case LanguageEnum.english:
      localizedDescription = description.english;
      break;
    case LanguageEnum.persian:
      localizedDescription = description.persian;
      break;
    case LanguageEnum.arabic:
      localizedDescription = description.arabic;
      break;
    case LanguageEnum.german:
      localizedDescription = description.german;
      break;
    case LanguageEnum.russian:
      localizedDescription = description.russian;
      break;
    case LanguageEnum.turkish:
      localizedDescription = description.turkish;
      break;
  }
  return localizedDescription;
}

class CardDescription extends StatelessWidget {
  final DescriptionType description;
  final LanguageEnum language;
  const CardDescription({
    super.key,
    required this.description,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    String localizedDescription;
    switch (language) {
      case LanguageEnum.english:
        localizedDescription = description.english;
        break;
      case LanguageEnum.persian:
        localizedDescription = description.persian;
        break;
      case LanguageEnum.arabic:
        localizedDescription = description.arabic;
        break;
      case LanguageEnum.german:
        localizedDescription = description.german;
        break;
      case LanguageEnum.russian:
        localizedDescription = description.russian;
        break;
      case LanguageEnum.turkish:
        localizedDescription = description.turkish;
        break;
    }

    TextDirection textDir = TextDirection.ltr;
    if (language == LanguageEnum.arabic || language == LanguageEnum.persian) {
      textDir = TextDirection.rtl;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shadowColor: const Color.fromARGB(
        255,
        233,
        70,
        70,
      ).withValues(alpha: 0.12),
      surfaceTintColor: Colors.red,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox.expand(
            child: Text(
              localizedDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 0, 0, 0),
                height: 1.4,
                fontSize: 15,
              ),
              textDirection: textDir,
              // textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
