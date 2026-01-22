class AppData {
  // Formula Constants
  static const double divisionFactor =
      90903.0; // Standard for all user calculations
  static const double adminDivisionFactor =
      92903.04; // Admin/Bonus calculations only

  // Frameworks
  static const List<String> frameworks = ['Inventa', 'Optima'];

  // Glass Types
  static const List<String> glassTypes = [
    '5MM Clear Glass',
    '5MM Toughened Glass',
    '5MM Clear Toughened Glass',
    '5MM Frosted Glass',
    '5MM Frosted Toughened Glass',
    '5MM Reflective Glass',
  ];

  // Window Types
  static const List<WindowType> windowTypes = [
    WindowType(code: '3T', name: '3 Track Window'),
    WindowType(code: '2T', name: '2 Track Window'),
    WindowType(code: 'V', name: 'Ventilation Window'),
    WindowType(code: 'FIX', name: 'Fixed Window'),
    WindowType(code: 'OP', name: 'Openable Window'),
    WindowType(code: 'LC', name: 'L-Corner', requiresWidth2: true),
    WindowType(code: 'TT', name: 'Tilt & Turn'),
    WindowType(code: 'TH', name: 'Top Hung'),
    WindowType(code: 'SD', name: 'Sliding Door'),
    WindowType(code: 'CUST', name: 'Custom Window', isCustom: true),
  ];

  static String getWindowName(String code) {
    if (code == 'CUST') {
      return 'Custom Window';
    }
    return windowTypes
        .firstWhere(
          (t) => t.code == code,
          orElse: () => WindowType(code: code, name: code),
        )
        .name;
  }
}

class WindowType {
  final String code;
  final String name;
  final bool requiresWidth2;
  final bool isCustom;

  const WindowType({
    required this.code,
    required this.name,
    this.requiresWidth2 = false,
    this.isCustom = false,
  });

  static const String lCorner = 'LC';
  static const String custom = 'CUST';
}
