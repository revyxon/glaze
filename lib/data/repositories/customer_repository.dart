import 'package:glaze/core/result.dart';
import 'package:glaze/db/database_helper.dart';
import 'package:glaze/models/customer.dart';
import 'package:glaze/services/app_logger.dart';

/// Repository for Customer data operations.
/// Provides a clean abstraction over database operations.
class CustomerRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final AppLogger _logger = AppLogger();

  // Singleton
  static final CustomerRepository _instance = CustomerRepository._();
  factory CustomerRepository() => _instance;
  CustomerRepository._();

  /// Get all customers with stats
  Future<Result<List<Customer>>> getAll() async {
    try {
      final customers = await _db.readCustomersWithStats();
      return Success(customers);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'getAll failed', e.toString());
      return Failure('Failed to load customers', e, stack);
    }
  }

  /// Get single customer by ID
  Future<Result<Customer>> getById(String id) async {
    try {
      final customer = await _db.readCustomerWithStats(id);
      if (customer == null) {
        return const Failure('Customer not found');
      }
      return Success(customer);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'getById failed', e.toString());
      return Failure('Failed to load customer', e, stack);
    }
  }

  /// Create a new customer
  Future<Result<Customer>> create(Customer customer) async {
    try {
      final created = await _db.createCustomer(customer);
      await _logger.info(
        'CustomerRepository',
        'Customer created',
        'id=${created.id}',
      );
      return Success(created);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'create failed', e.toString());
      return Failure('Failed to create customer', e, stack);
    }
  }

  /// Update an existing customer
  Future<Result<void>> update(Customer customer) async {
    try {
      await _db.updateCustomer(customer);
      await _logger.info(
        'CustomerRepository',
        'Customer updated',
        'id=${customer.id}',
      );
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'update failed', e.toString());
      return Failure('Failed to update customer', e, stack);
    }
  }

  /// Delete a customer
  Future<Result<void>> delete(String id) async {
    try {
      await _db.deleteCustomer(id);
      await _logger.info('CustomerRepository', 'Customer deleted', 'id=$id');
      return const Success(null);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'delete failed', e.toString());
      return Failure('Failed to delete customer', e, stack);
    }
  }

  /// Search customers by name or location
  Future<Result<List<Customer>>> search(String query) async {
    try {
      final allCustomers = await _db.readCustomersWithStats();
      final filtered = allCustomers.where((c) {
        final lowerQuery = query.toLowerCase();
        return c.name.toLowerCase().contains(lowerQuery) ||
            c.location.toLowerCase().contains(lowerQuery);
      }).toList();
      return Success(filtered);
    } catch (e, stack) {
      await _logger.error('CustomerRepository', 'search failed', e.toString());
      return Failure('Search failed', e, stack);
    }
  }
}
