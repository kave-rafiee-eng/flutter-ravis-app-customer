import 'package:flutter/material.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:flutter_application_1/tickets/Screens/ticket_detail.dart';
import 'package:flutter_application_1/tickets/models/tecketModel.dart';
import 'package:flutter_application_1/tickets/ticket_api.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ListTicketsScreen extends StatefulWidget {
  final String? userId;

  const ListTicketsScreen({super.key, this.userId});

  @override
  State<ListTicketsScreen> createState() => _ListTicketsScreenState();
}

class _ListTicketsScreenState extends State<ListTicketsScreen> {
  final _storage = ServerAndStorage();
  late Future<_TicketsPageData> _pageFuture;

  @override
  void initState() {
    super.initState();
    _pageFuture = _loadPage();
  }

  Future<_TicketsPageData> _loadPage() async {
    final userId =
        widget.userId ?? (await _storage.readAppInternalDataFromFile()).appId;

    final results = await Future.wait([
      TicketApi.readTicketsByUserId(userId),
      TicketApi.numOfUserUnreadedTickets(userId),
    ]);

    final tickets = results[0] as List<TicketModel>;
    final unreadCount = (results[1] as num).toInt();

    tickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _TicketsPageData(tickets: tickets, unreadCount: unreadCount);
  }

  void _retry() {
    setState(() {
      _pageFuture = _loadPage();
    });
  }

  void _openTicketDetail(String ticketId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TicketDetailScreen(ticketId: ticketId)),
    ).then((_) {
      if (mounted) _retry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تیکت‌های پشتیبانی')),
      body: FutureBuilder<_TicketsPageData>(
        future: _pageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _TicketsErrorView(
              message: snapshot.error is TicketApiException
                  ? (snapshot.error as TicketApiException).message
                  : 'خطا در دریافت تیکت‌ها',
              onRetry: _retry,
            );
          }

          final page = snapshot.data!;
          final tickets = page.tickets;

          if (tickets.isEmpty) {
            return _TicketsEmptyView(onRetry: _retry);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _pageFuture = _loadPage());
              await _pageFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: tickets.length + (page.unreadCount > 0 ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (page.unreadCount > 0 && index == 0) {
                  return _UnreadBanner(count: page.unreadCount);
                }

                final ticketIndex = page.unreadCount > 0 ? index - 1 : index;
                final ticket = tickets[ticketIndex];
                return _TicketCard(
                  ticket: ticket,
                  onTap: () => _openTicketDetail(ticket.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TicketsPageData {
  final List<TicketModel> tickets;
  final int unreadCount;

  const _TicketsPageData({required this.tickets, required this.unreadCount});
}

class _UnreadBanner extends StatelessWidget {
  final int count;

  const _UnreadBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.mark_email_unread_rounded, color: scheme.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count تیکت خوانده‌نشده',
              textDirection: TextDirection.rtl,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const _TicketCard({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateText = DateFormat('yyyy/MM/dd  HH:mm').format(ticket.createdAt);
    final isUnread = !ticket.readed;

    return Material(
      color: isUnread
          ? scheme.primaryContainer.withValues(alpha: 0.35)
          : scheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread
                  ? scheme.primary.withValues(alpha: 0.55)
                  : scheme.outlineVariant.withValues(alpha: 0.7),
              width: isUnread ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isUnread
                            ? scheme.primary.withValues(alpha: 0.18)
                            : scheme.primaryContainer.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.support_agent_rounded,
                        color: isUnread ? scheme.primary : scheme.primary,
                      ),
                    ),
                    if (isUnread)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: scheme.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.surface,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.question,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: isUnread
                              ? FontWeight.w800
                              : FontWeight.w700,
                          height: 1.4,
                          color: isUnread ? scheme.primary : scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _StatusChip(status: ticket.status),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            _UnreadLabel(),
                          ],
                          const SizedBox(width: 8),
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dateText,
                              textDirection: TextDirection.ltr,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: isUnread ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnreadLabel extends StatelessWidget {
  const _UnreadLabel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'جدید',
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.error,
          fontWeight: FontWeight.w700,
        ),
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

class _TicketsEmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const _TicketsEmptyView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'تیکتی ثبت نشده است',
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('بروزرسانی'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TicketsErrorView({required this.message, required this.onRetry});

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
