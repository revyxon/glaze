import 'package:glaze/core/result.dart';
import 'package:glaze/db/database_helper.dart';
import 'package:glaze/models/window.dart';
import 'package:glaze/services/app_logger.dart';

/// Repository for Window data operations.
/// Provides a clean abstraction over database operations.
class WindowRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final AppLogger _logger = AppLogger();

  // Singleton
  static final WindowRepository _instance = WindowRepository._();
  factory WindowRepository() => _instance;
  WindowRepository._();

  /// Get all windows for a customer
  Future<Result<List<Window>>> getByCustomer(String customerId) async {
    try {
      final windows = await _db.readWindowsByCustomer(customerId);
      return Success(windows);
    } catch (e, stack) {
      await _logger.error(
        'WindowRepository',
        'getByCustomer failed',
        e.toString(),
      );
      return Failure('Failed to load windows', e, stack);
    }
  }

  /// Get single window by ID
  Future<Result<Window>> getById(String id) async {
    try {
      final window = await _db.readWindow(id);
      if (window == null) {
        return const Failure('Window not found');
      }
      return Success(window);
    } catch (e, stack) {
      await _logger.error('WindowRepository', 'getById failed', e.toString());
      return Failure('Failed to load window', e, stack);
    }
  }

  /// Create a new window
  Future<Result<Window>> create(Window window) async {
    try {
      final created = await _db.createWindow(window);
      await _logger.info(
        'WindowRepository',
        'Window created',
        'id=${created.id}',
      );
      return Success(created);
    } catch (e, stack) {
      await _logger.error('WindowRepository', 'create failed', e.toString());
      return Failure('Failed to create window', e, stack);
    }
  }

  /// Update an existing window
  Future<Result<void>> update(Window window) async {
    try {
      await _db.updateWindow(window);
      await _logger.info(
        'WindowRepository',
        'Window updated',
        'id=${window.id}',
      );
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('WindowRepository', 'update failed', e.toString());
      return Failure('Failed to update window', e, stack);
    }
  }

  /// Delete a window
  Future<Result<void>> delete(String id) async {
    try {
      await _db.deleteWindow(id);
      await _logger.info('WindowRepository', 'Window deleted', 'id=$id');
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('WindowRepository', 'delete failed', e.toString());
      return Failure('Failed to delete window', e, stack);
    }
  }

  /// Batch save windows
  Future<Result<void>> batchSave(List<Window> windows) async {
    try {
      await _db.batchSaveWindows(windows);
      await _logger.info(
        'WindowRepository',
        'Batch saved',
        'count=${windows.length}',
      );
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('WindowRepository', 'batchSave failed', e.toString());
      return Failure('Failed to save windows', e, stack);
    }
  }

  /// Get total sq ft for a customer
  Future<Result<double>> getTotalSqFt(String customerId) async {
    try {
      final windows = await _db.readWindowsByCustomer(customerId);
      final total = windows.fold<double>(0.0, (sum, w) => sum + w.sqFt);
      return Success(total);
    } catch (e, stack) {
      await _logger.error(
        'WindowRepository',
        'getTotalSqFt failed',
        e.toString(),
      );
      return Failure('Failed to calculate total', e, stack);
    }
  }
}
