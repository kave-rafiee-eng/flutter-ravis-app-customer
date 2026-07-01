import 'package:flutter/material.dart';
import 'package:flutter_application_1/tickets/models/tecketModel.dart';
import 'package:flutter_application_1/tickets/ticket_api.dart';
import 'package:intl/intl.dart' hide TextDirection;

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late Future<TicketModel> _ticketFuture;

  @override
  void initState() {
    super.initState();
    _ticketFuture = TicketApi.readTicket(widget.ticketId);
  }

  void _retry() {
    setState(() {
      _ticketFuture = TicketApi.readTicket(widget.ticketId);
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd  HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جزئیات تیکت')),
      body: FutureBuilder<TicketModel>(
        future: _ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _TicketErrorView(
              message: snapshot.error is TicketApiException
                  ? (snapshot.error as TicketApiException).message
                  : 'خطا در دریافت تیکت',
              onRetry: _retry,
            );
          }

          final ticket = snapshot.data!;
          return _TicketDetailContent(ticket: ticket, formatDate: _formatDate);
        },
      ),
    );
  }
}

class _TicketDetailContent extends StatelessWidget {
  final TicketModel ticket;
  final String Function(DateTime) formatDate;

  const _TicketDetailContent({required this.ticket, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasAnswer = ticket.answer.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: scheme.primaryContainer.withValues(alpha: 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    color: scheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatusChip(status: ticket.status),
                          _ReadChip(readed: ticket.readed),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ایجاد: ${formatDate(ticket.createdAt)}',
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      if (ticket.closedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'بسته‌شدن: ${formatDate(ticket.closedAt!)}',
                          textDirection: TextDirection.ltr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _DetailSection(
          title: 'سوال',
          icon: Icons.help_outline_rounded,
          color: scheme.primary,
          child: Text(
            ticket.question,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ),
        const SizedBox(height: 12),
        _DetailSection(
          title: 'پاسخ',
          icon: Icons.mark_chat_read_outlined,
          color: scheme.tertiary,
          child: Text(
            hasAnswer ? ticket.answer : 'هنوز پاسخی ثبت نشده است',
            textDirection: TextDirection.rtl,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: hasAnswer ? scheme.onSurface : scheme.onSurfaceVariant,
              fontStyle: hasAnswer ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _DetailSection(
          title: 'اطلاعات تیکت',
          icon: Icons.info_outline_rounded,
          color: scheme.secondary,
          child: Column(
            children: [
              _InfoRow(label: 'شناسه', value: ticket.id, monospace: true),
              if (ticket.userId != null)
                _InfoRow(label: 'کاربر', value: ticket.userId!),
              _InfoRow(
                label: 'وضعیت',
                value: ticket.status == TicketStatus.pending
                    ? 'در انتظار'
                    : 'بسته شده',
              ),
              _InfoRow(
                label: 'خوانده شده',
                value: ticket.readed ? 'بله' : 'خیر',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;

  const _InfoRow({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: monospace ? 'monospace' : null,
                fontSize: monospace ? 12 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TicketStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (label, color) = switch (status) {
      TicketStatus.pending => ('در انتظار', scheme.tertiary),
      TicketStatus.closed => ('بسته شده', scheme.outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ReadChip extends StatelessWidget {
  final bool readed;

  const _ReadChip({required this.readed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = readed ? scheme.primary : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        readed ? 'خوانده شده' : 'خوانده نشده',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TicketErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TicketErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: scheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}
