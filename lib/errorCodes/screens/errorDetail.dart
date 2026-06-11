import 'package:flutter/material.dart';
import 'package:flutter_application_1/errorCodes/models/errorCode_model.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDetailPage extends ConsumerWidget {
  final ErrorCodeType error;

  const ErrorDetailPage({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final textDir = textDirection(language);
    final theme = Theme.of(context);

    final description = localizedDescription(language, error.description);
    final solution = localizedDescription(language, error.solution);
    final aiDescription = localizedMiniDescription(
      language,
      error.additional_description_for_ai_assistant,
    );

    return Scaffold(
      appBar: AppBar(title: Text(error.name.trim(), textDirection: textDir)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(error: error, language: language),
          const SizedBox(height: 16),
          _DetailSection(
            title: sectionTitle(language, 'description'),
            content: description,
            language: language,
            textDir: textDir,
            icon: Icons.info_outline_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: sectionTitle(language, 'solution'),
            content: solution,
            language: language,
            textDir: textDir,
            icon: Icons.build_circle_outlined,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: sectionTitle(language, 'ai_assistant'),
            content: aiDescription,
            language: language,
            textDir: textDir,
            icon: Icons.smart_toy_outlined,
            color: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ErrorCodeType error;
  final LanguageEnum language;

  const _HeaderCard({required this.error, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDir = textDirection(language);

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                error.code,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error.name.trim(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textDirection: textDir,
                  ),
                  const SizedBox(height: 8),
                  _OriginChip(origin: error.origin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final String content;
  final LanguageEnum language;
  final TextDirection textDir;
  final IconData icon;
  final Color color;

  const _DetailSection({
    required this.title,
    required this.content,
    required this.language,
    required this.textDir,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayContent = content.trim().isEmpty
        ? sectionTitle(language, 'empty')
        : content;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textDirection: textDir,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              displayContent,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              textDirection: textDir,
            ),
          ],
        ),
      ),
    );
  }
}

class _OriginChip extends StatelessWidget {
  final ErrorOriginEnum origin;

  const _OriginChip({required this.origin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        originLabel(origin),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String originLabel(ErrorOriginEnum origin) {
  switch (origin) {
    case ErrorOriginEnum.ONLY_ADVANCE:
      return 'Advance';
    case ErrorOriginEnum.ONLY_TERSE:
      return 'Terse';
    case ErrorOriginEnum.ADVANCE_TERSE:
      return 'Advance & Terse';
  }
}

TextDirection textDirection(LanguageEnum language) {
  if (language == LanguageEnum.persian || language == LanguageEnum.arabic) {
    return TextDirection.rtl;
  }
  return TextDirection.ltr;
}

String localizedDescription(
  LanguageEnum language,
  DescriptionType description,
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

String localizedMiniDescription(
  LanguageEnum language,
  MiniDescriptionType description,
) {
  switch (language) {
    case LanguageEnum.persian:
      return description.persian;
    default:
      return description.english;
  }
}

String sectionTitle(LanguageEnum language, String section) {
  const titles = {
    'description': {
      LanguageEnum.persian: 'توضیحات',
      LanguageEnum.english: 'Description',
      LanguageEnum.arabic: 'الوصف',
      LanguageEnum.turkish: 'Açıklama',
      LanguageEnum.russian: 'Описание',
      LanguageEnum.german: 'Beschreibung',
    },
    'solution': {
      LanguageEnum.persian: 'راه‌حل',
      LanguageEnum.english: 'Solution',
      LanguageEnum.arabic: 'الحل',
      LanguageEnum.turkish: 'Çözüm',
      LanguageEnum.russian: 'Решение',
      LanguageEnum.german: 'Lösung',
    },
    'ai_assistant': {
      LanguageEnum.persian: 'توضیحات دستیار هوشمند',
      LanguageEnum.english: 'AI Assistant Notes',
      LanguageEnum.arabic: 'ملاحظات المساعد الذكي',
      LanguageEnum.turkish: 'Yapay Zeka Notları',
      LanguageEnum.russian: 'Заметки ИИ-ассистента',
      LanguageEnum.german: 'KI-Assistent Hinweise',
    },
    'empty': {
      LanguageEnum.persian: 'اطلاعاتی ثبت نشده است',
      LanguageEnum.english: 'No information available',
      LanguageEnum.arabic: 'لا توجد معلومات',
      LanguageEnum.turkish: 'Bilgi mevcut değil',
      LanguageEnum.russian: 'Информация отсутствует',
      LanguageEnum.german: 'Keine Informationen verfügbar',
    },
  };

  return titles[section]![language] ?? titles[section]![LanguageEnum.english]!;
}
