/// Application-wide constants for timeouts, limits, and configurations.
/// All magic numbers should be defined here.
abstract class AppConstants {
  // ─────────────────────────────────────────────────────────────────────────
  // TIMEOUTS
  // ─────────────────────────────────────────────────────────────────────────

  /// Network request timeout
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Database operation timeout
  static const Duration dbTimeout = Duration(seconds: 10);

  /// Sync retry delay
  static const Duration syncRetryDelay = Duration(seconds: 5);

  /// Debounce duration for search/input
  static const Duration debounceDelay = Duration(milliseconds: 300);

  // ─────────────────────────────────────────────────────────────────────────
  // LIMITS
  // ─────────────────────────────────────────────────────────────────────────

  /// Maximum customers to load per page
  static const int customersPerPage = 50;

  /// Maximum windows per customer
  static const int maxWindowsPerCustomer = 100;

  /// Maximum retry attempts for sync
  static const int maxSyncRetries = 3;

  /// Maximum log entries to keep locally
  static const int maxLocalLogs = 1000;

  // ─────────────────────────────────────────────────────────────────────────
  // VALIDATION
  // ─────────────────────────────────────────────────────────────────────────

  /// Minimum name length
  static const int minNameLength = 2;

  /// Maximum name length
  static const int maxNameLength = 100;

  /// Maximum phone length
  static const int maxPhoneLength = 15;

  /// Maximum window dimension (in mm)
  static const double maxWindowDimension = 10000;

  /// Minimum window dimension (in mm)
  static const double minWindowDimension = 100;

  // ─────────────────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────────────────

  /// Standard border radius
  static const double borderRadius = 12.0;

  /// Large border radius
  static const double borderRadiusLarge = 24.0;

  /// Standard padding
  static const double padding = 16.0;

  /// Small padding
  static const double paddingSmall = 8.0;

  /// Large padding
  static const double paddingLarge = 24.0;
}
