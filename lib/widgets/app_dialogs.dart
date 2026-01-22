import 'dart:async';
import 'package:flutter/material.dart';

/// Reusable confirmation dialogs with consistent styling.
abstract class AppDialogs {
  /// Shows a confirmation dialog with customizable actions
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) async {
    final theme = Theme.of(context);
    final color =
        confirmColor ??
        (isDangerous ? theme.colorScheme.error : theme.colorScheme.primary);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: icon != null ? Icon(icon, color: color, size: 32) : null,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Shows a delete confirmation dialog
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
  }) {
    return showConfirmation(
      context: context,
      title: 'Delete $itemName?',
      message: 'This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Keep',
      icon: Icons.delete_outline_rounded,
      isDangerous: true,
    );
  }

  /// Shows a discard changes dialog
  static Future<bool> showDiscardChanges({required BuildContext context}) {
    return showConfirmation(
      context: context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Are you sure you want to leave?',
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
      icon: Icons.warning_amber_rounded,
      isDangerous: true,
    );
  }

  /// Shows a success dialog with auto-dismiss
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 2),
  }) async {
    final theme = Theme.of(context);

    unawaited(
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Future.delayed(duration, () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// Shows a loading dialog
  static void showLoading(BuildContext context, [String? message]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? 'Please wait...'),
            ],
          ),
        ),
      ),
    );
  }

  /// Hides the loading dialog
  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
