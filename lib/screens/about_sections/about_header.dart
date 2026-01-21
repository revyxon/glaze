import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../ui/design_system.dart';
import '../../ui/components/app_icon.dart';

class AboutHeader extends StatefulWidget {
  final PackageInfo? packageInfo;

  const AboutHeader({super.key, required this.packageInfo});

  @override
  State<AboutHeader> createState() => _AboutHeaderState();
}

class _AboutHeaderState extends State<AboutHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    _slideAnim = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutQuart),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final version = widget.packageInfo?.version ?? '...';
    final buildNumber = widget.packageInfo?.buildNumber ?? '...';

    return SizedBox(
      height: 400, // Very Big Header
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient Blobs
          Positioned(
            top: -50,
            right: -50,
            child: _buildBlob(theme.colorScheme.primary, 200),
          ),
          Positioned(
            bottom: 50,
            left: -30,
            child: _buildBlob(theme.colorScheme.tertiary, 150),
          ),

          // Glass Content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnim.value),
                child: Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Container
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                                theme.colorScheme.tertiary.withValues(
                                  alpha: 0.8,
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.window_rounded,
                              size: 70,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // App Name
                        Text(
                          widget.packageInfo?.appName.toUpperCase() ?? 'GLAZE',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4.0,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        // Subtitle
                        Text(
                          'PREMIUM MEASUREMENT SUITE',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            letterSpacing: 3.0,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Version Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                AppIconType.sparkle,
                                size: 16,
                                color: theme.colorScheme.tertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pro Edition v$version ($buildNumber)',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    ).animateDouble(
      (val, child) => Transform.scale(scale: 1 + val * 0.1, child: child),
    );
  }
}

extension _AnimExt on Widget {
  Widget animateDouble(Widget Function(double, Widget) builder) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) => builder(value, child!),
      child: this,
    );
  }
}
