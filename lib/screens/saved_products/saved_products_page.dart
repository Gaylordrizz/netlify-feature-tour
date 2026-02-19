// DEPRECATED: Do not use this file until further notice.
// This page is deprecated in favor of the popup version.
import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../services/search_state.dart';

class SavedProductsPage extends StatelessWidget {
  const SavedProductsPage({super.key});

  // Sample saved products data
  List<Map<String, String>> _sampleSavedProducts() => List.generate(
        20,
        (i) => {
          'title': 'Saved Product ${i + 1}',
          'price': '\$${(i + 1) * 15}.99',
          'image': '',
        },
      );

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();
    final products = _sampleSavedProducts();
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1200 ? 5 : (width >= 900 ? 4 : 3);

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Saved Products',
        productSearchController: searchState.productSearchController,
        storeSearchController: searchState.storeSearchController,
        onProductSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        onStoreSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bookmark, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Your Saved Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${products.length} items',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No saved products yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start saving products to view them here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Product Image
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            size: 48,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                      // Remove bookmark button
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.bookmark, color: Colors.blue),
                                            iconSize: 20,
                                            onPressed: () {
                                              // TODO: Remove from saved products
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Product Info
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['price']!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
