import 'package:flutter/material.dart';

class AppConstants {
  static const String apiBaseUrl = 'https://sungod.demospro2023.in.net/api';
  static const String imageBaseUrl = 'https://sungod.demospro2023.in.net';

  static String testId = '80y';
  static String testToken = 'ZLyKKL30tpLYkclzTvZSXeeKBDRO8TSzx02iPyXT';

  // Colors
  static const Color primaryColor = Color(0xFF87350F);
  static const Color backgroundColor = Color(0xFFF8F7F5);
  static const Color textColor = Color(0xFF1E1E1E);
  static const Color hintColor = Color(0xFF9E9E9E);

  static String getBannerImageUrl(String filename) {
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/banner/$filename';
  }

  static String getProductImageUrl(String filename) {
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/product/$filename';
  }

  static String getCategoryImageUrl(String filename) {
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/category/$filename';
  }
}
