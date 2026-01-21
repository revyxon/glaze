import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../ui/design_system.dart';

class TechStack extends StatelessWidget {
  const TechStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'BUILT WITH',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildTechCard(context, 'flutter-icon.svg', 'Flutter', 'UI Engine'),
            _buildTechCard(
              context,
              'dart-programming-language-icon.svg',
              'Dart',
              'Core Logic',
            ),
            _buildTechCard(
              context,
              'google-firebase-icon.svg',
              'Firebase',
              'Cloud Backend',
            ),
            _buildTechCard(context, 'sqlite-icon.svg', 'SQLite', 'Local DB'),
            _buildTechCard(
              context,
              'android-robot-bot-icon.svg',
              'Android',
              'Platform',
            ),
            _buildTechCard(
              context,
              'visual-studio-code-icon.svg',
              'VS Code',
              'IDE',
            ),
            _buildTechCard(context, 'figma-icon.svg', 'Figma', 'UI Design'),
            _buildTechCard(
              context,
              'github-icon.svg',
              'GitHub',
              'Version Control',
            ),
            _buildTechCard(context, 'docker-icon.svg', 'Docker', 'Container'),
            _buildTechCard(
              context,
              'material-design-svgrepo-com.svg',
              'Material 3',
              'Design System',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechCard(
    BuildContext context,
    String svgName,
    String name,
    String role,
  ) {
    final theme = Theme.of(context);
    // isDark removed

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset('assets/tech/$svgName'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
