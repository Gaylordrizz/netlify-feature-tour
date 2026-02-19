import 'package:flutter/material.dart';
import '../../services/saved_products_manager.dart';
import '../../screens/product_view/product_view_page.dart';

class SavedProductsPopup extends StatefulWidget {
  final bool showAccountPrompt;
  const SavedProductsPopup({super.key, this.showAccountPrompt = false});

  static void show(BuildContext context, {bool showAccountPrompt = false}) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width < 700 ? double.infinity : 500,
            margin: width < 700 ? const EdgeInsets.symmetric(horizontal: 16, vertical: 32) : null,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SavedProductsPopup(showAccountPrompt: showAccountPrompt),
          ),
        ),
      ),
    );
  }

  @override
  State<SavedProductsPopup> createState() => _SavedProductsPopupState();
}

class _SavedProductsPopupState extends State<SavedProductsPopup> {
  late SavedProductsManager _manager;
  @override
  void initState() {
    super.initState();
    _manager = SavedProductsManager();
    _manager.addListener(_onManagerChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onManagerChanged);
    super.dispose();
  }

  void _onManagerChanged() => setState(() {});

  void _deleteProduct(int index) {
    _manager.removeProductAt(index);
  }


  @override
  Widget build(BuildContext context) {
    final showPrompt = widget.showAccountPrompt;
    final savedProducts = _manager.savedProducts;
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.bookmark, color: Colors.black, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Saved Products',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        // Grid of products
        Expanded(
          child: savedProducts.isEmpty
              ? Center(
                  child: Text(
                    showPrompt
                        ? 'Create a free account to use this feature.'
                        : "No saved products yet! Save a product you like, it will end up here.",
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: savedProducts.length,
                  itemBuilder: (context, index) {
                    final product = savedProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductViewPage(
                              productTitle: product['title'] ?? product['name'] ?? '',
                              productPrice: product['price'] != null && product['price'].toString().isNotEmpty
                                  ? '\$${product['price'].toString().replaceAll(RegExp(r'^[\$]+'), '')}'
                                  : '',
                              // Add more fields if available in product map
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                    child: Icon(Icons.shopping_bag, color: Colors.grey.shade400, size: 32),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'] ?? product['name'] ?? '',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product['price'] != null && product['price'].toString().isNotEmpty
                                            ? '\$${product['price'].toString().replaceAll(RegExp(r'^[\$]+'), '')}'
                                            : '',
                                        style: const TextStyle(fontSize: 11, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                                onPressed: () => _deleteProduct(index),
                                tooltip: 'Delete',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
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
}
