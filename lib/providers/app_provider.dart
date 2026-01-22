import 'dart:async';

import 'package:flutter/material.dart';

import '../core/result.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/enquiry_repository.dart';
import '../data/repositories/window_repository.dart';
import '../db/database_helper.dart';
import '../models/customer.dart';
import '../models/enquiry.dart';
import '../models/window.dart';
import '../services/app_logger.dart';
import '../services/sync_service.dart';

class AppProvider with ChangeNotifier {
  // Repositories
  final CustomerRepository _customerRepo = CustomerRepository();
  final WindowRepository _windowRepo = WindowRepository();
  final EnquiryRepository _enquiryRepo = EnquiryRepository();
  final AppLogger _logger = AppLogger();

  List<Customer> _customers = [];
  List<Enquiry> _enquiries = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  List<Enquiry> get enquiries => _enquiries;
  bool get isLoading => _isLoading;

  // Cache for windows to enable optimistic UI
  final Map<String, List<Window>> _windowCache = {};

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    final result = await _customerRepo.getAll();
    if (result is Success<List<Customer>>) {
      _customers = result.data;
    } else {
      // Log error but keep empty list or previous list
      await _logger.error(
        'AppProvider',
        'loadCustomers failed',
        result.errorMessage,
      );
    }

    _isLoading = false;
    notifyListeners();
    // Trigger background sync to fetch latest if online
    unawaited(SyncService().syncData());
  }

  /// PRO: Smart Refresh for a single customer
  Future<void> _refreshCustomer(String id) async {
    final result = await _customerRepo.getById(id);
    if (result is Success<Customer>) {
      final updated = result.data;
      final index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updated;
      } else {
        _customers.insert(0, updated);
      }
      notifyListeners();
    }
  }

  Future<Customer> addCustomer(Customer customer) async {
    final result = await _customerRepo.create(customer);

    if (result is Success<Customer>) {
      final createdCustomer = result.data;
      // Smart Refresh: Insert directly at top
      _customers.insert(0, createdCustomer);
      notifyListeners();
      unawaited(SyncService().syncData());
      return createdCustomer;
    } else {
      await _logger.error(
        'AppProvider',
        'addCustomer failed',
        result.errorMessage,
      );
      throw Exception(result.errorMessage);
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    final result = await _customerRepo.update(customer);
    if (result is Success) {
      // Smart Refresh: Reload only this customer
      await _refreshCustomer(customer.id!);
      unawaited(SyncService().syncData());
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<void> deleteCustomer(String id) async {
    await _logger.info('PROVIDER', 'deleteCustomer ENTRY', 'id=$id');

    // 1. Optimistic UI update
    final index = _customers.indexWhere((c) => c.id == id);
    Customer? deletedItem;
    if (index != -1) {
      deletedItem = _customers[index];
      _customers.removeAt(index);
      _windowCache.remove(id);
      notifyListeners();
      await _logger.info(
        'PROVIDER',
        'Optimistic removal done',
        'removed index=$index, name=${deletedItem.name}',
      );
    }

    // 2. Repository call
    final result = await _customerRepo.delete(id);

    if (result is Success) {
      // 3. Trigger background sync
      unawaited(SyncService().syncData());
      // 4. Reload to ensure consistency
      await loadCustomers();
    } else {
      await _logger.error(
        'PROVIDER',
        'deleteCustomer FAILED',
        'id=$id, error=${result.errorMessage}',
      );
      // Re-insert if failed
      if (deletedItem != null) {
        _customers.insert(index, deletedItem);
        notifyListeners();
      }
      throw Exception(result.errorMessage);
    }
  }

  // Enquiries
  Future<void> loadEnquiries() async {
    _isLoading = true;
    notifyListeners();

    final result = await _enquiryRepo.getAll();
    if (result is Success<List<Enquiry>>) {
      _enquiries = result.data;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Enquiry> addEnquiry(Enquiry enquiry) async {
    final result = await _enquiryRepo.create(enquiry);
    if (result is Success<Enquiry>) {
      await loadEnquiries();
      unawaited(SyncService().syncData());
      return result.data;
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<void> updateEnquiry(Enquiry enquiry) async {
    final result = await _enquiryRepo.update(enquiry);
    if (result is Success) {
      await loadEnquiries();
      unawaited(SyncService().syncData());
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<void> deleteEnquiry(String id) async {
    // 1. Optimistic UI update
    final index = _enquiries.indexWhere((e) => e.id == id);
    Enquiry? deletedItem;
    if (index != -1) {
      deletedItem = _enquiries[index];
      _enquiries.removeAt(index);
      notifyListeners();
    }

    // 2. Repository call
    final result = await _enquiryRepo.delete(id);

    if (result is Success) {
      unawaited(SyncService().syncData());
      await loadEnquiries();
    } else {
      await _logger.error(
        'PROVIDER',
        'deleteEnquiry failed',
        'id=$id, error=${result.errorMessage}',
      );
      if (deletedItem != null) {
        _enquiries.insert(index, deletedItem);
        notifyListeners();
      }
      throw Exception(result.errorMessage);
    }
  }

  // Windows
  Future<List<Window>> getWindows(String customerId) async {
    if (_windowCache.containsKey(customerId)) {
      return _windowCache[customerId]!;
    }

    final result = await _windowRepo.getByCustomer(customerId);
    if (result is Success<List<Window>>) {
      final windows = result.data;
      _windowCache[customerId] = windows;
      return windows;
    } else {
      // Return empty or throw? Original returned empty on fail in usage context usually
      return [];
    }
  }

  Future<void> addWindow(Window window) async {
    // Optimistic Update
    if (_windowCache.containsKey(window.customerId)) {
      _windowCache[window.customerId]!.add(window);
      notifyListeners();
    }

    final result = await _windowRepo.create(window);

    if (result is Success) {
      await _refreshCustomer(window.customerId);
      unawaited(SyncService().syncData());
    } else {
      await _logger.error(
        'PROVIDER',
        'FAILED to add window',
        result.errorMessage,
      );
      // Revert
      if (_windowCache.containsKey(window.customerId)) {
        _windowCache[window.customerId]!.removeWhere(
          (w) => w.name == window.name,
        );
        notifyListeners();
      }
      throw Exception(result.errorMessage);
    }
  }

  Future<void> updateWindow(Window window) async {
    // Optimistic Update
    if (_windowCache.containsKey(window.customerId)) {
      final index = _windowCache[window.customerId]!.indexWhere(
        (w) => w.id == window.id,
      );
      if (index != -1) {
        _windowCache[window.customerId]![index] = window;
        notifyListeners();
      }
    }

    final result = await _windowRepo.update(window);
    if (result is Success) {
      await _refreshCustomer(window.customerId);
      unawaited(SyncService().syncData());
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<void> saveWindows(String customerId, List<Window> windows) async {
    final result = await _windowRepo.batchSave(windows);

    if (result is Success) {
      // Invalidate cache
      _windowCache.remove(customerId);
      await getWindows(customerId);
      await _refreshCustomer(customerId);
      unawaited(SyncService().syncData());
    } else {
      await _logger.error('PROVIDER', 'Batch save failed', result.errorMessage);
      throw Exception(result.errorMessage);
    }
  }

  Future<void> deleteWindow(String id) async {
    // 1. Find and update cache optimistically
    String? customerIdFound;
    Window? deletedItem;
    int indexFound = -1;

    for (var entry in _windowCache.entries) {
      final index = entry.value.indexWhere((w) => w.id == id);
      if (index != -1) {
        customerIdFound = entry.key;
        indexFound = index;
        deletedItem = entry.value[index];
        _windowCache[customerIdFound]!.removeAt(index);
        notifyListeners();
        break;
      }
    }

    final result = await _windowRepo.delete(id);

    if (result is Success) {
      if (customerIdFound != null) {
        await _refreshCustomer(customerIdFound);
      } else {
        await loadCustomers();
      }
      unawaited(SyncService().syncData());
    } else {
      await _logger.error(
        'PROVIDER',
        'deleteWindow failed',
        'id=$id, error=${result.errorMessage}',
      );
      // Rollback
      if (customerIdFound != null && deletedItem != null && indexFound != -1) {
        _windowCache[customerIdFound]!.insert(indexFound, deletedItem);
        notifyListeners();
      }
      throw Exception(result.errorMessage);
    }
  }

  Future<int> getWindowCount(String customerId) async {
    if (_windowCache.containsKey(customerId)) {
      return _windowCache[customerId]!.length;
    }
    // If not in cache, fetch
    await getWindows(customerId);
    return _windowCache[customerId]?.length ?? 0;
  }

  Future<double> getTotalSqFt(String customerId) async {
    List<Window> windows;
    if (_windowCache.containsKey(customerId)) {
      windows = _windowCache[customerId]!;
    } else {
      windows = await getWindows(customerId);
    }
    return windows.fold<double>(0.0, (sum, window) => sum + window.sqFt);
  }

  Future<void> repairData() async {
    await _logger.info('PROVIDER', 'Repair Data requested');
    // Keeping this direct call for now as it's a specific maintenance op
    await DatabaseHelper.instance.purgeSyncedDeletes();

    await SyncService().syncData();
    await loadCustomers();
    await loadEnquiries();

    await _logger.info('PROVIDER', 'Repair Data completed');
  }
}
