import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/models/groupDoc_model.dart';
import 'package:flutter_application_1/documents/screen/selectDocument.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/utils/ravis_localization.dart';
import 'package:flutter_application_1/widgets/ravis_list_card.dart';
import 'package:flutter_application_1/widgets/ravis_page_header.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Selectgroup extends ConsumerWidget {
  final List<GroupDocType> listGroupDoc;

  const Selectgroup({super.key, required this.listGroupDoc});

  static const _pageTexts = <String, Map<LanguageEnum, String>>{
    'title': {
      LanguageEnum.persian: 'گروه فایل‌ها',
      LanguageEnum.english: 'Document Groups',
      LanguageEnum.arabic: 'مجموعات الملفات',
      LanguageEnum.turkish: 'Dosya Grupları',
      LanguageEnum.russian: 'Группы документов',
      LanguageEnum.german: 'Dokumentengruppen',
    },
    'banner_title': {
      LanguageEnum.persian: 'مستندات',
      LanguageEnum.english: 'Documents',
      LanguageEnum.arabic: 'المستندات',
      LanguageEnum.turkish: 'Belgeler',
      LanguageEnum.russian: 'Документы',
      LanguageEnum.german: 'Dokumente',
    },
    'banner_desc': {
      LanguageEnum.persian: 'گروه مورد نظر را انتخاب کنید',
      LanguageEnum.english: 'Select a document group',
      LanguageEnum.arabic: 'اختر مجموعة المستندات',
      LanguageEnum.turkish: 'Bir belge grubu seçin',
      LanguageEnum.russian: 'Выберите группу документов',
      LanguageEnum.german: 'Wählen Sie eine Dokumentengruppe',
    },
    'subtitle': {
      LanguageEnum.persian: 'دسته‌بندی‌ها',
      LanguageEnum.english: 'Categories',
      LanguageEnum.arabic: 'الفئات',
      LanguageEnum.turkish: 'Kategoriler',
      LanguageEnum.russian: 'Категории',
      LanguageEnum.german: 'Kategorien',
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

  // static const _groupIcons = [
  //   Icons.menu_book_rounded,
  //   Icons.inventory_2_outlined,
  //   Icons.folder_special_rounded,
  //   Icons.description_outlined,
  // ];

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
        child: listGroupDoc.isEmpty
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
                      for (var i = 0; i < listGroupDoc.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        _buildGroupCard(
                          context: context,
                          group: listGroupDoc[i],
                          language: language,
                          textDir: textDir,
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

  Widget _buildGroupCard({
    required BuildContext context,
    required GroupDocType group,
    required LanguageEnum language,
    required TextDirection textDir,
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

    return RavisListCard(
      title: localizedDescriptionDoc(language, group.category),
      subtitle: _firstFileName(language, group),
      badgeLabel: _fileCountLabel(language, group.files.length),
      // icon: _groupIcons[index % _groupIcons.length],
      icon: Icons.folder_copy_outlined,
      gradientColors: gradientColors,
      textDirection: textDir,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Selectdocument(groupDoc: group),
          ),
        );
      },
    );
  }

  String? _firstFileName(LanguageEnum language, GroupDocType group) {
    if (group.files.isEmpty) return null;
    return localizedDescriptionDoc(language, group.files.first.name);
  }

  String _fileCountLabel(LanguageEnum language, int count) {
    final labels = {
      LanguageEnum.persian: '$count فایل',
      LanguageEnum.english: '$count files',
      LanguageEnum.arabic: '$count ملفات',
      LanguageEnum.turkish: '$count dosya',
      LanguageEnum.russian: '$count файлов',
      LanguageEnum.german: '$count Dateien',
    };
    return labels[language] ?? labels[LanguageEnum.english]!;
  }
}
