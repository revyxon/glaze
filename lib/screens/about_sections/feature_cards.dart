import 'package:flutter/material.dart';
import '../../ui/design_system.dart';
import '../../ui/components/app_icon.dart';

class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'CORE POWERS'),
        const SizedBox(height: AppSpacing.md),
        _buildFeatureCard(
          context,
          icon: AppIconType.calculator,
          title: 'Precision Engine',
          subtitle: 'Zero-Error Measurement System',
          description:
              'Powered by a valid 64-bit floating point logic engine that handles complex L-Corner calculations with ease. It automatically applies Formula A/B logic based on window types.',
          color: Colors.blue,
          tags: ['64-bit Float', 'L-Corner Logic', 'Auto-Calc'],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFeatureCard(
          context,
          icon: AppIconType.enquiry,
          title: 'Smart Enquiries',
          subtitle: 'Lead Lifecycle Management',
          description:
              'A complete CRM pipeline built directly into your workflow. Track customer interest from initial contact, to site visit, to final quotation with zero friction.',
          color: Colors.orange,
          tags: ['CRM Pipeline', 'Status Tracking', 'Lead Convert'],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFeatureCard(
          context,
          icon: AppIconType.sync,
          title: 'Cloud Sync 3.0',
          subtitle: 'Differential Data Push',
          description:
              'Never lose a measurement. Our background sync engine pushes only the changes (differential sync) to Firestore, ensuring minimal data usage and maximum speed.',
          color: Colors.green,
          tags: ['Background Sync', 'Diff-Push', 'Firestore'],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFeatureCard(
          context,
          icon: AppIconType.print,
          title: 'Pro Reporting',
          subtitle: 'Native Vector PDF Generation',
          description:
              'Generate client-ready quotations and invoices instantly. Uses native vector graphics generation for crisp, print-ready documents at any scale.',
          color: Colors.purple,
          tags: ['Vector PDF', 'Instant Invoice', 'Share Ready'],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFeatureCard(
          context,
          icon: AppIconType.lock,
          title: 'Security Suite',
          subtitle: 'Enterprise Grade Protection',
          description:
              'Your data is locked to your Device ID and backed by cloud authentication. Includes offline-guard mode to protect sensitive pricing data.',
          color: Colors.redAccent,
          tags: ['Device Lock', 'Offline Guard', 'Secure Storage'],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required AppIconType icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required List<String> tags,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Decor
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AppIcon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
