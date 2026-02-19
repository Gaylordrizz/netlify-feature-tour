import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../reusable_widgets/footer/page_footer.dart';
import '../../services/search_state.dart';
import '../store_profile/store_profile_page.dart';

class ProductViewPage extends StatefulWidget {
  final String productTitle;
  final String? productPrice;
  final String? productDescription;
  final String? storeName;
  final String? storeDomain;
  final List<String>? productImages; // main image + thumbnails
  final VoidCallback? onVisitStore;
  final double? initialRating;
  final String? category;
  final String? condition;
  final String? brand;
  final String? publicId;

  const ProductViewPage({
    super.key,
    this.productTitle = 'Product Title',
    this.productPrice,
    this.productDescription,
    this.storeName = 'Store Name',
    this.storeDomain = 'example.com',
    this.productImages,
    this.onVisitStore,
    this.initialRating,
    this.category,
    this.condition,
    this.brand,
    this.publicId,
  });

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  int _selectedImageIndex = 0;
  double _currentRating = 0.0;
  int _userRating = 0;
  bool _isSaved = false;
  bool _isReported = false;

  @override
  void initState() {
    super.initState();
    _selectedImageIndex = 0;
    _currentRating = widget.initialRating ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();
    final images = widget.productImages ?? List<String>.filled(5, '');
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final mainImage = images.isNotEmpty && _selectedImageIndex < images.length
        ? images[_selectedImageIndex]
        : '';

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Product View',
        productSearchController: searchState.productSearchController,
        storeSearchController: searchState.storeSearchController,
        onProductSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        onStoreSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store name and domain bars side by side
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.storeName ?? 'Store Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'is selling this product',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.storeDomain ?? 'example.com',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          widget.storeName ?? 'Store Name',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'is selling this product',
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.storeDomain ?? 'example.com',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Save/Report buttons for mobile
            if (isMobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildSaveButton(),
                    const SizedBox(width: 12),
                    _buildReportButton(),
                  ],
                ),
              ),

            // Layout
            if (isMobile)
              _buildMobileLayout(images, mainImage)
            else
              _buildDesktopLayout(images, mainImage),
            
            const SizedBox(height: 240),
            
            // Footer
            const PageFooter(),
          ],
            ),
          ),
          
          // Save/Report buttons for desktop (positioned)
          if (!isMobile) ...[
            Positioned(
              top: 20,
              right: 20,
              child: _buildSaveButton(),
            ),
            Positioned(
              top: 80,
              right: 20,
              child: _buildReportButton(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isSaved = !_isSaved;
          });
          showCustomSnackBar(
            context,
            _isSaved ? 'Product saved!' : 'Product removed from saved',
            positive: _isSaved,
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isSaved ? Colors.amber : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(
            _isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: _isSaved ? Colors.amber : Colors.grey.shade600,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isReported = !_isReported;
          });
          showCustomSnackBar(
            context,
            _isReported
                ? 'Product reported to Storazaar. Thank you for keeping our community safe!'
                : 'Report removed.',
            positive: !_isReported,
          );
          // TODO: Send report to Storazaar backend
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isReported ? Colors.red : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(
            _isReported ? Icons.flag : Icons.flag_outlined,
            color: _isReported ? Colors.red : Colors.grey.shade600,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<String> images, String mainImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLargePhotoTile(mainImage),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) =>
                  _buildThumbnailTile(images[index], index),
            ),
          ),
          const SizedBox(height: 20),
          _buildProductDetails(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(List<String> images, String mainImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: small photos stacked vertically
          SizedBox(
            width: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: images.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: entry.key < images.length - 1 ? 12.0 : 0),
                  child: _buildThumbnailTile(entry.value, entry.key),
                );
              }).toList(),
            ),
          ),

          const SizedBox(width: 16),

          // Center: large photo
          Flexible(
            flex: 1,
            child: _buildLargePhotoTile(mainImage),
          ),

          const SizedBox(width: 24),

          // Right: details
          Flexible(flex: 1, child: _buildProductDetails()),
        ],
      ),
    );
  }

  Widget _buildLargePhotoTile(String imageUrl) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            image: imageUrl.isNotEmpty
                ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                : null,
          ),
          child: imageUrl.isEmpty
              ? const Center(child: Icon(Icons.image, size: 80, color: Colors.grey))
              : null,
        ),
      ),
    );
  }

  Widget _buildThumbnailTile(String imageUrl, int index) {
    final isSelected = _selectedImageIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedImageIndex = index),
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          image: imageUrl.isNotEmpty
              ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
              : null,
        ),
        child: imageUrl.isEmpty
            ? const Center(child: Icon(Icons.image, size: 32, color: Colors.grey))
            : null,
      ),
    );
  }

  Widget _buildProductDetails() {
    final desc = widget.productDescription ?? 'No description available.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.productTitle,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            final priceText = (widget.productPrice != null && widget.productPrice!.isNotEmpty)
                ? widget.productPrice!
                : 'No price';
            if (isNarrow) {
              // On narrow screens, price comes first, then button
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      priceText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreProfilePage(
                              storeName: widget.storeName ?? 'Store Name',
                              storeDomain: widget.storeDomain ?? 'example.com',
                              description: 'Quality products and great customer service',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 19.2),
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Visit Store Profile',
                            style: TextStyle(fontSize: 14.4),
                          ),
                          SizedBox(width: 9.6),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // On wide screens, keep original layout
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      priceText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreProfilePage(
                              storeName: widget.storeName ?? 'Store Name',
                              storeDomain: widget.storeDomain ?? 'example.com',
                              description: 'Quality products and great customer service',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 19.2),
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Visit Store Profile',
                            style: TextStyle(fontSize: 14.4),
                          ),
                          SizedBox(width: 9.6),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        
        // Product info chart
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            return SizedBox(
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: isNarrow ? 1.0 : 0.5,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      // Top: Product ID
                      _buildInfoRow('Product ID', 'ID: 8Ga4-B197-fJ90-64zk-eR3h'),
                      const Divider(height: 20),
                      _buildInfoRow('Category', widget.category ?? 'N/A'),
                      const Divider(height: 20),
                      _buildInfoRow('Condition', widget.condition ?? 'N/A'),
                      const Divider(height: 20),
                      _buildInfoRow('Store', widget.storeName ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        
        Text(
          desc,
          style: const TextStyle(fontSize: 14, height: 1.6),
          maxLines: 15,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 24),
        
        // Rating display and rate button
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
                    'Product Rating',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Tooltip(
                    richMessage: _buildRatingBreakdownWidget(),
                    preferBelow: false,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < _currentRating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          _currentRating > 0 ? _currentRating.toInt().toString() : 'No ratings yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                child: ElevatedButton.icon(
                  onPressed: _showRatingDialog,
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
      ],
    );
  }

  void _showRatingDialog() {
    int tempRating = _userRating;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Rate this Product'),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: tempRating > 0
                  ? () {
                      setState(() {
                        _userRating = tempRating;
                        _currentRating = tempRating.toDouble();
                      });
                      Navigator.pop(context);
                      showCustomSnackBar(
                        context,
                        'Thank you for rating this product $_userRating stars!',
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  InlineSpan _buildRatingBreakdownWidget() {
    // Mock data - in a real app, this would come from the backend
    // These percentages would be calculated from actual user ratings
    final Map<int, double> ratingPercentages = {
      5: 45.0,
      4: 30.0,
      3: 15.0,
      2: 7.0,
      1: 3.0,
    };

    return WidgetSpan(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rating Breakdown',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(5, (index) {
            final stars = 5 - index;
            final percentage = ratingPercentages[stars] ?? 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$stars',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percentage / 100,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 35,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
