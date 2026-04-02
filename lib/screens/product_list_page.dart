import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  final Category category;

  const ProductListPage({super.key, required this.category});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadProducts(widget.category.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.name,
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Text(
                  '${provider.currentProducts.length} Items',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    if (provider.cartItemCount == 0) return const SizedBox();
                    return Positioned(
                      right: -5,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.cartItemCount}',
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingProducts) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.currentProducts.isEmpty) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.currentProducts.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: provider.currentProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: provider.currentProducts[index]);
                  },
                ),
              ),
              // Bottom Sort / Filter row as in design limit to basic UI
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, offset: const Offset(0, -1), blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.sort, color: Colors.black),
                        label: const Text('Sort By', style: TextStyle(color: Colors.black)),
                        onPressed: () {},
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.grey.shade300),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
                        label: const Text('Filter', style: TextStyle(color: Colors.black)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
