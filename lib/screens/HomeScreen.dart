import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/mainDocuments.dart';
import 'package:flutter_application_1/errorCodes/mainError.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/lcd_simulation/mainLcd.dart';
import 'package:flutter_application_1/phonebook/mainPhonebook.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/utils/ravis_localization.dart';
import 'package:flutter_application_1/widgets/ravis_list_card.dart';
import 'package:flutter_application_1/widgets/ravis_page_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final theme = Theme.of(context);
    final textDir = textDirection(language);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          RavisPageHeader(
            title: bilingualText('راویس', 'Ravis', language),
            description: bilingualText(
              'به اپلیکیشن مشتریان خوش آمدید',
              'Welcome to Customers App',
              language,
            ),
            icon: Icons.elevator_rounded,
            textDirection: textDir,
          ),
          const SizedBox(height: 24),
          Text(
            bilingualText('ماژول‌ها', 'Modules', language),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textDirection: textDir,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          RavisListCard(
            title: bilingualText('کدهای خطا', 'Error Codes', language),
            subtitle: bilingualText(
              'مشاهده و عیب‌یابی خطاها',
              'Browse and diagnose faults',
              language,
            ),
            icon: Icons.error_outline_rounded,
            gradientColors: [
              theme.colorScheme.error,
              theme.colorScheme.error.withValues(alpha: 0.7),
            ],
            textDirection: textDir,
            onTap: () => _navigateTo(context, LoadDataErrorCode()),
          ),
          const SizedBox(height: 14),
          RavisListCard(
            title: bilingualText('منوی Advance', 'Advance Menu', language),
            subtitle: bilingualText(
              'تنظیمات و پارامترهای LCD',
              'LCD settings and parameters',
              language,
            ),
            icon: Icons.memory_rounded,
            gradientColors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.7),
            ],
            textDirection: textDir,
            onTap: () => _navigateTo(context, LoadDataMenu()),
          ),
          const SizedBox(height: 14),
          RavisListCard(
            title: bilingualText('فایل‌ها', 'Documents', language),
            subtitle: bilingualText(
              'آموزش‌ها و محصولات',
              'Trainings and product manuals',
              language,
            ),
            icon: Icons.folder_copy_rounded,
            gradientColors: [
              theme.colorScheme.tertiary,
              theme.colorScheme.tertiary.withValues(alpha: 0.7),
            ],
            textDirection: textDir,
            onTap: () => _navigateTo(context, LoadDataGroupDocs()),
          ),
          const SizedBox(height: 14),
          RavisListCard(
            title: bilingualText('بشتیبانی', 'support', language),
            subtitle: bilingualText('', '', language),
            icon: Icons.folder_copy_rounded,
            gradientColors: [
              theme.colorScheme.tertiary,
              theme.colorScheme.tertiary.withValues(alpha: 0.7),
            ],
            textDirection: textDir,
            onTap: () => _navigateTo(context, LoadDataPhonebook()),
          ),
          const SizedBox(height: 28),
          _HomeFooter(language: language, textDir: textDir),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _HomeFooter extends StatelessWidget {
  final LanguageEnum language;
  final TextDirection textDir;

  const _HomeFooter({required this.language, required this.textDir});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              bilingualText('نسخه ۱.۰.۰', 'Version 1.0.0', language),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textDirection: textDir,
            ),
          ),
        ],
      ),
    );
  }
}
