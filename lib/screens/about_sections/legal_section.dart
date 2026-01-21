import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/haptics.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTile(
          context,
          'Privacy Policy',
          Icons.privacy_tip_rounded,
          'https://windowtech.com/privacy',
        ),
        const SizedBox(height: 12),
        _buildTile(
          context,
          'Terms of Service',
          Icons.article_rounded,
          'https://windowtech.com/terms',
        ),
        const SizedBox(height: 12),
        _buildTile(
          context,
          'Open Source Licenses',
          Icons.shield_rounded,
          null,
          isLicense: true,
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    String? url, {
    bool isLicense = false,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        Haptics.light();
        if (isLicense) {
          showLicensePage(context: context);
        } else if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
