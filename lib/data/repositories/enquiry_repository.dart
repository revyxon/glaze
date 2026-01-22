import 'package:glaze/core/result.dart';
import 'package:glaze/db/database_helper.dart';
import 'package:glaze/models/enquiry.dart';
import 'package:glaze/services/app_logger.dart';

/// Repository for Enquiry data operations.
/// Provides a clean abstraction over database operations.
class EnquiryRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final AppLogger _logger = AppLogger();

  // Singleton
  static final EnquiryRepository _instance = EnquiryRepository._();
  factory EnquiryRepository() => _instance;
  EnquiryRepository._();

  /// Get all enquiries
  Future<Result<List<Enquiry>>> getAll({String? statusFilter}) async {
    try {
      final enquiries = await _db.readAllEnquiries(statusFilter: statusFilter);
      return Success(enquiries);
    } catch (e, stack) {
      await _logger.error('EnquiryRepository', 'getAll failed', e.toString());
      return Failure('Failed to load enquiries', e, stack);
    }
  }

  /// Get single enquiry by ID
  Future<Result<Enquiry>> getById(String id) async {
    try {
      final enquiry = await _db.readEnquiry(id);
      if (enquiry == null) {
        return const Failure('Enquiry not found');
      }
      return Success(enquiry);
    } catch (e, stack) {
      await _logger.error('EnquiryRepository', 'getById failed', e.toString());
      return Failure('Failed to load enquiry', e, stack);
    }
  }

  /// Create a new enquiry
  Future<Result<Enquiry>> create(Enquiry enquiry) async {
    try {
      final created = await _db.createEnquiry(enquiry);
      await _logger.info(
        'EnquiryRepository',
        'Enquiry created',
        'id=${created.id}',
      );
      return Success(created);
    } catch (e, stack) {
      await _logger.error('EnquiryRepository', 'create failed', e.toString());
      return Failure('Failed to create enquiry', e, stack);
    }
  }

  /// Update an existing enquiry
  Future<Result<void>> update(Enquiry enquiry) async {
    try {
      await _db.updateEnquiry(enquiry);
      await _logger.info(
        'EnquiryRepository',
        'Enquiry updated',
        'id=${enquiry.id}',
      );
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('EnquiryRepository', 'update failed', e.toString());
      return Failure('Failed to update enquiry', e, stack);
    }
  }

  /// Delete an enquiry
  Future<Result<void>> delete(String id) async {
    try {
      await _db.deleteEnquiry(id);
      await _logger.info('EnquiryRepository', 'Enquiry deleted', 'id=$id');
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('EnquiryRepository', 'delete failed', e.toString());
      return Failure('Failed to delete enquiry', e, stack);
    }
  }

  /// Get enquiries by status
  Future<Result<List<Enquiry>>> getByStatus(String status) async {
    return getAll(statusFilter: status);
  }

  /// Get pending enquiries count
  Future<Result<int>> getPendingCount() async {
    try {
      final enquiries = await _db.readAllEnquiries(statusFilter: 'pending');
      return Success(enquiries.length);
    } catch (e, stack) {
      await _logger.error(
        'EnquiryRepository',
        'getPendingCount failed',
        e.toString(),
      );
      return Failure('Failed to get count', e, stack);
    }
  }
}
