import 'package:flutter/material.dart';

/// Beautiful empty state widget for lists and screens.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  /// Empty customer list
  factory EmptyStateWidget.customers({VoidCallback? onAdd}) {
    return EmptyStateWidget(
      icon: Icons.people_outline_rounded,
      title: 'No Customers Yet',
      subtitle: 'Start by adding your first customer',
      actionLabel: 'Add Customer',
      onAction: onAdd,
    );
  }

  /// Empty windows list
  factory EmptyStateWidget.windows({VoidCallback? onAdd}) {
    return EmptyStateWidget(
      icon: Icons.window_outlined,
      title: 'No Windows Added',
      subtitle: 'Add windows to calculate the total area',
      actionLabel: 'Add Window',
      onAction: onAdd,
    );
  }

  /// Empty enquiries list
  factory EmptyStateWidget.enquiries({VoidCallback? onAdd}) {
    return EmptyStateWidget(
      icon: Icons.contact_page_outlined,
      title: 'No Enquiries',
      subtitle: 'Add potential leads here',
      actionLabel: 'New Enquiry',
      onAction: onAdd,
    );
  }

  /// Search results empty
  factory EmptyStateWidget.searchEmpty() {
    return const EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'No Results Found',
      subtitle: 'Try a different search term',
    );
  }

  /// Error state
  factory EmptyStateWidget.error({String? message, VoidCallback? onRetry}) {
    return EmptyStateWidget(
      icon: Icons.error_outline_rounded,
      title: 'Something Went Wrong',
      subtitle: message ?? 'Please try again',
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }

  /// Offline state
  factory EmptyStateWidget.offline({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      icon: Icons.cloud_off_rounded,
      title: 'You\'re Offline',
      subtitle: 'Check your internet connection',
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
