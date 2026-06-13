import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/mainDocuments.dart';
import 'package:flutter_application_1/errorCodes/mainError.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/lcd_simulation/mainLcd.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/utils/ravis_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);
    final theme = Theme.of(context);
    final textDir = textDirection(language);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerHeader(language: language, textDir: textDir),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              bilingualText('ماژول‌ها', 'Modules', language),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
              textDirection: textDir,
            ),
          ),
          _DrawerMenuItem(
            icon: Icons.error_outline_rounded,
            iconColor: theme.colorScheme.error,
            titleFa: 'کدهای خطا',
            titleEn: 'Error Codes',
            subtitleFa: 'مشاهده و عیب‌یابی خطاها',
            subtitleEn: 'Browse and diagnose faults',
            language: language,
            onTap: () => _navigateTo(context, LoadDataErrorCode()),
          ),
          _DrawerMenuItem(
            icon: Icons.tune_rounded,
            iconColor: theme.colorScheme.primary,
            titleFa: 'منوی Advance',
            titleEn: 'Advance Menu',
            subtitleFa: 'تنظیمات و پارامترهای LCD',
            subtitleEn: 'LCD settings and parameters',
            language: language,
            onTap: () => _navigateTo(context, LoadDataMenu()),
          ),
          _DrawerMenuItem(
            icon: Icons.tune_rounded,
            iconColor: theme.colorScheme.primary,
            titleFa: 'فایل ها',
            titleEn: 'Documents',
            subtitleFa: 'اموزش ها و محصولات',
            subtitleEn: 'product manual ...',
            language: language,
            onTap: () => _navigateTo(context, LoadDataGroupDocs()),
          ),
          const Spacer(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bilingualText('نسخه ۱.۰.۰', 'Version 1.0.0', language),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textDirection: textDir,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _DrawerHeader extends StatelessWidget {
  final LanguageEnum language;
  final TextDirection textDir;

  const _DrawerHeader({required this.language, required this.textDir});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.elevator_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Spacer(),
          Text(
            bilingualText('راویس', 'Ravis', language),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textDirection: textDir,
          ),
          const SizedBox(height: 4),
          Text(
            bilingualText('اپلیکیشن مشتریان', 'Customers App', language),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
            textDirection: textDir,
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String titleFa;
  final String titleEn;
  final String subtitleFa;
  final String subtitleEn;
  final LanguageEnum language;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.iconColor,
    required this.titleFa,
    required this.titleEn,
    required this.subtitleFa,
    required this.subtitleEn,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDir = textDirection(language);
    final isPersianPrimary = language == LanguageEnum.persian;

    final title = isPersianPrimary ? titleFa : titleEn;
    final subtitle = isPersianPrimary ? subtitleFa : subtitleEn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          textDirection: textDir,
                        ),
                        // Text(
                        //   titleAlt,
                        //   style: theme.textTheme.bodySmall?.copyWith(
                        //     color: theme.colorScheme.primary,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        //   textDirection: isPersianPrimary
                        //       ? TextDirection.ltr
                        //       : TextDirection.rtl,
                        // ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                          textDirection: textDir,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
