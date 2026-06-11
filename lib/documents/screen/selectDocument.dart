import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/models/groupDoc_model.dart';
import 'package:flutter_application_1/documents/widgets/PdfDownloaderAndViwer.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/utils/ravis_localization.dart';
import 'package:flutter_application_1/widgets/ravis_list_card.dart';
import 'package:flutter_application_1/widgets/ravis_page_header.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Selectdocument extends ConsumerWidget {
  final GroupDocType groupDoc;
  const Selectdocument({super.key, required this.groupDoc});

  static const _pageTexts = <String, Map<LanguageEnum, String>>{
    'title': {
      LanguageEnum.persian: ' فایل‌ها',
      LanguageEnum.english: '',
      LanguageEnum.arabic: '',
      LanguageEnum.turkish: '',
      LanguageEnum.russian: '',
      LanguageEnum.german: '',
    },
    'banner_title': {
      LanguageEnum.persian: 'فایل',
      LanguageEnum.english: 'Documents',
      LanguageEnum.arabic: 'المستندات',
      LanguageEnum.turkish: 'Belgeler',
      LanguageEnum.russian: 'Документы',
      LanguageEnum.german: 'Dokumente',
    },
    'banner_desc': {
      LanguageEnum.persian: 'فایل مودر نظر را انتخاب کنید',
      LanguageEnum.english: '',
      LanguageEnum.arabic: '',
      LanguageEnum.turkish: '',
      LanguageEnum.russian: '',
      LanguageEnum.german: '',
    },
    'subtitle': {
      LanguageEnum.persian: 'فایل',
      LanguageEnum.english: '',
      LanguageEnum.arabic: '',
      LanguageEnum.turkish: '',
      LanguageEnum.russian: '',
      LanguageEnum.german: '',
    },
    'hint': {
      LanguageEnum.persian: 'روی هر گزینه بزنید تا فایل‌های آن گروه باز شود',
      LanguageEnum.english: 'Tap an option to open its files',
      LanguageEnum.arabic: 'اضغط على خيار لفتح ملفاته',
      LanguageEnum.turkish: 'Dosyalarını açmak için bir seçeneğe dokunun',
      LanguageEnum.russian: 'Нажмите, чтобы открыть файлы группы',
      LanguageEnum.german: 'Tippen Sie, um die Dateien zu öffnen',
    },
    'empty': {
      LanguageEnum.persian: 'گروهی یافت نشد',
      LanguageEnum.english: 'No groups found',
      LanguageEnum.arabic: 'لم يتم العثور على مجموعات',
      LanguageEnum.turkish: 'Grup bulunamadı',
      LanguageEnum.russian: 'Группы не найдены',
      LanguageEnum.german: 'Keine Gruppen gefunden',
    },
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final textDir = textDirection(language);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedPageText(language, _pageTexts, 'title')),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: Selectlanguage()),
          ),
        ],
      ),
      body: SafeArea(
        child: groupDoc.files.isEmpty
            ? Center(
                child: Text(
                  localizedPageText(language, _pageTexts, 'empty'),
                  style: theme.textTheme.titleMedium,
                  textDirection: textDir,
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  RavisPageHeader(
                    title: localizedPageText(
                      language,
                      _pageTexts,
                      'banner_title',
                    ),
                    description: localizedPageText(
                      language,
                      _pageTexts,
                      'banner_desc',
                    ),
                    icon: Icons.folder_copy_rounded,
                    textDirection: textDir,
                  ),
                  const SizedBox(height: 24),
                  RavisListSection(
                    title: localizedPageText(language, _pageTexts, 'subtitle'),
                    textDirection: textDir,
                    children: [
                      for (var i = 0; i < groupDoc.files.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        _buildCard(
                          context: context,
                          file: groupDoc.files[i],
                          language: language,
                          theme: theme,
                          index: i,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    localizedPageText(language, _pageTexts, 'hint'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textDirection: textDir,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required PdfFileType file,
    required LanguageEnum language,
    required ThemeData theme,
    required int index,
  }) {
    final gradientColors = index.isEven
        ? [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ]
        : [
            theme.colorScheme.tertiary,
            theme.colorScheme.tertiary.withValues(alpha: 0.7),
          ];

    final textDir = textDirection(language);

    return RavisListCard(
      title: localizedDescriptionDoc(language, file.name),
      subtitle: file.fileName,
      badgeLabel: "",
      icon: Icons.picture_as_pdf,
      gradientColors: gradientColors,
      textDirection: textDir,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PdfDownloaderAndViwer(fileName: file.fileName),
          ),
        );
      },
    );
  }
}
