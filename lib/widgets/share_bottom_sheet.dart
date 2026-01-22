import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/customer.dart';
import '../models/window.dart';
import '../providers/settings_provider.dart';
import '../services/print_service.dart';

class ShareBottomSheet extends StatelessWidget {
  final Customer customer;
  final List<Window> windows;

  const ShareBottomSheet({
    super.key,
    required this.customer,
    required this.windows,
  });

  String _generateShareText(BuildContext context) {
    final buffer = StringBuffer();
    final now = DateTime.now();
    final dateStr = DateFormat('dd-MMM-yyyy').format(now);

    buffer.writeln('*DD UPVC WINDOWS SYSTEM*');
    buffer.writeln('================================');
    buffer.writeln();

    buffer.writeln('*Customer*   : ${customer.name}');
    buffer.writeln('*Location*   : ${customer.location}');
    buffer.writeln('*Date*       : $dateStr');
    buffer.writeln();

    buffer.writeln('*Framework*  : ${customer.framework}');
    buffer.writeln('*Glass*      : ${customer.glassType ?? "-"}');
    buffer.writeln(
      '*Finalized*  : ${customer.isFinalMeasurement ? "Yes" : "No"}',
    );
    buffer.writeln();

    buffer.writeln('================================');
    buffer.writeln('*WINDOW DETAILS*');
    buffer.writeln('================================');
    buffer.writeln();

    int index = 1;
    final rows = <Map<String, String>>[];
    int maxLabel = 0;
    int maxDimen = 0;
    int maxType = 0;

    // Totals accumulation
    // int totalWindows = 0; // Removed unused
    double totalArea = 0;
    final countHold = Provider.of<SettingsProvider>(
      context,
      listen: false,
    ).countHoldOnTotal;

    for (final window in windows) {
      // Accumulate totals based on setting
      if (!window.isOnHold || countHold) {
        totalArea += (window.sqFt * window.quantity);
      }

      // Label
      String label = 'W$index';
      if (window.quantity > 1) {
        label += '(x${window.quantity})';
      }

      // Dimension
      String dimen;
      if (window.width2 != null && window.width2! > 0) {
        dimen =
            '${window.width.toStringAsFixed(0)}+${window.width2!.toStringAsFixed(0)}x${window.height.toStringAsFixed(0)}';
      } else {
        dimen =
            '${window.width.toStringAsFixed(0)}x${window.height.toStringAsFixed(0)}';
      }

      // Type
      String type = window.type;
      if (window.customName != null && window.customName!.isNotEmpty) {
        type = window.customName!;
      }

      // Handle Hold Status
      if (window.isOnHold) {
        type += ' (HOLD)';
      }

      // Truncate insane lengths to keep it readable, but allow reasonable length
      if (type.length > 15) {
        type = type.substring(0, 15);
      }

      // Area (Unit * Qty)
      final lineSqFt = window.sqFt * window.quantity;
      final area = '${lineSqFt.toStringAsFixed(2)} Sq.Ft';

      if (label.length > maxLabel) {
        maxLabel = label.length;
      }
      if (dimen.length > maxDimen) {
        maxDimen = dimen.length;
      }
      if (type.length > maxType) {
        maxType = type.length;
      }

      rows.add({'label': label, 'dimen': dimen, 'type': type, 'area': area});

      index++;
    }

    // Add small padding to calculated max widths for readability
    maxLabel += 1;
    maxDimen += 1;
    maxType += 1;

    // Pass 2: Generate String
    for (final row in rows) {
      buffer.write(row['label']!.padRight(maxLabel));
      buffer.write('| ${row['dimen']!.padRight(maxDimen)}');
      buffer.write('| ${row['type']!.padRight(maxType)}');
      buffer.writeln('| ${row['area']}');
    }

    final rate = customer.ratePerSqft ?? 0.0;
    final amount = totalArea * rate;

    final inrFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs.',
      decimalDigits: 0,
    );

    buffer.writeln();
    buffer.writeln('================================');
    // Use accumulated totals
    buffer.writeln('*Total Area* : ${totalArea.toStringAsFixed(2)} Sq.Ft');

    // Only show financials if rate is provided and > 0
    if (rate > 0) {
      buffer.writeln('*Rate*       : Rs.${rate.toStringAsFixed(0)} / Sq.Ft');
      buffer.writeln('*Amount*     : ${inrFormat.format(amount)}');
    }

    return buffer.toString();
  }

  Future<void> _shareText(BuildContext context, bool viaWhatsApp) async {
    final text = _generateShareText(context);
    if (viaWhatsApp) {
      final encodedText = Uri.encodeComponent(text);
      final url = Uri.parse('whatsapp://send?text=$encodedText');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        await SharePlus.instance.share(ShareParams(text: text));
      }
    } else {
      await SharePlus.instance.share(ShareParams(text: text));
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _sharePdf(BuildContext context, bool isInvoice) async {
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      ),
    );

    // Get setting for PDF generation
    final countHold = Provider.of<SettingsProvider>(
      context,
      listen: false,
    ).countHoldOnTotal;

    try {
      await PrintService.shareDocument(
        customer: customer,
        windows: windows,
        isInvoice: isInvoice,
        countHoldOnTotal: countHold, // Pass the setting
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing PDF: $e')));
      }
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shareText = _generateShareText(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

              Text(
                'Share Measurement',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                constraints: const BoxConstraints(maxHeight: 180),
                child: SingleChildScrollView(
                  child: Text(
                    shareText,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons - 2x2 grid in Enquiry style
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      color: theme.colorScheme.primary,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: shareText));
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtnWithImage(
                      imagePath: 'assets/icons/whatsapp.png',
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () => _shareText(context, true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      color: theme.colorScheme.primary,
                      onTap: () => _shareText(context, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.download_rounded,
                      label: 'Download',
                      color: const Color(0xFFF59E0B),
                      onTap: () => _downloadTxt(context, shareText),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Or share as PDF',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.straighten_rounded,
                      label: 'Measurement PDF',
                      color: theme.colorScheme.primary,
                      onTap: () => _sharePdf(context, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.rocket_launch_rounded,
                      label: 'Invoice PDF',
                      color: theme.colorScheme.primary,
                      onTap: () =>
                          _showComingSoonDialog(context, 'Invoice PDF'),
                      isComingSoon: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    final theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Coming Soon',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.elasticOut,
        );
        return ScaleTransition(
          scale: curvedAnim,
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.7,
                                ),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Coming Soon!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$feature is under development.\nStay tuned for updates!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Got it!'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Download TXT file
  Future<void> _downloadTxt(BuildContext context, String text) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Storage directory not found');
      }

      final fileName = '${customer.name.replaceAll(' ', '_')}_measurement.txt';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(text);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to $fileName'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isComingSoon) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'SOON',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionBtnWithImage({
    required String imagePath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 18, height: 18, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showShareBottomSheet(
  BuildContext context,
  Customer customer,
  List<Window> windows,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    showDragHandle: false,
    builder: (context) =>
        ShareBottomSheet(customer: customer, windows: windows),
  );
}
