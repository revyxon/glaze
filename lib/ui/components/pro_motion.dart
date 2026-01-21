import 'package:flutter/material.dart';

class ProMotion extends StatefulWidget {
  final Widget child;
  final int index; // Order in the list for staggering
  final Duration duration;
  final double verticalOffset;

  const ProMotion({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 800),
    this.verticalOffset = 50.0,
  });

  @override
  State<ProMotion> createState() => _ProMotionState();
}

class _ProMotionState extends State<ProMotion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // Calculate delay based on index
    final delay = Duration(milliseconds: (widget.index * 100).clamp(0, 1500));

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnim = Tween<double>(
      begin: widget.verticalOffset,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    // Subtle scale up from 0.95 to 1.0
    _scaleAnim = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
