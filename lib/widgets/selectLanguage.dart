import 'package:flutter/material.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Selectlanguage extends ConsumerWidget {
  const Selectlanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final theme = Theme.of(context);
    const langs = <LanguageEnum, String>{
      LanguageEnum.persian: 'فارسی',
      LanguageEnum.english: 'English',
      LanguageEnum.arabic: 'العربية',
      LanguageEnum.turkish: 'Türkçe',
      LanguageEnum.russian: 'Русский',
      LanguageEnum.german: 'Deutsch',
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: language.name,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.language),
        dropdownColor: theme.colorScheme.surface,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        onChanged: (value) {
          if (value == null) return;
          ref
              .read(languageNotifierProvider.notifier)
              .changeLanguage(LanguageEnum.values.byName(value));
        },
        items: langs.entries
            .map(
              (e) => DropdownMenuItem<String>(
                value: e.key.name,
                child: Text(e.value),
              ),
            )
            .toList(),
      ),
    );
  }
}
