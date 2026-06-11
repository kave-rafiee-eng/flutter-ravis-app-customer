import 'package:flutter/material.dart';

class RavisListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeLabel;
  final IconData icon;
  final List<Color> gradientColors;
  final TextDirection? textDirection;
  final VoidCallback onTap;

  const RavisListCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.subtitle,
    this.badgeLabel,
    this.textDirection,
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
                RavisGradientIcon(icon: icon, gradientColors: gradientColors),
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
                        textDirection: textDirection,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: textDirection,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (badgeLabel != null && badgeLabel!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        RavisInfoChip(label: badgeLabel!),
                      ],
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

class RavisGradientIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final double size;

  const RavisGradientIcon({
    super.key,
    required this.icon,
    required this.gradientColors,
    this.size = 58,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.52),
    );
  }
}

class RavisInfoChip extends StatelessWidget {
  final String label;

  const RavisInfoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class RavisListSection extends StatelessWidget {
  final String? title;
  final TextDirection? textDirection;
  final List<Widget> children;

  const RavisListSection({
    super.key,
    required this.children,
    this.title,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textDirection: textDirection,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
        ...children,
      ],
    );
  }
}
