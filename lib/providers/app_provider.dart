import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoadingHome = false;
  bool isLoadingProducts = false;
  String? errorMessage;

  List<Category> categories = [];
  List<Product> newArrivals = [];
  List<Product> featuredProducts = [];
  List<Product> currentProducts = [];
  List<dynamic> banners = [];

  // Cart
  List<CartItem> cart = [];

  int get cartItemCount => cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal =>
      cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  Future<void> loadHomeData() async {
    isLoadingHome = true;
    errorMessage = null;
    notifyListeners();

    final data = await _apiService.fetchHomeData();
    if (data != null && data['success'] == 1) {
      if (data['categories'] != null) {
        categories = (data['categories'] as List)
            .map((e) => Category.fromJson(e['category']))
            .toList();
      }
      if (data['newarrivals'] != null) {
        newArrivals = (data['newarrivals'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      }

      // we'll treat new arrivals as featured/popular just as mock since we need lists
      featuredProducts = newArrivals;

      if (data['banner1'] != null) {
        banners = data['banner1'];
      }
    } else {
      errorMessage = 'Failed to load home data';
    }

    isLoadingHome = false;
    notifyListeners();
  }

  Future<void> loadProducts(String slug) async {
    isLoadingProducts = true;
    currentProducts = [];
    notifyListeners();

    final data = await _apiService.fetchProducts(categorySlug: slug);
    if (data != null && data['success'] == 1 && data['products'] != null) {
      currentProducts = (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      final homeData = await _apiService.fetchHomeData();
      if (homeData != null && homeData['newarrivals'] != null) {
        currentProducts = (homeData['newarrivals'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        errorMessage = 'Failed to load products';
      }
    }

    isLoadingProducts = false;
    notifyListeners();
  }

  void addToCart(Product product, {int qty = 1}) {
    final index = cart.indexWhere((item) => item.product.slug == product.slug);
    if (index >= 0) {
      cart[index].quantity += qty;
    } else {
      cart.add(CartItem(product: product, quantity: qty));
    }
    notifyListeners();
  }

  void updateCartQuantity(Product product, bool increase) {
    final index = cart.indexWhere((item) => item.product.slug == product.slug);
    if (index >= 0) {
      if (increase) {
        cart[index].quantity++;
      } else {
        cart[index].quantity--;
        if (cart[index].quantity <= 0) {
          cart.removeAt(index);
        }
      }
      notifyListeners();
    }
  }
}
