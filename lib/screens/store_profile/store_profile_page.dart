import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/footer/page_footer.dart';
import '../../services/search_state.dart';
// ignore: unused_import
import '../product_view/product_view_page.dart';

/// StoreProfilePage
///
/// - Top centered title: "Store Profile"
/// - Store name placed under the title
/// - Banner / background photo area with store info
/// - White section below containing an 8-tile square product grid

class StoreProfilePage extends StatefulWidget {
  final String storeName;
  final String? bannerUrl;
  final String? description;
  final String? contactEmail;
  final String? contactAddress;
  final String? contactPostal;
  final String? contactPhone;
  final String? facebookUrl;
  final String? instagramUrl;
  final List<String>? productImages; // list of image URLs (placeholders ok)
  final double? initialRating;
  final String storeDomain; // required: the domain to launch
  final String? storeId;

  const StoreProfilePage({
    super.key,
    this.storeName = 'Store Name',
    this.bannerUrl,
    this.description,
    this.productImages,
    this.initialRating,
    required this.storeDomain,
    this.contactEmail,
    this.contactAddress,
    this.contactPostal,
    this.contactPhone,
    this.facebookUrl,
    this.instagramUrl,
    this.storeId,
  });

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
    void _showStoreRatingDialog() {
      int tempRating = _currentStoreRating.toInt();
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Rate this Store'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tap a star to rate:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < tempRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          tempRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  tempRating > 0 ? '$tempRating ${tempRating == 1 ? 'star' : 'stars'}' : 'No rating selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: tempRating > 0
                    ? () {
                        setState(() {
                          _currentStoreRating = tempRating.toDouble();
                        });
                        Navigator.pop(context);
                        showCustomSnackBar(
                          context,
                          'Thank you for rating this store $tempRating stars!',
                          positive: true,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      );
    }
  bool _isMenuOpen = false;
  // ...existing code...
  // Product ratings are always visible now
  bool _showStoreRating = false; // store rating (banner)
  double _currentStoreRating = 0.0;

  Future<void> _launchStore(String? domain) async {
    if (domain == null || domain.isEmpty) return;
    String url = domain.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open store website.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentStoreRating = widget.initialRating ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();
    final images = widget.productImages ?? [];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final crossAxisCount = width >= 900 ? 5 : (width >= 600 ? 4 : 3);
    // Remove test/sample product tiles: Only show tiles if real product data is provided
    // Only show product tiles if there are real product images
    final productTiles = images
      .where((img) => img.isNotEmpty)
      .map<Widget>((imageUrl) => _ProductTile(
          title: '',
          imageUrl: imageUrl,
          price: '',
          rating: 0.0,
          showRating: false,
        ))
      .toList();

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Store Profile',
        productSearchController: searchState.productSearchController,
        storeSearchController: searchState.storeSearchController,
        onProductSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        onStoreSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large store banner photo - 70% of screen height, sharp corners
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: height * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    image: widget.bannerUrl != null && widget.bannerUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.bannerUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: null,
                ),
                // Store name overlay at bottom - centered, no background
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        widget.storeName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      if (widget.description != null && widget.description!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.description!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 19.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 6,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showStoreRating = !_showStoreRating;
                              });
                            },
                            icon: Icon(_showStoreRating ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                            label: Text(_showStoreRating ? 'Hide Store Rating' : 'Show Store Rating', style: const TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(foregroundColor: Colors.white),
                          ),
                          if (_showStoreRating) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.star, color: Colors.amber, size: 24, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                            const SizedBox(width: 4),
                            Text(
                              _currentStoreRating.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 6,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Main Visit Store button - overlayed at bottom right corner
                Positioned(
                  bottom: _isMenuOpen && width < 768 ? 280 : (width < 768 ? 16 : 24),
                  right: width < 768 ? 12 : 16,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width < 400 ? width * 0.9 : 400),
                    child: ElevatedButton(
                      onPressed: () => _launchStore(widget.storeDomain),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: width < 768 ? 24 : 40,
                          vertical: width < 768 ? 16 : 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Visit ${widget.storeName}',
                              style: TextStyle(fontSize: width < 768 ? 14 : 18),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(width: width < 768 ? 8 : 12),
                          Icon(Icons.arrow_forward, size: width < 768 ? 16 : 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Store ID display
            if (widget.storeId != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'Store ID: ${widget.storeId}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // White section with rounded top corners for product tiles and store info
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Product grid: only show if there are real products, otherwise show nothing or a message
                    if (productTiles.isNotEmpty)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.65,
                        children: productTiles,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'No products to display.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Store Info Section
                    const Text(
                      'Store Info',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.store, color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.storeName,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.language, color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.storeDomain,
                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.confirmation_number, color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Store ID: ${widget.storeId ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.facebookUrl != null && widget.facebookUrl!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _launchStore(widget.facebookUrl),
                                child: const Row(
                                  children: [
                                    Icon(Icons.facebook, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text('Facebook', style: TextStyle(fontSize: 15, color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                            if (widget.instagramUrl != null && widget.instagramUrl!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _launchStore(widget.instagramUrl),
                                child: const Row(
                                  children: [
                                    Icon(Icons.camera_alt, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text('Instagram', style: TextStyle(fontSize: 15, color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Text('About Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(
                              widget.description ?? 'No description provided.',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Store Rating Section
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Store Rating',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < _currentStoreRating.floor() ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 24,
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  Text(
                                    _currentStoreRating > 0 ? _currentStoreRating.toInt().toString() : 'No ratings yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 80,
                            child: ElevatedButton.icon(
                              onPressed: _showStoreRatingDialog,
                              icon: const Icon(Icons.star_rate, size: 18),
                              label: const Text('Rate'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Visit store message and button row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: width < 768
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Visit ${widget.storeName} to purchase its products',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 12),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 0, maxWidth: 400),
                                  child: ElevatedButton(
                                    onPressed: () => _launchStore(widget.storeDomain),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Visit ${widget.storeName}',
                                            style: const TextStyle(fontSize: 16),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Visit ${widget.storeName} to purchase its products',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 0, maxWidth: 400),
                                  child: ElevatedButton(
                                    onPressed: () => _launchStore(widget.storeDomain),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Visit ${widget.storeName}',
                                            style: const TextStyle(fontSize: 18),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.arrow_forward, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Footer
            const PageFooter(),
          ],
        ),
      ),
    );
  }

  // ...existing code...

  // ...existing code...
}

class _ProductTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String price;
  final double rating;
  final bool showRating;

  const _ProductTile({
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
    this.showRating = true,
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
                  // Rating removed from product thumbnail
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
