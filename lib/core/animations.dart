import 'package:flutter/material.dart';

/// Standard animation durations and curves for consistent UX.
abstract class AppAnimations {
  // ─────────────────────────────────────────────────────────────────────────
  // DURATIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Fast animations (buttons, switches, chips)
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal animations (cards, dialogs, transitions)
  static const Duration normal = Duration(milliseconds: 250);

  /// Slow animations (page transitions, complex reveals)
  static const Duration slow = Duration(milliseconds: 350);

  /// Extra slow for dramatic effects
  static const Duration extraSlow = Duration(milliseconds: 500);

  // ─────────────────────────────────────────────────────────────────────────
  // CURVES
  // ─────────────────────────────────────────────────────────────────────────

  /// Standard ease out curve
  static const Curve standard = Curves.easeOutCubic;

  /// Smooth decelerate
  static const Curve decelerate = Curves.decelerate;

  /// Bounce effect for playful interactions
  static const Curve bounce = Curves.elasticOut;

  /// Subtle overshoot for button presses
  static const Curve overshoot = Curves.easeOutBack;

  /// Linear for progress indicators
  static const Curve linear = Curves.linear;

  // ─────────────────────────────────────────────────────────────────────────
  // PRESETS
  // ─────────────────────────────────────────────────────────────────────────

  /// Button press animation config
  static const buttonPress = _AnimationPreset(fast, standard);

  /// Card hover/focus animation config
  static const cardHover = _AnimationPreset(normal, standard);

  /// Page transition config
  static const pageTransition = _AnimationPreset(slow, decelerate);

  /// Dialog appear config
  static const dialogAppear = _AnimationPreset(normal, overshoot);
}

/// Animation preset combining duration and curve
class _AnimationPreset {
  final Duration duration;
  final Curve curve;

  const _AnimationPreset(this.duration, this.curve);
}
