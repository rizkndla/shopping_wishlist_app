import 'dart:ui';

class AppConfig {
  // ============ API CONFIGURATION ============

  // Base URL untuk API (GANTI dengan IP komputer kamu)
  static const String baseUrl = 'http://192.168.43.50/shopping_wishlist_api';

  // Fallback URL untuk testing
  static const String localBaseUrl = 'http://localhost/shopping_wishlist_app';
  static const String emulatorBaseUrl = 'http://10.0.2.2/shopping_wishlist_app';

  // API Timeout (dalam detik)
  static const int apiTimeoutSeconds = 15;
  static const int apiConnectTimeout = 10;
  static const int apiReceiveTimeout = 15;

  // ============ APP CONFIGURATION ============

  static const String appName = 'Shopping Wishlist';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Manage your shopping dreams';

  // App Colors
  static const Color primaryColor = Color(0xFF325eba);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFeae6e0);
  static const Color surfaceColor = Color(0xFFf7f4f0);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // ============ DATABASE CONFIGURATION ============

  static const String dbName = 'wishlist_app.db';
  static const int dbVersion = 1;

  // ============ SHARED PREFERENCES KEYS ============

  static const String prefIsLoggedIn = 'isLoggedIn';
  static const String prefUserId = 'userId';
  static const String prefUsername = 'username';
  static const String prefEmail = 'email';
  static const String prefToken = 'token';
  static const String prefMonthlyBudget = 'monthlyBudget';
  static const String prefFirstLaunch = 'firstLaunch';
  static const String prefThemeMode = 'themeMode';

  // ============ CATEGORIES CONFIGURATION ============

  static List<Map<String, dynamic>> get defaultCategories {
    return [
      {'id': 1, 'name': 'Electronics', 'icon': '📱', 'color': '#4285F4'},
      {'id': 2, 'name': 'Fashion', 'icon': '👕', 'color': '#EA4335'},
      {'id': 3, 'name': 'Books', 'icon': '📚', 'color': '#FBBC05'},
      {'id': 4, 'name': 'Food & Drinks', 'icon': '🍔', 'color': '#34A853'},
      {'id': 5, 'name': 'Hobbies', 'icon': '🎨', 'color': '#9C27B0'},
      {'id': 6, 'name': 'Home', 'icon': '🏠', 'color': '#FF9800'},
      {'id': 7, 'name': 'Sports', 'icon': '⚽', 'color': '#795548'},
      {'id': 8, 'name': 'Beauty', 'icon': '💄', 'color': '#E91E63'},
      {'id': 9, 'name': 'Health', 'icon': '🏥', 'color': '#00BCD4'},
      {'id': 10, 'name': 'Other', 'icon': '📦', 'color': '#9E9E9E'},
    ];
  }

  // ============ PRIORITY CONFIGURATION ============

  static List<Map<String, dynamic>> get priorityOptions {
    return [
      {
        'value': 'high',
        'label': 'High',
        'color': '#FF5252',
        'icon': '⭐',
        'sortOrder': 1,
      },
      {
        'value': 'medium',
        'label': 'Medium',
        'color': '#FFB74D',
        'icon': '🔶',
        'sortOrder': 2,
      },
      {
        'value': 'low',
        'label': 'Low',
        'color': '#4CAF50',
        'icon': '🔷',
        'sortOrder': 3,
      },
    ];
  }

  // ============ CURRENCY CONFIGURATION ============

  static const String currencySymbol = 'Rp';
  static const String currencyCode = 'IDR';
  static const int decimalDigits = 0;
  static const String thousandSeparator = '.';
  static const String decimalSeparator = ',';

  // ============ VALIDATION CONFIGURATION ============

  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 6;
  static const int maxItemNameLength = 100;
  static const double maxPriceValue = 999999999.99;

  // ============ CACHE CONFIGURATION ============

  static const int cacheDurationHours = 1;
  static const int maxCachedItems = 100;

  // ============ NOTIFICATION CONFIGURATION ============

  static const String notificationChannelId = 'wishlist_notifications';
  static const String notificationChannelName = 'Wishlist Reminders';
  static const String notificationChannelDescription =
      'Reminders for your wishlist items';

  // ============ FEATURE FLAGS ============

  static const bool enableOfflineMode = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = false;
  static const bool enableDebugLogs = true;

  // ============ URLS ============

  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@shoppingwishlist.com';

  // ============ HELPER METHODS ============

  // Format currency
  static String formatCurrency(double amount) {
    if (amount.isInfinite || amount.isNaN) return '$currencySymbol 0';

    String amountStr = amount.toStringAsFixed(decimalDigits);
    List<String> parts = amountStr.split('.');

    // Format bagian ribuan
    String integerPart = parts[0];
    String formattedInteger = '';
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      formattedInteger = integerPart[i] + formattedInteger;
      count++;
      if (count == 3 && i > 0) {
        formattedInteger = thousandSeparator + formattedInteger;
        count = 0;
      }
    }

    // Gabung dengan decimal jika ada
    if (parts.length > 1 && parts[1] != '00') {
      return '$currencySymbol $formattedInteger$decimalSeparator${parts[1]}';
    }

    return '$currencySymbol $formattedInteger';
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    final option = priorityOptions.firstWhere(
      (opt) => opt['value'] == priority,
      orElse: () => priorityOptions[1], // Default medium
    );

    return _hexToColor(option['color'] as String);
  }

  // Get priority icon
  static String getPriorityIcon(String priority) {
    final option = priorityOptions.firstWhere(
      (opt) => opt['value'] == priority,
      orElse: () => priorityOptions[1], // Default medium
    );

    return option['icon'] as String;
  }

  // Convert hex to Color
  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate password
  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  // Get category by ID
  static Map<String, dynamic>? getCategoryById(int id) {
    try {
      return defaultCategories.firstWhere((cat) => cat['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  static Map<String, dynamic>? getCategoryByName(String name) {
    try {
      return defaultCategories.firstWhere((cat) => cat['name'] == name);
    } catch (e) {
      return null;
    }
  }

  // Debug print (hanya tampil jika debug mode aktif)
  static void debugPrint(String message) {
    if (enableDebugLogs) {
      print('🛍️ [Wishlist Debug]: $message');
    }
  }

  // Get current base URL berdasarkan platform
  static String getCurrentBaseUrl() {
    // TODO: Implement logic untuk detect platform
    // Untuk sekarang return baseUrl utama
    return baseUrl;
  }
}

// ============ APP CONSTANTS ============

class AppConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 50.0;
  static const double appBarHeight = 56.0;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);

  static const List<double> budgetPresets = [
    100000,
    250000,
    500000,
    1000000,
    2500000,
    5000000,
  ];

  static const List<String> imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
  ];
}

// ============ APP ROUTES ============

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String wishlist = '/wishlist';
  static const String addItem = '/add-item';
  static const String editItem = '/edit-item';
  static const String budget = '/budget';
  static const String settings = '/settings';
  static const String about = '/about';
}

// ============ APP ASSETS ============

class AppAssets {
  static const String logo = 'assets/logo.png';
  static const String logoTransparent = 'assets/logo_transparent.png';
  static const String emptyWishlist = 'assets/empty_wishlist.png';
  static const String success = 'assets/success.png';
  static const String error = 'assets/error.png';
  static const String background = 'assets/background.png';

  // Icons
  static const String iconApp = 'assets/icons/app_icon.png';
  static const String iconBudget = 'assets/icons/budget.png';
  static const String iconCategory = 'assets/icons/category.png';
  static const String iconPriority = 'assets/icons/priority.png';
}
