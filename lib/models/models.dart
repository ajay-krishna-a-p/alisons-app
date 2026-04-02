class Product {
  final String slug;
  final String name;
  final String image;
  final double price;
  final double oldPrice;

  Product({
    required this.slug,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      oldPrice: double.tryParse(json['oldprice']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class Category {
  final int id;
  final String slug;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
