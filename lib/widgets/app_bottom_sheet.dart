import 'package:flutter/material.dart';

/// Utility for building consistent bottom sheets across the app.
abstract class AppBottomSheet {
  /// Shows a standard bottom sheet with consistent styling
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetContainer(child: child),
    );
  }

  /// Shows a scrollable bottom sheet with DraggableScrollableSheet
  static Future<T?> showScrollable<T>({
    required BuildContext context,
    required Widget Function(ScrollController controller) builder,
    bool isDismissible = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) =>
            _BottomSheetContainer(child: builder(scrollController)),
      ),
    );
  }
}

class _BottomSheetContainer extends StatelessWidget {
  final Widget child;

  const _BottomSheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
