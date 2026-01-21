import 'package:flutter/material.dart';

/// Animated counter widget for smooth number transitions.
class AnimatedCounter extends StatelessWidget {
  final double value;
  final String? prefix;
  final String? suffix;
  final int decimalPlaces;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.decimalPlaces = 2,
    this.style,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final formattedValue = animatedValue.toStringAsFixed(decimalPlaces);
        return Text(
          '${prefix ?? ''}$formattedValue${suffix ?? ''}',
          style: style ?? Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}

/// Animated progress bar
class AnimatedProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 8,
    this.borderRadius = 4,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  color: foregroundColor ?? theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Animated badge/chip that can change content
class AnimatedBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Duration duration;

  const AnimatedBadge({
    super.key,
    required this.text,
    required this.color,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: AnimatedSwitcher(
        duration: duration,
        child: Text(
          text,
          key: ValueKey(text),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Scale animation on tap
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;

  const ScaleOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.95,
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleValue : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
