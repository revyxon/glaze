import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  static String formatWithDecimals(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
      decimalDigits: 2,
    );
    return format.format(amount);
  }
}
