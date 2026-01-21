import 'package:flutter/material.dart';
import '../../ui/design_system.dart';

class AppTimeline extends StatelessWidget {
  const AppTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'EVOLUTION',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Timeline Container
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              _buildMilestone(
                context,
                date: 'Jan 2026',
                version: 'v2.1 Pro',
                description:
                    'Introduced 64-bit Physics Engine, Dark Mode 3.0, and Vector PDF capabilities.',
                isLatest: true,
              ),
              _buildConnector(context),
              _buildMilestone(
                context,
                date: 'Dec 2025',
                version: 'v2.0 Cloud',
                description:
                    'Launched Firebase differential sync and Multi-device architecture basics.',
              ),
              _buildConnector(context),
              _buildMilestone(
                context,
                date: 'Nov 2025',
                version: 'v1.5 Stable',
                description:
                    'Added support for L-Corner windows and custom accent palettes.',
              ),
              _buildConnector(context),
              _buildMilestone(
                context,
                date: 'Oct 2025',
                version: 'v1.0 Genesis',
                description:
                    'Initial release with basic measurement catalog and local SQLite storage.',
                isFirst: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestone(
    BuildContext context, {
    required String date,
    required String version,
    required String description,
    bool isLatest = false,
    bool isFirst = false,
  }) {
    final theme = Theme.of(context);
    final color = isLatest
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Date)
        SizedBox(
          width: 60,
          child: Text(
            date,
            textAlign: TextAlign.right,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Center (Dot)
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isLatest
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: isLatest
                    ? Border.all(
                        color: theme.colorScheme.primaryContainer,
                        width: 3,
                      )
                    : null,
                boxShadow: isLatest
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        // Right (Content)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                version,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 81,
      ), // 60(date) + 16(gap) + 5(half dot)
      width: 2,
      height: 30,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.2),
    );
  }
}
