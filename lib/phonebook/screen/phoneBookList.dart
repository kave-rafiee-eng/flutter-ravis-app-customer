import 'package:flutter/material.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/phonebook/model/phonebook_model.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/utils/ravis_localization.dart';
import 'package:flutter_application_1/widgets/ravis_page_header.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class Phonebooklist extends ConsumerWidget {
  final List<PhonebookType> listPhoneBook;

  const Phonebooklist({super.key, required this.listPhoneBook});

  static const _pageTexts = <String, Map<LanguageEnum, String>>{
    'title': {
      LanguageEnum.persian: 'پشتیبانی و خدمات',
      LanguageEnum.english: 'Support & Services',
      LanguageEnum.arabic: 'الدعم والخدمات',
      LanguageEnum.turkish: 'Destek ve Hizmetler',
      LanguageEnum.russian: 'Поддержка и услуги',
      LanguageEnum.german: 'Support und Dienstleistungen',
    },
    'banner_title': {
      LanguageEnum.persian: 'پشتیبانی و خدمات',
      LanguageEnum.english: 'Support & Services',
      LanguageEnum.arabic: 'الدعم والخدمات',
      LanguageEnum.turkish: 'Destek ve Hizmetler',
      LanguageEnum.russian: 'Поддержка и услуги',
      LanguageEnum.german: 'Support und Dienstleistungen',
    },
    'banner_desc': {
      LanguageEnum.persian: 'لیست شماره‌های تماس',
      LanguageEnum.english: 'List of phone numbers',
      LanguageEnum.arabic: 'قائمة أرقام الهاتف',
      LanguageEnum.turkish: 'Telefon numaraları listesi',
      LanguageEnum.russian: 'Список телефонных номеров',
      LanguageEnum.german: 'Liste der Telefonnummern',
    },
    'empty': {
      LanguageEnum.persian: 'موردی یافت نشد',
      LanguageEnum.english: 'No contacts found',
      LanguageEnum.arabic: 'لم يتم العثور على جهات اتصال',
      LanguageEnum.turkish: 'Kişi bulunamadı',
      LanguageEnum.russian: 'Контакты не найдены',
      LanguageEnum.german: 'Keine Kontakte gefunden',
    },
    'call_failed': {
      LanguageEnum.persian: 'امکان باز کردن شماره‌گیر وجود ندارد',
      LanguageEnum.english: 'Could not open phone dialer',
      LanguageEnum.arabic: 'تعذر فتح طالب الهاتف',
      LanguageEnum.turkish: 'Telefon açılamadı',
      LanguageEnum.russian: 'Не удалось открыть набор номера',
      LanguageEnum.german: 'Telefon konnte nicht geöffnet werden',
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
      body: listPhoneBook.isEmpty
          ? Center(
              child: Text(
                localizedPageText(language, _pageTexts, 'empty'),
                style: theme.textTheme.titleMedium,
                textDirection: textDir,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
                  icon: Icons.contacts_rounded,
                  textDirection: textDir,
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < listPhoneBook.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () => _openPhoneDialer(
                              context,
                              listPhoneBook[i].phone,
                              language: language,
                              textDir: textDir,
                            ),
                            leading: Icon(Icons.phone),
                            title: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    listPhoneBook[i].phone,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    listPhoneBook[i].name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              localizedDescriptionPhonebook(
                                language,
                                listPhoneBook[i].description,
                              ),
                              textDirection: textDir,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Future<void> _openPhoneDialer(
    BuildContext context,
    String phone, {
    required LanguageEnum language,
    required TextDirection textDir,
  }) async {
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: cleanedPhone);

    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizedPageText(language, _pageTexts, 'call_failed'),
            textDirection: textDir,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
