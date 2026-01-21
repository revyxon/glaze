import 'package:flutter/material.dart';

/// Standard input decoration factory for consistent form styling.
abstract class AppInputDecoration {
  /// Creates a standard input decoration with optional prefix icon
  static InputDecoration standard({
    required BuildContext context,
    required String label,
    IconData? prefixIcon,
    String? hint,
    String? suffix,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hintColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    final fillColor = isDark ? theme.colorScheme.surface : Colors.white;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 20, color: hintColor)
          : null,
      labelStyle: TextStyle(fontSize: 15, color: hintColor),
      floatingLabelStyle: TextStyle(
        fontSize: 14,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark
              ? theme.colorScheme.outlineVariant
              : const Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark
              ? theme.colorScheme.outlineVariant
              : const Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
    );
  }

  /// Compact input decoration for dense layouts
  static InputDecoration compact({
    required BuildContext context,
    required String label,
    String? hint,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hintColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    final fillColor = isDark ? theme.colorScheme.surface : Colors.white;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(fontSize: 13, color: hintColor),
      floatingLabelStyle: TextStyle(
        fontSize: 12,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark
              ? theme.colorScheme.outlineVariant
              : const Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark
              ? theme.colorScheme.outlineVariant
              : const Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
    );
  }
}
