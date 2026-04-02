import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../providers/app_provider.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import 'product_list_page.dart';
import 'cart_page.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ScrollController _categoriesScrollController = ScrollController();
  final ScrollController _featuredProductsScrollController = ScrollController();
  final ScrollController _bestSellingScrollController = ScrollController();

  @override
  void dispose() {
    _categoriesScrollController.dispose();
    _featuredProductsScrollController.dispose();
    _bestSellingScrollController.dispose();
    super.dispose();
  }

  void _scrollList(ScrollController controller, bool right) {
    if (controller.hasClients) {
      final double offset = right
          ? controller.offset + 200
          : controller.offset - 200;
      controller.animateTo(
        offset.clamp(0.0, controller.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 2) {
      return const CartPage();
    }

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: AppConstants.primaryColor,
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/beautiful-unique-logo-design-ecommerce-retail-company_1287271-9935-removebg-preview 1.png',
                    height: 40,
                  ),
                  const Spacer(),
                  Image.asset('assets/mynaui_search.png', height: 40),
                  Image.asset('assets/ph_heart.png', height: 40),
                  Image.asset('assets/Vector.png', height: 40),
                ],
              ),
            )
          : AppBar(title: const Text('Comming Soon')),
      body: _currentIndex == 0
          ? _buildHomeBody()
          : const Center(child: Text('Coming Soon')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home-alt-svgrepo-com 1.png')),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/tabler_category.png')),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ImageIcon(AssetImage('assets/solar_cart-3-linear.png')),
                    if (provider.cartItemCount > 0)
                      Positioned(
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
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/solar_user-linear.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingHome) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadHomeData(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(provider.banners),
                _buildCategories(
                  provider.categories,
                  _categoriesScrollController,
                ),
                _buildSectionTitle(
                  'Featured Products',
                  _featuredProductsScrollController,
                ),
                _buildProductList(
                  provider.featuredProducts,
                  _featuredProductsScrollController,
                ),
                _buildSectionTitle(
                  'Daily Best Selling',
                  _bestSellingScrollController,
                ),
                _buildProductList(
                  provider.featuredProducts.reversed.toList(),
                  _bestSellingScrollController,
                ),
                // Add more sections as needed matching the UI
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner(List<dynamic> banners) {
    if (banners.isEmpty) return const SizedBox();
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    AppConstants.getBannerImageUrl(banner['image']),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategories(
    List<Category> categories,
    ScrollController controller,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _scrollList(controller, false),
                    child: const Icon(Icons.chevron_left, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _scrollList(controller, true),
                    child: const Icon(Icons.chevron_right, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage(category: category),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipOval(
                          child: category.image.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: AppConstants.getCategoryImageUrl(
                                    category.image,
                                  ),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                )
                              : const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ScrollController controller) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => _scrollList(controller, false),
                child: const Icon(Icons.chevron_left, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _scrollList(controller, true),
                child: const Icon(Icons.chevron_right, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
    List<Product> products,
    ScrollController controller,
  ) {
    if (products.isEmpty) return const Center(child: Text('No products '));
    return SizedBox(
      height: 250,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ProductCard(product: products[index], width: 140),
          );
        },
      ),
    );
  }
}
