import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_logger.dart';
import '../ui/components/app_icon.dart';
import '../utils/haptics.dart';
// import '../widgets/glass_container.dart'; // Using inline glass style for specific customization if needed, or re-using similar logic

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  // If true, shows all details. If false, compact mode.
  bool _showDetails = false;

  final List<String> _categories = ['All', 'Sync', 'DB', 'UI', 'System'];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<LogEntry> get filteredLogs {
    var logs = AppLogger().logs;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      logs = logs
          .where(
            (l) =>
                l.message.toLowerCase().contains(q) ||
                l.tag.toLowerCase().contains(q) ||
                (l.data?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }

    if (_selectedCategory != 'All') {
      logs = logs.where((l) {
        final tag = l.tag.toUpperCase();
        switch (_selectedCategory) {
          case 'Sync':
            return tag.contains('SYNC') || tag.contains('FIREBASE');
          case 'DB':
            return tag.contains('DB') || tag.contains('DATABASE');
          case 'UI':
            return tag.contains('VIEW') ||
                tag.contains('SCREEN') ||
                tag.contains('MAIN');
          case 'System':
            return tag.contains('LOGGER') ||
                tag.contains('LICENSE') ||
                tag.contains('APP');
          default:
            return true;
        }
      }).toList();
    }

    return logs.reversed.toList();
  }

  // Premium Accent Colors
  Color _getLevelColor(LogLevel level, bool isDark) {
    switch (level) {
      case LogLevel.debug:
        return isDark
            ? const Color(0xFF94A3B8)
            : const Color(0xFF64748B); // Slate
      case LogLevel.info:
        return const Color(0xFF10B981); // Emerald
      case LogLevel.warn:
        return const Color(0xFFF59E0B); // Amber
      case LogLevel.error:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Icons.bug_report_rounded;
      case LogLevel.info:
        return Icons.info_rounded;
      case LogLevel.warn:
        return Icons.warning_rounded;
      case LogLevel.error:
        return Icons.error_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Background gradient for premium feel
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Ambient Background
          Positioned.fill(
            child: Container(color: theme.scaffoldBackgroundColor),
          ),
          if (isDark)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, theme),

                // Filter Section with blurred background style
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search logs...',
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            icon: Icon(
                              Icons.search_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(cat),
                                  onSelected: (val) {
                                    Haptics.selection();
                                    setState(() => _selectedCategory = cat);
                                  },
                                  backgroundColor: Colors.transparent,
                                  selectedColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.2),
                                  side: BorderSide(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outlineVariant,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  showCheckmark: false,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredLogs.isEmpty
                      ? _buildEmptyState(theme)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filteredLogs.length,
                          itemBuilder: (context, index) {
                            final entry = filteredLogs[index];
                            final color = _getLevelColor(entry.level, isDark);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _PremiumLogTile(
                                key: ValueKey(
                                  entry.timestamp,
                                ), // Ensure keys for list efficiency
                                entry: entry,
                                showDetails: _showDetails,
                                accentColor: color,
                                icon: _getLevelIcon(entry.level),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Haptics.medium();
          setState(() => _showDetails = !_showDetails);
        },
        elevation: 4,
        backgroundColor: theme.colorScheme.primary,
        icon: Icon(
          _showDetails ? Icons.compress_rounded : Icons.expand_rounded,
          color: theme.colorScheme.onPrimary,
        ),
        label: Text(
          _showDetails ? 'Collapse' : 'Expand All',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const AppIcon(AppIconType.back),
            color: theme.colorScheme.onSurface,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Logs',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '${filteredLogs.length} events logged',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const AppIcon(AppIconType.copy),
            color: theme.colorScheme.onSurface,
            tooltip: 'Copy Logs',
            onPressed: () {
              Haptics.light();
              Clipboard.setData(ClipboardData(text: AppLogger().exportLogs()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const AppIcon(AppIconType.delete),
            color: theme.colorScheme.error,
            tooltip: 'Clear Logs',
            onPressed: _confirmClearLogs,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No matching logs found',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all logs?'),
        content: const Text(
          'This will permanently remove all system logs from the device memory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AppLogger().clearLogs();
              if (mounted && context.mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PremiumLogTile extends StatefulWidget {
  final LogEntry entry;
  final bool showDetails;
  final Color accentColor;
  final IconData icon;

  const _PremiumLogTile({
    super.key,
    required this.entry,
    required this.showDetails,
    required this.accentColor,
    required this.icon,
  });

  @override
  State<_PremiumLogTile> createState() => _PremiumLogTileState();
}

class _PremiumLogTileState extends State<_PremiumLogTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine expansion state based on global preference OR local toggle
    final isExpanded = widget.showDetails || _isExpanded;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Haptics.selection();
        setState(() => _isExpanded = !_isExpanded);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(
            alpha: isDark ? 0.6 : 0.8,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Glassmorphism
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Region
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.05),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Status Dot / Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.accentColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 14,
                          color: widget.accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tag Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.entry.tag.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Timestamp
                      Text(
                        widget.entry.formattedTime,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),

                // Message Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.message,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          // Use Inter implicitly via Theme
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                      ),

                      // Detailed Data Payload
                      if (isExpanded && widget.entry.data != null)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF8FAFC), // Slate 900 / 50
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: SelectableText(
                            widget.entry.data!,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              height: 1.4,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Expansion Indicator (Bottom) - Only if not auto-expanded?
                // Let's keep it clean. If not expanded and long message, maybe show faint chevron?
                // For now, simplicity is premium.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
