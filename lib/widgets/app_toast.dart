import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Beautiful toast/snackbar notifications.
abstract class AppToast {
  /// Show a success toast
  static void success(
    BuildContext context,
    String message, {
    String? subtitle,
  }) {
    _show(
      context: context,
      message: message,
      subtitle: subtitle,
      icon: Icons.check_circle_rounded,
      backgroundColor: const Color(0xFF10B981),
    );
  }

  /// Show an error toast
  static void error(BuildContext context, String message, {String? subtitle}) {
    _show(
      context: context,
      message: message,
      subtitle: subtitle,
      icon: Icons.error_rounded,
      backgroundColor: const Color(0xFFEF4444),
    );
  }

  /// Show a warning toast
  static void warning(
    BuildContext context,
    String message, {
    String? subtitle,
  }) {
    _show(
      context: context,
      message: message,
      subtitle: subtitle,
      icon: Icons.warning_rounded,
      backgroundColor: const Color(0xFFF59E0B),
    );
  }

  /// Show an info toast
  static void info(BuildContext context, String message, {String? subtitle}) {
    _show(
      context: context,
      message: message,
      subtitle: subtitle,
      icon: Icons.info_rounded,
      backgroundColor: const Color(0xFF3B82F6),
    );
  }

  /// Show a custom toast
  static void _show({
    required BuildContext context,
    required String message,
    String? subtitle,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
