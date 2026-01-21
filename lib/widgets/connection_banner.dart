import 'package:flutter/material.dart';

/// Connection status banner that shows at the top of screens.
class ConnectionBanner extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;
  final VoidCallback? onRetry;

  const ConnectionBanner({
    super.key,
    required this.isOnline,
    this.isSyncing = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline && !isSyncing) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final color = isOnline ? theme.colorScheme.primary : Colors.orange;
    final icon = isOnline ? Icons.sync_rounded : Icons.cloud_off_rounded;
    final text = isOnline ? 'Syncing data...' : 'You\'re offline';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withValues(alpha: 0.1),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSyncing)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isOnline && onRetry != null) ...[
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onRetry,
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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
