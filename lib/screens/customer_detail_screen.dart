import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_data.dart';
import '../models/customer.dart';
import '../models/window.dart';
import '../providers/app_provider.dart';
import '../providers/settings_provider.dart';
import '../services/app_logger.dart';
import '../ui/components/app_card.dart';
import '../ui/components/app_icon.dart';
import '../ui/design_system.dart';
import '../utils/currency_formatter.dart';
import '../utils/fast_page_route.dart';
import '../utils/haptics.dart';
import '../utils/window_calculator.dart';
import '../widgets/print_bottom_sheet.dart';
import '../widgets/share_bottom_sheet.dart';
import '../widgets/skeleton_loader.dart';
import 'add_customer_screen.dart';
import 'window_input_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    unawaited(
      AppLogger().info(
        'VIEW',
        'Viewing details for customer: ${_customer.name}',
      ),
    );
  }

  Map<String, double> _calculatePageStats(
    List<Window> windows,
    double rate,
    bool countHold,
  ) {
    double totalSqFt = 0;
    double totalRate = 0;
    double totalQty = 0;

    for (final w in windows) {
      if (!w.isOnHold || countHold) {
        final sqFt = WindowCalculator.calculateDisplayedSqFt(
          width: w.width,
          height: w.height,
          quantity: w.quantity.toDouble(),
          width2: w.width2 ?? 0.0,
          type: w.type,
          isFormulaA: w.formula == 'A' || w.formula == null,
        );
        totalSqFt += sqFt;
        totalRate += sqFt * rate;
        totalQty += w.quantity;
      }
    }
    return {'sqft': totalSqFt, 'price': totalRate, 'qty': totalQty};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<List<Window>>(
            future: provider.getWindows(_customer.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _LoadingSkeleton();
              }

              final windows = snapshot.data ?? [];
              final settings = Provider.of<SettingsProvider>(context);

              // Improved: Calculate stats in efficient block
              final stats = _calculatePageStats(
                windows,
                _customer.ratePerSqft ?? 0,
                settings.countHoldOnTotal,
              );
              final totalSqFt = stats['sqft']!;
              final totalRate = stats['price']!;
              final totalQty = stats['qty']!.toInt();

              return CustomScrollView(
                slivers: [
                  // Modern App Bar
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 56,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      icon: AppIcon(
                        AppIconType.back,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      _customer.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: AppIcon(
                          AppIconType.share,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => _showShare(windows),
                      ),
                      IconButton(
                        icon: AppIcon(
                          AppIconType.print,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => _showPrint(windows),
                      ),
                      IconButton(
                        icon: AppIcon(
                          AppIconType.more,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => _showOptionsMenu(context),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Customer Info Card
                        _buildInfoCard(
                          theme,
                          isDark,
                          windows,
                          totalSqFt,
                          totalRate,
                          totalQty,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Final Measurement Badge
                        if (_customer.isFinalMeasurement)
                          _buildFinalBadge(theme),

                        // Windows Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Windows',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _editWindows(),
                              icon: AppIcon(
                                AppIconType.edit,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              label: Text(
                                'Edit',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Windows List
                        if (windows.isEmpty)
                          _buildEmptyState(theme)
                        else
                          ...windows.asMap().entries.map(
                            (e) =>
                                _buildWindowCard(theme, isDark, e.value, e.key),
                          ),

                        const SizedBox(height: 80),
                      ]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (settings.hapticFeedback) {
            Haptics.medium();
          }
          unawaited(
            AppLogger().debug('UI', 'Navigating to add new window screen'),
          );
          Navigator.push(
            context,
            FastPageRoute(page: WindowInputScreen(customer: _customer)),
          ).then((_) => setState(() {}));
        },
        backgroundColor: theme.colorScheme.primary,
        child: const AppIcon(AppIconType.add, size: 26, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    bool isDark,
    List<Window> windows,
    double totalSqFt,
    double totalRate,
    int totalQty,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location
          _InfoRow(
            icon: AppIconType.location,
            label: 'Location',
            value: _customer.location,
          ),
          Divider(
            height: 28,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),

          // Phone
          if (_customer.phone?.isNotEmpty == true) ...[
            _InfoRow(
              icon: AppIconType.phone,
              label: 'Phone',
              value: _customer.phone!,
            ),
            Divider(
              height: 28,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ],

          // Glass Type
          if (_customer.glassType?.isNotEmpty == true) ...[
            _InfoRow(
              icon: AppIconType.sparkle,
              label: 'Glass',
              value: _customer.glassType!,
            ),
            Divider(
              height: 28,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ],

          // Framework + Windows + Sqft Row
          Row(
            children: [
              _MiniStatChip(
                icon: AppIconType.settings,
                value: _customer.framework,
                label: 'Framework',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _MiniStatChip(
                icon: AppIconType.window,
                value: '$totalQty',
                label: 'Qty',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _MiniStatChip(
                icon: AppIconType.measurement,
                value: totalSqFt.toStringAsFixed(1),
                label: 'Sqft',
                color: theme.colorScheme.primary,
              ),
            ],
          ),

          // Rate & Total
          if ((_customer.ratePerSqft ?? 0) > 0) ...[
            Divider(
              height: 28,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
            Row(
              children: [
                AppIcon(
                  AppIconType.calculator,
                  size: 22,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rate',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        '${CurrencyFormatter.format(_customer.ratePerSqft ?? 0)}/sqft',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'Total: ${CurrencyFormatter.format(totalRate)}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinalBadge(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      child: const Row(
        children: [
          AppIcon(AppIconType.check, size: 22, color: Color(0xFF10B981)),
          SizedBox(width: AppSpacing.md),
          Text(
            'Final Measurement',
            style: TextStyle(
              color: Color(0xFF047857),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(48),
      alignment: Alignment.center,
      child: Column(
        children: [
          AppIcon(
            AppIconType.window,
            size: 56,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No windows added yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowCard(
    ThemeData theme,
    bool isDark,
    Window window,
    int index,
  ) {
    final rate = _customer.ratePerSqft ?? 0;
    final displayedSqFt = WindowCalculator.calculateDisplayedSqFt(
      width: window.width,
      height: window.height,
      quantity: window.quantity.toDouble(),
      width2: window.width2 ?? 0.0,
      type: window.type,
      isFormulaA: window.formula == 'A' || window.formula == null,
    );
    final cost = displayedSqFt * rate;
    final isHold = window.isOnHold;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 150 + (index * 30).clamp(0, 200)),
      curve: Curves.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 12 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isHold
              ? Colors.amber.withValues(alpha: 0.1)
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isHold
                ? Colors.amber.withValues(alpha: 0.3)
                : theme.colorScheme.outlineVariant.withValues(
                    alpha: isDark ? 0.15 : 0.08,
                  ),
          ),
        ),
        child: Row(
          children: [
            // W1, W2 Badge - circular like screenshot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isHold
                        ? Colors.amber.withValues(alpha: 0.2)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    window.name,
                    style: TextStyle(
                      color: isHold
                          ? Colors.orange[800]
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (window.quantity > 1)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        'x${window.quantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Dimensions + Type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${window.width.toStringAsFixed(0)} × ${window.height.toStringAsFixed(0)} mm',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Type pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isHold
                              ? Colors.amber.withValues(alpha: 0.2)
                              : theme.colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isHold ? 'HOLD' : window.type,
                          style: TextStyle(
                            color: isHold
                                ? Colors.orange[900]
                                : theme.colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isHold) ...[
                        const SizedBox(width: 8),
                        Text(
                          window.type,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${AppData.getWindowName(window.type)}${window.customName != null && window.type == WindowType.custom ? " (${window.customName})" : ""}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Sqft + Cost on right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${displayedSqFt.toStringAsFixed(2)} sqft',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (rate > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(cost),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShare(List<Window> windows) {
    Haptics.light();
    unawaited(AppLogger().debug('UI', 'Showing share bottom sheet'));
    showShareBottomSheet(context, _customer, windows);
  }

  void _showPrint(List<Window> windows) {
    Haptics.light();
    unawaited(AppLogger().debug('UI', 'Showing print bottom sheet'));
    showPrintBottomSheet(context, _customer, windows);
  }

  void _editWindows() {
    Haptics.light();
    Haptics.light();
    unawaited(AppLogger().debug('UI', 'Navigating to edit windows screen'));
    Navigator.push(
      context,
      FastPageRoute(page: WindowInputScreen(customer: _customer)),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showOptionsMenu(BuildContext context) {
    final theme = Theme.of(context);
    Haptics.selection();
    unawaited(AppLogger().debug('UI', 'Showing options menu for customer'));
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MenuTile(
                icon: AppIconType.edit,
                label: 'Edit Customer',
                onTap: () => _editCustomer(context),
              ),
              _MenuTile(
                icon: AppIconType.window,
                label: 'Edit Windows',
                onTap: () {
                  Navigator.pop(context);
                  _editWindows();
                },
              ),
              _MenuTile(
                icon: AppIconType.sparkle,
                label: 'Admin Insights',
                onTap: () {
                  Navigator.pop(context);
                  _showAdminInsights(context);
                },
              ),
              Divider(
                height: 24,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
              ),
              _MenuTile(
                icon: AppIconType.delete,
                label: 'Delete Customer',
                isDestructive: true,
                onTap: () => _deleteCustomer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editCustomer(BuildContext sheetContext) async {
    unawaited(AppLogger().debug('UI', 'Navigating to edit customer screen'));
    if (Navigator.canPop(sheetContext)) {
      Navigator.pop(sheetContext); // Close the bottom sheet
    }
    if (!mounted) {
      return;
    }

    final updated = await Navigator.push<Customer>(
      context, // Use screen context
      FastPageRoute(page: AddCustomerScreen(customerToEdit: _customer)),
    );
    if (updated != null && mounted) {
      setState(() => _customer = updated);
      unawaited(
        AppLogger().info(
          'EDIT',
          'Customer details updated for ${_customer.name}',
        ),
      );
    }
  }

  Future<void> _deleteCustomer(BuildContext menuContext) async {
    final logger = AppLogger();
    await logger.info(
      'DELETE',
      'Starting delete for ${_customer.name}',
      'id=${_customer.id}',
    );

    if (menuContext.mounted && Navigator.canPop(menuContext)) {
      Navigator.pop(menuContext);
    }
    if (!context.mounted) {
      return;
    }

    // Use this.context for the dialog to ensure it is rooted in the screen, not the popped menu
    if (!mounted) {
      return;
    }

    await logger.info('DELETE', 'Showing confirmation dialog');

    if (!mounted) {
      return;
    }
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Customer?'),
            content: Text('Are you sure you want to delete ${_customer.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    await logger.info(
      'DELETE',
      'User response',
      'confirmed=$confirmed, mounted=$mounted',
    );

    if (confirmed && mounted) {
      try {
        // Validate customer ID first
        final customerId = _customer.id;
        if (customerId == null) {
          await logger.error(
            'DELETE',
            'Customer ID is NULL!',
            'customer=${_customer.name}',
          );
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Customer ID is missing'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Capture messenger before navigation to ensure toast works
        final messenger = ScaffoldMessenger.of(context);
        final customerName = _customer.name;

        await logger.info(
          'DELETE',
          'Calling AppProvider.deleteCustomer',
          'id=$customerId, name=$customerName',
        );

        if (!mounted) {
          return;
        }
        await Provider.of<AppProvider>(
          context,
          listen: false,
        ).deleteCustomer(customerId);

        await logger.info('DELETE', 'Provider deleteCustomer SUCCESS');

        // Navigate first
        if (mounted && context.mounted) {
          await logger.info('DELETE', 'Navigating to first route');
          if (!mounted) {
            return;
          }
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        // Then show toast using the captured messenger
        await logger.info(
          'DELETE',
          'DELETE FLOW COMPLETE ✅',
          'customer=$customerName',
        );
        messenger.showSnackBar(
          SnackBar(
            content: Text('Customer $customerName has been deleted'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e, stack) {
        await logger.error(
          'DELETE',
          'CRITICAL ERROR in delete flow',
          'error=$e\nstack=$stack',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Delete failed: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      await logger.info(
        'DELETE',
        'Cancelled by user or not mounted',
        'confirmed=$confirmed, mounted=$mounted',
      );
    }
  }

  void _showAdminInsights(BuildContext context) {
    final theme = Theme.of(context);
    // Use the provider setting to pass correct data to insights if needed
    // For now, insights calculates its own breakdown
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _AdminInsightsSheet(
          customer: _customer,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(3, (i) => const SkeletonWindowCard()),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final AppIconType icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        AppIcon(
          icon,
          size: 22,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final AppIconType icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            AppIcon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final AppIconType icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive ? Colors.red : theme.colorScheme.onSurface;
    return ListTile(
      leading: AppIcon(icon, size: 24, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Haptics.light();
        onTap();
      },
    );
  }
}

class _AdminInsightsSheet extends StatelessWidget {
  final Customer customer;
  final ScrollController scrollController;

  const _AdminInsightsSheet({
    required this.customer,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return FutureBuilder<List<Window>>(
          future: provider.getWindows(customer.id!),
          builder: (context, snapshot) {
            final windows = snapshot.data ?? [];

            // Basic Counts
            // final totalQty = windows.fold(0, (sum, w) => sum + w.quantity); // Removed unused
            final activeWindows = windows.where((w) => !w.isOnHold).toList();
            final holdWindows = windows.where((w) => w.isOnHold).toList();
            final activeQty = activeWindows.fold(
              0,
              (sum, w) => sum + w.quantity,
            );
            final holdQty = holdWindows.fold(0, (sum, w) => sum + w.quantity);

            // SqFt Calculations
            double calculateSqFt(List<Window> list, {bool actual = false}) {
              return list.fold(
                0.0,
                (sum, w) =>
                    sum +
                    (actual
                        ? WindowCalculator.calculateActualSqFt(
                            width: w.width,
                            height: w.height,
                            quantity: w.quantity.toDouble(),
                            width2: w.width2 ?? 0,
                            type: w.type,
                            isFormulaA: w.formula == 'A' || w.formula == null,
                          )
                        : WindowCalculator.calculateDisplayedSqFt(
                            width: w.width,
                            height: w.height,
                            quantity: w.quantity.toDouble(),
                            width2: w.width2 ?? 0,
                            type: w.type,
                            isFormulaA: w.formula == 'A' || w.formula == null,
                          )),
              );
            }

            final totalDisplayedSqFt = calculateSqFt(windows);
            final activeDisplayedSqFt = calculateSqFt(activeWindows);
            final holdDisplayedSqFt = calculateSqFt(holdWindows);

            final activeActualSqFt = calculateSqFt(activeWindows, actual: true);

            // Analysis
            final extraGiven = activeDisplayedSqFt - activeActualSqFt;
            final bonusPercent = activeActualSqFt > 0
                ? (extraGiven / activeActualSqFt * 100)
                : 0.0;
            final rate = customer.ratePerSqft ?? 0;

            // Financials
            final totalPotentialAmount = totalDisplayedSqFt * rate;
            final activeAmount = activeDisplayedSqFt * rate;
            final holdAmount = holdDisplayedSqFt * rate;
            final benefitAmount = activeAmount - (activeActualSqFt * rate);

            // Type Breakdown
            final typeCounts = <String, int>{};
            for (var w in windows) {
              typeCounts[w.type] = (typeCounts[w.type] ?? 0) + w.quantity;
            }

            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AppIcon(
                        AppIconType.sparkle,
                        size: 24,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Insights',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          customer.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Stats
                Row(
                  children: [
                    _InsightStat(
                      icon: AppIconType.window,
                      value: '${windows.length}',
                      label: 'Windows',
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _InsightStat(
                      icon: AppIconType.customer,
                      value: '$activeQty',
                      label: 'Active Qty',
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 12),
                    _InsightStat(
                      icon: AppIconType.settings,
                      value: '$holdQty',
                      label: 'Hold Qty',
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // HOLD Analysis (New Feature)
                _AnalysisCard(
                  title: 'HOLD STATUS ANALYSIS',
                  titleColor: const Color(0xFFF59E0B),
                  children: [
                    _AnalysisRow(
                      label: 'Total SqFt (Incl. Hold)',
                      value: '${totalDisplayedSqFt.toStringAsFixed(2)} sqft',
                      color: theme.colorScheme.onSurface,
                    ),
                    _AnalysisRow(
                      label: 'Active SqFt (No Hold)',
                      value: '${activeDisplayedSqFt.toStringAsFixed(2)} sqft',
                      color: const Color(0xFF10B981),
                    ),
                    Divider(
                      height: 20,
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    _AnalysisRow(
                      label: 'Hold SqFt',
                      value: '${holdDisplayedSqFt.toStringAsFixed(2)} sqft',
                      color: const Color(0xFFF59E0B),
                    ),
                    _AnalysisRow(
                      label: 'Potential Value (Hold)',
                      value: '₹${holdAmount.toStringAsFixed(0)}',
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // SQFT Analysis (Existing enhanced)
                _AnalysisCard(
                  title: 'ACTIVE SQFT PERFORMANCE',
                  titleColor: theme.colorScheme.primary,
                  children: [
                    _AnalysisRow(
                      label: 'Displayed (Active)',
                      value: '${activeDisplayedSqFt.toStringAsFixed(2)} sqft',
                      color: theme.colorScheme.primary,
                    ),
                    _AnalysisRow(
                      label: 'Actual / Real',
                      value: '${activeActualSqFt.toStringAsFixed(2)} sqft',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    Divider(
                      height: 20,
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    _AnalysisRow(
                      label: 'Extra / Waste',
                      value: '+${extraGiven.toStringAsFixed(2)} sqft',
                      color: const Color(0xFFEF4444),
                    ),
                    _AnalysisRow(
                      label: 'Efficiency Bonus',
                      value: '+${bonusPercent.toStringAsFixed(1)}%',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Cost Analysis
                _AnalysisCard(
                  title: 'FINANCIAL OVERVIEW',
                  titleColor: const Color(0xFF10B981),
                  children: [
                    _AnalysisRow(
                      label: 'Total Potential Value',
                      value: '₹${totalPotentialAmount.toStringAsFixed(0)}',
                      color: theme.colorScheme.onSurface,
                    ),
                    _AnalysisRow(
                      label: 'Active Billable',
                      value: '₹${activeAmount.toStringAsFixed(0)}',
                      color: theme.colorScheme.primary,
                    ),
                    Divider(
                      height: 20,
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    _AnalysisRow(
                      label: 'Actual Material Worth',
                      value: '₹${(activeActualSqFt * rate).toStringAsFixed(0)}',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    _AnalysisRow(
                      label: 'Net Margin / Benefit',
                      value: '₹${benefitAmount.toStringAsFixed(0)}',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Type Breakdown (New Feature)
                _AnalysisCard(
                  title: 'WINDOW TYPES DISTRIBUTION',
                  titleColor: const Color(0xFF6366F1),
                  children: typeCounts.entries
                      .map(
                        (e) => _AnalysisRow(
                          label: AppData.getWindowName(e.key),
                          value: '${e.value} units',
                          color: theme.colorScheme.onSurface,
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _InsightStat extends StatelessWidget {
  final AppIconType icon;
  final String value;
  final String label;

  final Color? color;

  const _InsightStat({
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AppIcon(icon, size: 20, color: color ?? theme.colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<Widget> children;

  const _AnalysisCard({
    required this.title,
    required this.titleColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.15 : 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AnalysisRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
