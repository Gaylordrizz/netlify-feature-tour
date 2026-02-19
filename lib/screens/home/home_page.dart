import 'package:flutter/material.dart';

import '../product_view/product_view_page.dart';
import '../store_profile/store_profile_page.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../services/search_state.dart';
import '../../services/store_service.dart';
import '../../services/product_service_all.dart';
// ignore: unused_import
import '../../algorithem/algorithm_home_products.dart' as product_algo;
// ignore: unused_import
import '../../algorithem/algorithm_home_stores.dart' as store_algo;
import 'package:shared_preferences/shared_preferences.dart';

import '../../reusable_widgets/popups/account_created_popup.dart';
import '../../services/loading_spinner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  bool _showAccountCreatedPopup = false;
  bool _checkedInitialPopup = false;
  String? _selectedCategory;
  bool _handledInitialSearch = false;
  bool _loading = true;
  String? _fetchError;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _stores = [];
  String _productSearchQuery = '';
  String _storeSearchQuery = '';
  final _searchState = SearchState();

  // --- Algorithm Integration Example ---
  // Use product_algo.getPersonalizedHomeProducts and store_algo.getPersonalizedHomeStores
  // to fetch and rank products/stores for the home page.
  // See algorithm_home_products.dart and algorithm_home_stores.dart for details.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledInitialSearch) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (args['productSearch'] != null && args['productSearch'] is String) {
        final searchTerm = args['productSearch'] as String;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _searchState.productSearchController.text = searchTerm;
            setState(() {
              _productSearchQuery = searchTerm;
            });
          }
        });
        _handledInitialSearch = true;
      } else if (args['storeSearch'] != null && args['storeSearch'] is String) {
        final searchTerm = args['storeSearch'] as String;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _searchState.storeSearchController.text = searchTerm;
            setState(() {
              _storeSearchQuery = searchTerm;
            });
          }
        });
        _handledInitialSearch = true;
      }
    }
  }

  // Filter states

  // Removed controller listeners so search only happens on Enter or search icon

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Check for account creation deep link (from Supabase email confirmation)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_checkedInitialPopup) {
        final uri = Uri.base;
        if ((uri.queryParameters['type'] == 'email_confirmation' || uri.queryParameters['type'] == 'signup') &&
            (await _shouldShowAccountCreatedPopup())) {
          setState(() {
            _showAccountCreatedPopup = true;
            _checkedInitialPopup = true;
          });
        }
      }
    });
  }

  Future<bool> _shouldShowAccountCreatedPopup() async {
    // Use shared_preferences or similar to persist flag
    // Only show if not shown before
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('storazaar_account_created_popup_shown') == true) return false;
      await prefs.setBool('storazaar_account_created_popup_shown', true);
      return true;
    } catch (_) {
      return true; // fallback: show if error
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _fetchError = null;
    });
    try {
      final products = await ProductService.fetchAllProducts();
      final stores = await StoreService.fetchAllStores();
      setState(() {
        _products = products;
        _stores = stores;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _fetchError = 'Failed to fetch data: $e';
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> _filterProducts(String query) {
    var products = _products;
    if (query.isNotEmpty) {
      products = products
          .where((product) => product['title']?.toString().toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    // Category filter (now uses _selectedCategory)
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      products = products
          .where((product) => product['category']?.toString().toLowerCase() == _selectedCategory!.toLowerCase())
          .toList();
    }
    return products;
  }

  List<Map<String, dynamic>> _filterStores(String query) {
    var stores = _stores;
    if (query.isNotEmpty) {
      stores = stores
          .where((store) =>
              store['store_name']?.toLowerCase().contains(query.toLowerCase()) ?? false ||
              store['domain']?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    return stores;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filterProducts(_productSearchQuery);
    final stores = _filterStores(_storeSearchQuery);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final crossAxisCount = width >= 1200
        ? 4
        : width >= 900
            ? 3
            : width >= 600
                ? 2
                : 1;

    return Stack(
      children: [
        Scaffold(
          drawer: const GlobalSidebarDrawer(),
          appBar: GlobalHeader(
            title: 'WELCOME TO STORAZAAR',
            productSearchController: _searchState.productSearchController,
            storeSearchController: _searchState.storeSearchController,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
            // onFiltersApplied: (filters) {},
            onProductSearch: (query) {
              setState(() {
                _productSearchQuery = query;
              });
            },
            onStoreSearch: (query) {
              setState(() {
                _storeSearchQuery = query;
              });
            },
          ),
            body: _loading
              ? const PageLoadingSpinner()
              : _fetchError != null
                ? Center(child: Text(_fetchError!, style: TextStyle(color: Colors.red)))
                : isMobile
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Products column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        final item = products[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductViewPage(
                                                    productTitle: item['title']?.toString() ?? '',
                                                    productPrice: item['price'] != null ? '\$${item['price']}' : null,
                                                    productDescription: item['description']?.toString(),
                                                    storeName: item['store_domain']?.toString() ?? '',
                                                    storeDomain: item['store_domain']?.toString() ?? '',
                                                    initialRating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                                                    category: item['category']?.toString(),
                                                    condition: item['condition']?.toString(),
                                                    brand: item['brand']?.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: _ProductTile(
                                              title: item['title']?.toString() ?? '',
                                              imageUrl: item['image']?.toString() ?? '',
                                              price: item['price'] != null ? '\$${item['price']}' : '',
                                              rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Vertical divider
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: Colors.black,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            // Stores column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Stores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: stores.length,
                                      itemBuilder: (context, index) {
                                        final s = stores[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StoreProfilePage(
                                                    storeName: s['store_name']?.toString() ?? '',
                                                    storeDomain: s['domain']?.toString() ?? '',
                                                    description: s['about']?.toString(),
                                                    bannerUrl: s['banner_url']?.toString() ?? '',
                                                    initialRating: (s['rating'] as num?)?.toDouble() ?? 0.0,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: _StoreThumbnail(
                                              name: s['store_name']?.toString() ?? '',
                                              domain: s['domain']?.toString() ?? '',
                                              imageUrl: s['banner_url']?.toString() ?? '',
                                              rating: (s['rating'] as num?)?.toDouble() ?? 0.0,
                                            ),
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
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left: Products (60%)
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        ),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                              childAspectRatio: 0.65,
                                            ),
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              final item = products[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ProductViewPage(
                                                        productTitle: item['title']?.toString() ?? '',
                                                        productPrice: item['price'] != null ? '\$${item['price']}' : null,
                                                        productDescription: item['description']?.toString(),
                                                        storeName: item['store_domain']?.toString() ?? '',
                                                        storeDomain: item['store_domain']?.toString() ?? '',
                                                        initialRating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                                                        category: item['category']?.toString(),
                                                        condition: item['condition']?.toString(),
                                                        brand: item['brand']?.toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: _ProductTile(
                                                  title: item['title']?.toString() ?? '',
                                                  imageUrl: item['image']?.toString() ?? '',
                                                  price: item['price'] != null ? '\$${item['price']}' : '',
                                                  rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Vertical divider line
                                  Container(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 12),
                                  // Right: Stores (40%)
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Stores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: stores.length,
                                            itemBuilder: (context, index) {
                                              final s = stores[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => StoreProfilePage(
                                                          storeName: s['store_name']?.toString() ?? '',
                                                          storeDomain: s['domain']?.toString() ?? '',
                                                          description: s['about']?.toString(),
                                                          bannerUrl: s['banner_url']?.toString() ?? '',
                                                          initialRating: (s['rating'] as num?)?.toDouble() ?? 0.0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: _StoreThumbnail(
                                                    name: s['store_name']?.toString() ?? '',
                                                    domain: s['domain']?.toString() ?? '',
                                                    imageUrl: s['banner_url']?.toString() ?? '',
                                                    rating: (s['rating'] as num?)?.toDouble() ?? 0.0,
                                                  ),
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
                        ),
                      ],
                    ),
        ),
        if (_showAccountCreatedPopup)
          Builder(
            builder: (context) => AccountCreatedPopup(
              onClose: () {
                setState(() {
                  _showAccountCreatedPopup = false;
                });
              },
            ),
          ),
      ],
    );
  }
}


class _ProductTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String price;
  final double rating;

  const _ProductTile({
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product photo
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? const Center(child: Icon(Icons.image, size: 40, color: Colors.grey))
                  : null,
            ),
          ),
          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Text(
                        rating.toInt().toString(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreThumbnail extends StatelessWidget {
  final String name;
  final String domain;
  final String? imageUrl;
  final double rating;

  const _StoreThumbnail({
    required this.name,
    required this.domain,
    this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 700;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      image: (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: (imageUrl == null || imageUrl!.isEmpty) ? const Icon(Icons.store, color: Colors.grey) : null,
                  ),
                  const SizedBox(height: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toInt().toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(domain, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 28,
                    semanticLabel: 'Verified Store',
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      image: (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: (imageUrl == null || imageUrl!.isEmpty) ? const Icon(Icons.store, color: Colors.grey) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              rating.toInt().toString(),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(domain, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  // Green check verification icon
                  const SizedBox(width: 8),
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 28,
                    semanticLabel: 'Verified Store',
                  ),
                ],
              ),
      ),
    );
  }
}