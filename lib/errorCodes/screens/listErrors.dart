import 'package:flutter/material.dart';
import 'package:flutter_application_1/errorCodes/models/errorCode_model.dart';
import 'package:flutter_application_1/providers/languageProvider.dart';
import 'package:flutter_application_1/errorCodes/screens/errorDetail.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorCodeListPage extends ConsumerWidget {
  final List<ErrorCodeType> errorCodes;
  final String title;

  const ErrorCodeListPage({
    super.key,
    required this.errorCodes,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ErrorCodeList(errorCodes: errorCodes),
    );
  }
}

class ErrorCodeList extends ConsumerWidget {
  final List<ErrorCodeType> errorCodes;

  const ErrorCodeList({super.key, required this.errorCodes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageNotifierProvider);

    if (errorCodes.isEmpty) {
      return Center(
        child: Text(
          sectionTitle(language, 'empty'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    errorCodes.sort((a, b) => int.parse(a.code).compareTo(int.parse(b.code)));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: errorCodes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final error = errorCodes[index];
        return _ErrorCodeCard(error: error, language: language);
      },
    );
  }
}

class _ErrorCodeCard extends StatelessWidget {
  final ErrorCodeType error;
  final LanguageEnum language;

  const _ErrorCodeCard({required this.error, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDir = textDirection(language);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorDetailPage(error: error),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _CodeBadge(code: error.code),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        error.name.trim(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textDirection: textDir,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _OriginChip(origin: error.origin),
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
    );
  }
}

class _CodeBadge extends StatelessWidget {
  final String code;

  const _CodeBadge({required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.error,
            theme.colorScheme.error.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        originLabel(origin),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
