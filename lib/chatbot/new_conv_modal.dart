import 'package:flutter/material.dart';

const _categories = [
  'کدهای خطا محصولات راویس',
  'پارامتر، منو و تنظیمات Advance',
  'پارامتر، منو و تنظیمات Terse',
  'درایو Yaskawa L1000A',
  'درایو HD5L HPMPoint',
  'ایجاد تیکت برای پشتیبانی',
  '',
];

Future<void> showNewConversationModal(
  BuildContext context, {
  required void Function(String message) onSuccess,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _NewConvDialog(onSuccess: onSuccess),
  );
}

class _NewConvDialog extends StatefulWidget {
  final void Function(String message) onSuccess;

  const _NewConvDialog({required this.onSuccess});

  @override
  State<_NewConvDialog> createState() => _NewConvDialogState();
}

class _NewConvDialogState extends State<_NewConvDialog> {
  late final List<String> _items;
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _items = _categories.where((c) => c.trim().isNotEmpty).toList();
    _checked = List.filled(_items.length, false);
  }

  int get _selectedCount => _checked.where((v) => v).length;

  void _toggle(int index) {
    setState(() => _checked[index] = !_checked[index]);
  }

  void _create() {
    final selected = [
      for (var i = 0; i < _items.length; i++)
        if (_checked[i]) _items[i],
    ];
    widget.onSuccess(
      'سلام گفتگوی جدید ایجاد کنیم با موضوعات :${selected.join(' و ')}',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460, maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(scheme: scheme),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CategoriesTitle(
                      scheme: scheme,
                      selectedCount: _selectedCount,
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_items.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CategoryTile(
                          label: _items[index],
                          isSelected: _checked[index],
                          scheme: scheme,
                          onToggle: () => _toggle(index),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.onSurfaceVariant,
                      side: BorderSide(color: scheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _selectedCount == 0 ? null : _create,
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.primary,
                      disabledBackgroundColor: scheme.onSurface.withValues(
                        alpha: 0.12,
                      ),
                      foregroundColor: scheme.onPrimary,
                      disabledForegroundColor: scheme.onSurface.withValues(
                        alpha: 0.38,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final ColorScheme scheme;

  const _DialogHeader({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.add_comment_outlined, color: scheme.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Conversation',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'choose topics for this chat',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesTitle extends StatelessWidget {
  final ColorScheme scheme;
  final int selectedCount;

  const _CategoriesTitle({required this.scheme, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.category_outlined, color: scheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Categories',
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        if (selectedCount > 0) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$selectedCount selected',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ColorScheme scheme;
  final VoidCallback onToggle;

  const _CategoryTile({
    required this.label,
    required this.isSelected,
    required this.scheme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? scheme.primaryContainer.withValues(alpha: 0.4)
          : scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return scheme.primary;
                  }
                  return null;
                }),
                side: BorderSide(color: scheme.outline),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    label,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: scheme.primary,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
