import 'package:flutter/material.dart';
import 'package:flutter_application_1/errorCodes/models/errorCode_model.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/errorCodes/screens/errorDetail.dart';
import 'package:flutter_application_1/errorCodes/screens/listErrors.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/widgets/selectLanguage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectboradForErrorCode extends ConsumerWidget {
  final List<ErrorCodeType> listErrorCode;
  const SelectboradForErrorCode({super.key, required this.listErrorCode});

  static const langs = <LanguageEnum, String>{
    LanguageEnum.persian: 'فارسی',
    LanguageEnum.english: 'English',
    LanguageEnum.arabic: 'العربية',
    LanguageEnum.turkish: 'Türkçe',
    LanguageEnum.russian: 'Русский',
    LanguageEnum.german: 'Deutsch',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final textDir = textDirection(language);
    final theme = Theme.of(context);

    final advanceCount = _countForOrigins({
      ErrorOriginEnum.ONLY_ADVANCE,
      ErrorOriginEnum.ADVANCE_TERSE,
    });
    final terseCount = _countForOrigins({
      ErrorOriginEnum.ONLY_TERSE,
      ErrorOriginEnum.ADVANCE_TERSE,
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageText(language, 'title')),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: DropdownButtonHideUnderline(child: Selectlanguage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderBanner(language: language, textDir: textDir),
              const SizedBox(height: 28),
              Text(
                _pageText(language, 'subtitle'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textDirection: textDir,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _BoardOptionCard(
                title: _pageText(language, 'advance'),
                subtitle: _pageText(language, 'advance_desc'),
                countLabel: _errorCountLabel(language, advanceCount),
                icon: Icons.memory_rounded,
                gradientColors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
                onTap: () => _openErrorList(
                  context,
                  title: _pageText(language, 'advance'),
                  origins: {
                    ErrorOriginEnum.ONLY_ADVANCE,
                    ErrorOriginEnum.ADVANCE_TERSE,
                  },
                ),
              ),
              const SizedBox(height: 14),
              _BoardOptionCard(
                title: _pageText(language, 'terse'),
                subtitle: _pageText(language, 'terse_desc'),
                countLabel: _errorCountLabel(language, terseCount),
                icon: Icons.eco_sharp,
                gradientColors: [
                  theme.colorScheme.tertiary,
                  theme.colorScheme.tertiary.withValues(alpha: 0.7),
                ],
                onTap: () => _openErrorList(
                  context,
                  title: _pageText(language, 'terse'),
                  origins: {
                    ErrorOriginEnum.ONLY_TERSE,
                    ErrorOriginEnum.ADVANCE_TERSE,
                  },
                ),
              ),
              const Spacer(),
              Text(
                _pageText(language, 'hint'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textDirection: textDir,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _countForOrigins(Set<ErrorOriginEnum> origins) {
    return listErrorCode
        .where((error) => origins.contains(error.origin))
        .length;
  }

  String _errorCountLabel(LanguageEnum language, int count) {
    final labels = {
      LanguageEnum.persian: '$count کد خطا',
      LanguageEnum.english: '$count error codes',
      LanguageEnum.arabic: '$count رموز خطأ',
      LanguageEnum.turkish: '$count hata kodu',
      LanguageEnum.russian: '$count кодов ошибок',
      LanguageEnum.german: '$count Fehlercodes',
    };
    return labels[language] ?? labels[LanguageEnum.english]!;
  }

  void _openErrorList(
    BuildContext context, {
    required String title,
    required Set<ErrorOriginEnum> origins,
  }) {
    final filteredCodes = listErrorCode
        .where((error) => origins.contains(error.origin))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ErrorCodeListPage(errorCodes: filteredCodes, title: title),
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  final LanguageEnum language;
  final TextDirection textDir;

  const _HeaderBanner({required this.language, required this.textDir});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.developer_board_outlined,
              color: theme.colorScheme.onError,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _pageText(language, 'banner_title'),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: textDir,
                ),
                const SizedBox(height: 4),
                Text(
                  _pageText(language, 'banner_desc'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textDirection: textDir,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String countLabel;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _BoardOptionCard({
    required this.title,
    required this.subtitle,
    required this.countLabel,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer
                              .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          countLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _pageText(LanguageEnum language, String key) {
  const texts = {
    'title': {
      LanguageEnum.persian: 'کدهای خطا',
      LanguageEnum.english: 'Error Codes',
      LanguageEnum.arabic: 'رموز الأخطاء',
      LanguageEnum.turkish: 'Hata Kodları',
      LanguageEnum.russian: 'Коды ошибок',
      LanguageEnum.german: 'Fehlercodes',
    },
    'banner_title': {
      LanguageEnum.persian: 'راهنمای خطاها',
      LanguageEnum.english: 'Error Guide',
      LanguageEnum.arabic: 'دليل الأخطاء',
      LanguageEnum.turkish: 'Hata Rehberi',
      LanguageEnum.russian: 'Справочник ошибок',
      LanguageEnum.german: 'Fehlerhandbuch',
    },
    'banner_desc': {
      LanguageEnum.persian: 'ابتدا نوع برد خود را انتخاب کنید',
      LanguageEnum.english: 'First, select your board type',
      LanguageEnum.arabic: 'أولاً، اختر نوع اللوحة',
      LanguageEnum.turkish: 'Önce kart tipinizi seçin',
      LanguageEnum.russian: 'Сначала выберите тип платы',
      LanguageEnum.german: 'Wählen Sie zuerst Ihren Board-Typ',
    },
    'subtitle': {
      LanguageEnum.persian: 'برد خود را انتخاب کنید',
      LanguageEnum.english: 'Select your board',
      LanguageEnum.arabic: 'اختر لوحتك',
      LanguageEnum.turkish: 'Kartınızı seçin',
      LanguageEnum.russian: 'Выберите плату',
      LanguageEnum.german: 'Wählen Sie Ihr Board',
    },
    'advance': {
      LanguageEnum.persian: 'Advance',
      LanguageEnum.english: 'Advance',
      LanguageEnum.arabic: 'Advance',
      LanguageEnum.turkish: 'Advance',
      LanguageEnum.russian: 'Advance',
      LanguageEnum.german: 'Advance',
    },
    'advance_desc': {
      LanguageEnum.persian: 'خطاهای مربوط به برد Advance',
      LanguageEnum.english: 'Errors for Advance board',
      LanguageEnum.arabic: 'أخطاء لوحة Advance',
      LanguageEnum.turkish: 'Advance kartı hataları',
      LanguageEnum.russian: 'Ошибки платы Advance',
      LanguageEnum.german: 'Fehler für Advance-Board',
    },
    'terse': {
      LanguageEnum.persian: 'Terse',
      LanguageEnum.english: 'Terse',
      LanguageEnum.arabic: 'Terse',
      LanguageEnum.turkish: 'Terse',
      LanguageEnum.russian: 'Terse',
      LanguageEnum.german: 'Terse',
    },
    'terse_desc': {
      LanguageEnum.persian: 'خطاهای مربوط به برد Terse',
      LanguageEnum.english: 'Errors for Terse board',
      LanguageEnum.arabic: 'أخطاء لوحة Terse',
      LanguageEnum.turkish: 'Terse kartı hataları',
      LanguageEnum.russian: 'Ошибки платы Terse',
      LanguageEnum.german: 'Fehler für Terse-Board',
    },
    'hint': {
      LanguageEnum.persian: 'روی هر گزینه بزنید تا لیست خطاها باز شود',
      LanguageEnum.english: 'Tap an option to open the error list',
      LanguageEnum.arabic: 'اضغط على خيار لفتح قائمة الأخطاء',
      LanguageEnum.turkish: 'Hata listesini açmak için bir seçeneğe dokunun',
      LanguageEnum.russian: 'Нажмите, чтобы открыть список ошибок',
      LanguageEnum.german: 'Tippen Sie, um die Fehlerliste zu öffnen',
    },
  };

  return texts[key]![language] ?? texts[key]![LanguageEnum.english]!;
}
