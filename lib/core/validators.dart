/// Input validation utilities for forms and user input.
abstract class Validators {
  // ─────────────────────────────────────────────────────────────────────────
  // TEXT VALIDATORS
  // ─────────────────────────────────────────────────────────────────────────

  /// Validates a required field
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates name (min 2 chars, max 100)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Name must be less than 100 characters';
    }
    return null;
  }

  /// Validates phone number (optional, but if provided must be valid)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validates location (optional but max length)
  static String? location(String? value) {
    if (value != null && value.length > 200) {
      return 'Location must be less than 200 characters';
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NUMBER VALIDATORS
  // ─────────────────────────────────────────────────────────────────────────

  /// Validates positive number
  static String? positiveNumber(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be positive';
    }
    return null;
  }

  /// Validates window dimension (100-10000 mm)
  static String? windowDimension(
    String? value, [
    String fieldName = 'Dimension',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number < 100) {
      return '$fieldName must be at least 100mm';
    }
    if (number > 10000) {
      return '$fieldName cannot exceed 10000mm';
    }
    return null;
  }

  /// Validates quantity (1-100)
  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number < 1) {
      return 'Quantity must be at least 1';
    }
    if (number > 100) {
      return 'Quantity cannot exceed 100';
    }
    return null;
  }

  /// Validates rate per sqft (0-10000)
  static String? rate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Rate is optional
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Enter a valid rate';
    }
    if (number < 0) {
      return 'Rate cannot be negative';
    }
    if (number > 10000) {
      return 'Rate seems too high';
    }
    return null;
  }
}
