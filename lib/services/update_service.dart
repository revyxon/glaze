import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'firestore_service.dart';
import 'app_logger.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  final AppLogger _logger = AppLogger();

  /// Check for updates directly from GitHub Releases (revyxon/glaze)
  Future<UpdateCheckResult> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // GitHub API - Latest Release
      // Uses the new repo 'glaze' as requested
      final uri = Uri.parse(
        'https://api.github.com/repos/revyxon/glaze/releases/latest',
      );

      http.Response? response;
      try {
        response = await http.get(uri).timeout(const Duration(seconds: 10));
      } catch (e) {
        _logger.warn('UPDATE', 'GitHub check failed: $e');
        return UpdateCheckResult(hasUpdate: false, error: 'Network error');
      }

      if (response.statusCode != 200) {
        _logger.error('UPDATE', 'GitHub API error: ${response.statusCode}');
        return UpdateCheckResult(
          hasUpdate: false,
          error: 'Update server unavailable',
        );
      }

      final data = jsonDecode(response.body);

      // GitHub Response Mapping
      final String latestTag = data['tag_name'] ?? '';
      final String latestVersion = latestTag.replaceAll(
        'v',
        '',
      ); // Remove 'v' prefix
      final String releaseNotes = data['body'] ?? 'No release notes.';
      final List assets = data['assets'] ?? [];

      if (assets.isEmpty) {
        return UpdateCheckResult(hasUpdate: false, error: 'No APK asset found');
      }

      // Find the APK asset (assuming first .apk or just the first asset)
      final apkAsset = assets.firstWhere(
        (asset) => asset['name'].toString().endsWith('.apk'),
        orElse: () => assets.first,
      );

      final String apkUrl = apkAsset['browser_download_url'];
      final int fileSize = apkAsset['size'];

      if (!_isNewer(currentVersion, latestVersion)) {
        return UpdateCheckResult(hasUpdate: false);
      }

      // Check skip count from Firestore (keeping existing logic)
      final deviceStatus = await FirestoreService().getDeviceStatus();
      final lastSkippedVersion =
          deviceStatus?['lastSkippedVersion'] as String? ?? '';
      int skipCount = deviceStatus?['updateSkipCount'] as int? ?? 0;

      // If it's a new version, reset skip count
      if (lastSkippedVersion != latestVersion) {
        skipCount = 0;
        await FirestoreService().updateUpdateSkipStatus(
          skipCount: 0,
          lastSkippedVersion: latestVersion,
        );
      }

      // Auto-detect "Force Update" if body contains [FORCE]
      final bool isForceUpdate = releaseNotes.contains('[FORCE]');
      final bool skipAllowed = !isForceUpdate && skipCount < 3;

      _logger.info(
        'UPDATE',
        'Update found: $latestVersion (Mandatory: $isForceUpdate) from GitHub',
      );

      return UpdateCheckResult(
        hasUpdate: true,
        version: latestVersion,
        apkUrl: apkUrl,
        fileSize: fileSize,
        releaseNotes: releaseNotes,
        isMandatory: isForceUpdate || !skipAllowed,
        skipCount: skipCount,
      );
    } catch (e) {
      _logger.error('UPDATE', 'Update check failed: $e');
      return UpdateCheckResult(hasUpdate: false, error: e.toString());
    }
  }

  /// Mark the current version as skipped
  Future<void> skipUpdate(String version) async {
    final deviceStatus = await FirestoreService().getDeviceStatus();
    final int currentSkipCount = deviceStatus?['updateSkipCount'] as int? ?? 0;

    await FirestoreService().updateUpdateSkipStatus(
      skipCount: currentSkipCount + 1,
      lastSkippedVersion: version,
    );
  }

  bool _isNewer(String current, String latest) {
    // Strip build numbers (e.g., 1.0.0+1 -> 1.0.0)
    String currentClean = current.split('+')[0];
    String latestClean = latest.split('+')[0];

    List<int> currentParts = currentClean.split('.').map(int.parse).toList();
    List<int> latestParts = latestClean.split('.').map(int.parse).toList();

    // Ensure we have at least 3 parts for comparison
    while (currentParts.length < 3) currentParts.add(0);
    while (latestParts.length < 3) latestParts.add(0);

    for (int i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }
}

class UpdateCheckResult {
  final bool hasUpdate;
  final String? version;
  final String? apkUrl;
  final int? fileSize;
  final String? releaseNotes;
  final bool isMandatory;
  final int skipCount;
  final String? error;

  UpdateCheckResult({
    required this.hasUpdate,
    this.version,
    this.apkUrl,
    this.fileSize,
    this.releaseNotes,
    this.isMandatory = false,
    this.skipCount = 0,
    this.error,
  });
}
