import 'package:flutter/material.dart';

/// Status chip/badge for various states.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isPulsing;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isPulsing = false,
  });

  /// Pending status
  factory StatusBadge.pending() {
    return const StatusBadge(
      label: 'Pending',
      color: Color(0xFFF59E0B),
      icon: Icons.schedule_rounded,
    );
  }

  /// Approved status
  factory StatusBadge.approved() {
    return const StatusBadge(
      label: 'Approved',
      color: Color(0xFF10B981),
      icon: Icons.check_circle_rounded,
    );
  }

  /// Rejected status
  factory StatusBadge.rejected() {
    return const StatusBadge(
      label: 'Rejected',
      color: Color(0xFFEF4444),
      icon: Icons.cancel_rounded,
    );
  }

  /// On hold status
  factory StatusBadge.onHold() {
    return const StatusBadge(
      label: 'On Hold',
      color: Color(0xFF6B7280),
      icon: Icons.pause_circle_rounded,
    );
  }

  /// Syncing status
  factory StatusBadge.syncing() {
    return const StatusBadge(
      label: 'Syncing',
      color: Color(0xFF3B82F6),
      icon: Icons.sync_rounded,
      isPulsing: true,
    );
  }

  /// Synced status
  factory StatusBadge.synced() {
    return const StatusBadge(
      label: 'Synced',
      color: Color(0xFF10B981),
      icon: Icons.cloud_done_rounded,
    );
  }

  /// Final measurement
  factory StatusBadge.final_() {
    return const StatusBadge(
      label: 'Final',
      color: Color(0xFF10B981),
      icon: Icons.verified_rounded,
    );
  }

  /// Draft/preliminary measurement
  factory StatusBadge.draft() {
    return const StatusBadge(
      label: 'Draft',
      color: Color(0xFF6B7280),
      icon: Icons.edit_note_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (isPulsing) {
      badge = _PulsingBadge(child: badge);
    }

    return badge;
  }
}

class _PulsingBadge extends StatefulWidget {
  final Widget child;

  const _PulsingBadge({required this.child});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
