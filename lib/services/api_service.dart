import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/login?email_phone=$email&password=$password');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchHomeData() async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/home/en?id=${AppConstants.testId}&token=${AppConstants.testToken}');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchProducts({String? categorySlug}) async {
    // We fetch for a certain category or store, defaulting to "unpolished-pulses" or something if needed
    // according to Postman, by=category&value=...
    final val = categorySlug ?? 'fashion-jonaishub'; // fallback to postman example
    final url = Uri.parse('${AppConstants.apiBaseUrl}/products/en?id=${AppConstants.testId}&token=${AppConstants.testToken}&by=category&value=$val');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchProductDetails(String slug) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/product-details/en/$slug?id=${AppConstants.testId}&token=${AppConstants.testToken}');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
    }
    return null;
  }
}
