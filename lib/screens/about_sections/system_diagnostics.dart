import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../ui/design_system.dart';

class SystemDiagnostics extends StatefulWidget {
  const SystemDiagnostics({super.key});

  @override
  State<SystemDiagnostics> createState() => _SystemDiagnosticsState();
}

class _SystemDiagnosticsState extends State<SystemDiagnostics> {
  String _deviceModel = 'Scanning...';
  String _osVersion = '...';
  String _sdkInt = '...';
  String _arch = '...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      if (mounted) {
        setState(() {
          _deviceModel = '${android.brand} ${android.model}';
          _osVersion = 'Android ${android.version.release}';
          _sdkInt = 'SDK ${android.version.sdkInt}';
          _arch = android.supportedAbis.firstOrNull ?? 'Unknown';
        });
      }
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      if (mounted) {
        setState(() {
          _deviceModel = ios.name;
          _osVersion = '${ios.systemName} ${ios.systemVersion}';
          _sdkInt = 'Kernel ${ios.utsname.release}';
          _arch = 'arm64';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'SYSTEM METRICS',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMetricRow(theme, 'DEVICE', _deviceModel.toUpperCase()),
              _buildDivider(),
              _buildMetricRow(theme, 'OS BUILD', '$_osVersion ($_sdkInt)'),
              _buildDivider(),
              _buildMetricRow(theme, 'CPU ARCH', _arch.toUpperCase()),
              _buildDivider(),
              _buildMetricRow(
                theme,
                'DISPLAY',
                '${size.width.toInt()}x${size.height.toInt()} @ ${pixelRatio.toStringAsFixed(1)}x',
              ),
              _buildDivider(),
              _buildMetricRow(theme, 'MEMORY', 'Dynamic Allocation'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.white.withValues(alpha: 0.1));
  }
}
