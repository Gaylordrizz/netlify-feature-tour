import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../services/search_state.dart';
import '../../services/history_manager.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();
    final products = HistoryManager().productHistory;
    final stores = HistoryManager().storeHistory;

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Your History',
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Product History
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag, color: Colors.blue, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Product History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Products you\'ve viewed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: products.isEmpty
                          ? _buildEmptyState('No products viewed yet', Icons.shopping_bag_outlined)
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    title: Text(
                                      product['title']!,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(product['price']!),
                                    // trailing: IconButton(
                                    //   icon: const Icon(Icons.close, size: 20),
                                    //   onPressed: () {
                                    //     // TODO: Remove from history
                                    //   },
                                    // ),
                                    onTap: () {
                                      // TODO: Navigate to product view
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Right: Store History
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.blue, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Store History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stores you\'ve visited',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: stores.isEmpty
                          ? _buildEmptyState('No stores visited yet', Icons.store_outlined)
                          : ListView.builder(
                              itemCount: stores.length,
                              itemBuilder: (context, index) {
                                final store = stores[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.store,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    title: Text(
                                      store['name']!,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(store['domain']!),
                                    // trailing: IconButton(
                                    //   icon: const Icon(Icons.close, size: 20),
                                    //   onPressed: () {
                                    //     // TODO: Remove from history
                                    //   },
                                    // ),
                                    onTap: () {
                                      // TODO: Navigate to store profile
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
