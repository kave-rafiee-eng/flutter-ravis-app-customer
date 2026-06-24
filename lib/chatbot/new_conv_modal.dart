import 'package:flutter/material.dart';

const _accent = Color(0xFF1B3C53);
const _accentLight = Color(0xFF456882);

const _categories = ['کدهای خطا برد راویس', 'yaskawa l1000a'];

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
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(_categories.length, false);
  }

  int get _selectedCount => _checked.where((v) => v).length;

  void _toggle(int index) {
    setState(() => _checked[index] = !_checked[index]);
  }

  void _create() {
    final selected = [
      for (var i = 0; i < _categories.length; i++)
        if (_checked[i]) _categories[i],
    ];
    widget.onSuccess(
      'سلام گفتگوی جدید ایجاد کنیم با موضوعات :${selected.join(' و ')}',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_comment_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Conversation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'choose topics for this chat',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.category_outlined, color: _accent, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (_selectedCount > 0) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_selectedCount selected',
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_categories.length, (index) {
                    final isSelected = _checked[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected
                            ? _accent.withValues(alpha: 0.03)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => _toggle(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? _accent : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggle(index),
                                  activeColor: _accent,
                                  side: const BorderSide(color: _accentLight),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                Expanded(
                                  child: Text(
                                    _categories[index],
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: _accent,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
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
                          backgroundColor: _accent,
                          disabledBackgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
