import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wishlist_item.dart';
import '../models/user.dart';

class ApiService {
  // GANTI INI DENGAN IP KOMPUTER KAMU
  static const String baseUrl = 'http://192.168.43.50/shopping-wishlist-api';

  // Helper method untuk headers
  static Map<String, String> getHeaders({bool includeAuth = false}) {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (includeAuth) {
      // TODO: Tambahkan token authentication nanti
      // headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ============ AUTHENTICATION APIs ============

  // Register user dengan error handling lebih baik
  static Future<Map<String, dynamic>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      print('Sending register request to: $baseUrl/auth/register.php');
      print('Data: username=$username, email=$email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register.php'),
            headers: getHeaders(),
            body: json.encode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Register Response Status: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ??
              'Registration failed (Status: ${response.statusCode})',
        );
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error: $e');
      throw Exception('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw Exception('Request timeout. Check your connection and server.');
    } on FormatException catch (e) {
      print('JSON Format Error: $e');
      throw Exception(
        'Server response format error. Response might be HTML instead of JSON.',
      );
    } catch (e) {
      print('Unknown Error in registerUser: $e');
      rethrow;
    }
  }

  // Login user dengan error handling lebih baik
  static Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    try {
      print('Sending login request for user: $username');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login.php'),
            headers: getHeaders(),
            body: json.encode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ??
              'Login failed (Status: ${response.statusCode})',
        );
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error in login: $e');
      throw Exception('Network error: ${e.message}');
    } on TimeoutException {
      throw Exception('Request timeout. Check your connection.');
    } on FormatException catch (e) {
      print('Login JSON Format Error: $e');
      throw Exception('Server response format error.');
    } catch (e) {
      print('Unknown Error in loginUser: $e');
      rethrow;
    }
  }

  // ============ CATEGORIES APIs ============

  // Get all categories dengan error handling
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/categories.php'), headers: getHeaders())
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
          'Failed to load categories (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error loading categories: $e');
      rethrow;
    }
  }

  // ============ WISHLIST ITEMS APIs ============

  // Get all wishlist items for a user
  static Future<List<WishlistItem>> getWishlistItems(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/wishlist.php?user_id=$userId'),
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WishlistItem.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load wishlist items (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error loading wishlist items: $e');
      rethrow;
    }
  }

  // Add new wishlist item
  static Future<WishlistItem> addWishlistItem(
    int userId,
    WishlistItem item,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/wishlist.php'),
            headers: getHeaders(),
            body: json.encode({
              'user_id': userId,
              'name': item.name,
              'price': item.price,
              'category': item.category,
              'priority': item.priority,
              'product_url': item.productUrl ?? '',
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        // Buat WishlistItem baru dengan ID dari server
        return WishlistItem(
          id: int.tryParse(data['item_id']?.toString() ?? '0'),
          name: item.name,
          price: item.price,
          category: item.category,
          priority: item.priority,
          productUrl: item.productUrl,
          isBought: false,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception(
          'Failed to add wishlist item (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error adding wishlist item: $e');
      rethrow;
    }
  }

  // Update wishlist item
  static Future<void> updateWishlistItem(WishlistItem item) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/wishlist.php'),
            headers: getHeaders(),
            body: json.encode({
              'id': item.id,
              'name': item.name,
              'price': item.price,
              'category': item.category,
              'priority': item.priority,
              'product_url': item.productUrl ?? '',
              'is_bought': item.isBought ? 1 : 0,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update wishlist item (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error updating wishlist item: $e');
      rethrow;
    }
  }

  // Delete wishlist item
  static Future<void> deleteWishlistItem(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/wishlist.php'),
            headers: getHeaders(),
            body: json.encode({'id': id}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete wishlist item (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error deleting wishlist item: $e');
      rethrow;
    }
  }

  // ============ BUDGET APIs ============

  // Get user budget
  static Future<double> getBudget(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/budget.php?user_id=$userId'),
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return double.tryParse(data['monthly_budget']?.toString() ?? '0') ??
            0.0;
      } else {
        throw Exception(
          'Failed to load budget (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error loading budget: $e');
      rethrow;
    }
  }

  // Set/Update user budget
  static Future<void> setBudget(int userId, double budget) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/budget.php'),
            headers: getHeaders(),
            body: json.encode({'user_id': userId, 'monthly_budget': budget}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to set budget (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error setting budget: $e');
      rethrow;
    }
  }

  // ============ UTILITY METHODS ============

  // Test connection to server
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/categories.php'), headers: getHeaders())
          .timeout(const Duration(seconds: 5));

      print('Connection test response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Get total wishlist price from server
  static Future<double> getTotalWishlistPrice(int userId) async {
    try {
      final items = await getWishlistItems(userId);
      double total = 0.0;

      for (var item in items) {
        if (!item.isBought) {
          total += item.price;
        }
      }

      return total;
    } catch (e) {
      print('Error calculating total price: $e');
      return 0.0;
    }
  }

  // Test API dengan semua endpoints
  static Future<Map<String, dynamic>> testAllApis() async {
    final results = <String, dynamic>{};

    try {
      // Test connection
      results['connection'] = await testConnection();

      if (results['connection']) {
        // Test categories
        try {
          final categories = await getCategories();
          results['categories'] = 'OK (${categories.length} items)';
        } catch (e) {
          results['categories'] = 'FAILED: $e';
        }

        // Test register
        try {
          final testUsername = 'test${DateTime.now().millisecondsSinceEpoch}';
          final testEmail =
              'test${DateTime.now().millisecondsSinceEpoch}@example.com';

          await registerUser(testUsername, testEmail, 'test123');
          results['register'] = 'OK';
        } catch (e) {
          results['register'] = 'FAILED: $e';
        }
      }
    } catch (e) {
      results['overall'] = 'FAILED: $e';
    }

    return results;
  }
}
