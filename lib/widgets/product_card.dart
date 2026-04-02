import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../screens/product_details_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double? width;

  const ProductCard({super.key, required this.product, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: product.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: AppConstants.getProductImageUrl(
                              product.image,
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                if (product.oldPrice > product.price && product.price > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${((product.oldPrice - product.price) / product.oldPrice * 100).toStringAsFixed(0)}% off',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: AppConstants.primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product.oldPrice > product.price)
                        Text(
                          '₹ ${product.oldPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppConstants.primaryColor,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        side: const BorderSide(
                          color: AppConstants.primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<AppProvider>(
                          context,
                          listen: false,
                        ).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.shopping_cart_outlined, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
