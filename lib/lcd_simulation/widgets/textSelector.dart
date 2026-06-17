import 'package:flutter/material.dart';

class CarouselItem {
  final String title;
  final String content;
  final TextDirection textDir;

  const CarouselItem({
    required this.title,
    required this.content,
    required this.textDir,
  });
}

class TextCarousel extends StatefulWidget {
  final List<CarouselItem> items;

  const TextCarousel({super.key, required this.items});

  @override
  State<TextCarousel> createState() => _TextCarouselState();
}

class _TextCarouselState extends State<TextCarousel>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TabController _tabController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: widget.items.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMultiple = widget.items.length > 1;

    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _NavButton(
                    icon: Icons.chevron_left_rounded,
                    enabled: hasMultiple && _currentPage > 0,
                    onPressed: () => _goToPage(_currentPage - 1),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.items.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                          _tabController.animateTo(index);
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (item.title.isNotEmpty) ...[
                                  Text(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4,
                                          fontSize: 25,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Divider(),
                                Text(
                                  item.content,
                                  textDirection: item.textDir,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    height: 1.5,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _NavButton(
                    icon: Icons.chevron_right_rounded,
                    enabled:
                        hasMultiple && _currentPage < widget.items.length - 1,
                    onPressed: () => _goToPage(_currentPage + 1),
                  ),
                ],
              ),
            ),
            if (hasMultiple) ...[
              const SizedBox(height: 6),
              TabPageSelector(
                controller: _tabController,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                selectedColor: theme.colorScheme.primary,
                indicatorSize: 8,
              ),
              const SizedBox(height: 4),
              Text(
                '${_currentPage + 1} / ${widget.items.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      iconSize: 28,
      style: IconButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withValues(
          alpha: 0.35,
        ),
        backgroundColor: theme.colorScheme.primaryContainer.withValues(
          alpha: 0.35,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
