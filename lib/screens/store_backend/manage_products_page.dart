import 'package:flutter/material.dart';
import '../../reusable_widgets/snackbar.dart';
import 'package:flutter/services.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../reusable_widgets/store_photo_picker.dart';
import '../../services/product_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({Key? key}) : super(key: key);

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // TODO: Replace with real user ID from auth
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      List<Map<String, dynamic>> products = [];
      if (userId.isNotEmpty) {
        products = await ProductService.fetchUserProducts(userId);
      }
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products.';
        _loading = false;
      });
    }
  }

  void _editProduct(Map<String, dynamic> product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
    if (result == true) {
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Back arrow only, no AppBar or sidebar
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            // Title above the product tiles
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                      : _products.isEmpty
                          ? const Center(
                              child: Text(
                                'No products to display.',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  // Increase columns for smaller tiles
                                  final crossAxisCount = width >= 1200
                                      ? 8
                                      : width >= 900
                                          ? 6
                                          : width >= 600
                                              ? 4
                                              : 2;
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 0.65, // More vertical, smaller tile
                                    ),
                                    itemCount: _products.length,
                                    itemBuilder: (context, index) {
                                      final product = _products[index];
                                      // Use main_image_url as the main photo
                                      final mainImageUrl = product['main_image_url']?.toString() ?? '';
                                      return Stack(
                                        children: [
                                          _ProductTile(
                                            title: product['title']?.toString() ?? '',
                                            imageUrl: mainImageUrl,
                                            price: product['price'] != null ? '\$${product['price']}' : '',
                                            rating: (product['rating'] as num?)?.toDouble() ?? 0.0,
                                            compact: true,
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: IconButton(
                                                icon: Icon(Icons.edit, color: Colors.grey.shade600, size: 18),
                                                onPressed: () => _editProduct(product),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String price;
  final double rating;
  final bool compact;

  const _ProductTile({
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
    this.compact = false,
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
                  ? Center(child: Icon(Icons.image, size: compact ? 24 : 40, color: Colors.grey))
                  : null,
            ),
          ),
          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(compact ? 4.0 : 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: compact ? 11 : 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: compact ? 2 : 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: compact ? 12 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
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

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic>? product;
  const EditProductPage({super.key, this.product});
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
            bool _hasChanged = false;
          // Product condition
          String _condition = 'New';
        // Product photo bytes
        Uint8List? _mainPhotoBytes;
  // Additional product photo bytes (up to 4)
  final List<Uint8List?> _additionalPhotoBytes = List.filled(4, null);
      // Removed unused _mainPhotoBytes and _additionalPhotoBytes fields
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _shippingPriceController;
  late TextEditingController _estimatedArrivalController;
  // Add additional photo bytes for up to 4 photos
  // (already declared above)
  
  int _titleLength = 0;
  int _descriptionLength = 0;
  bool _isFreeShipping = false;

  // Image requirements widget

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.product?['description'] ?? '');
    // Ensure price is initialized from product data (from Post Your Store or Supabase)
    String priceValue = '';
    if (widget.product != null && widget.product!['price'] != null) {
      priceValue = widget.product!['price'].toString();
    }
    _priceController = TextEditingController(text: priceValue);
    _shippingPriceController = TextEditingController(text: widget.product?['shippingPrice']?.toString() ?? '');
    // Load additional photos if present
    if (widget.product != null && widget.product!['additionalPhotos'] is List) {
      final List<dynamic> photos = widget.product!['additionalPhotos'];
      for (int i = 0; i < photos.length && i < 4; i++) {
        // If you store photo bytes, decode here. If you store URLs, leave as null (handled by StorePhotoPicker)
        // _additionalPhotoBytes[i] = ...
      }
    }
    _estimatedArrivalController = TextEditingController(text: widget.product?['estimatedArrival'] ?? '');
    
    _titleLength = _titleController.text.length;
    _descriptionLength = _descriptionController.text.length;
    // Only set to true if editing an existing product and its value is true; otherwise, default to false
    _isFreeShipping = (widget.product != null && widget.product!['freeShipping'] == true) ? true : false;
    // Initialize product condition from product data if present (including from Post Your Store)
    if (widget.product != null) {
      final cond = widget.product!['condition'];
      if (cond != null && (cond == 'New' || cond == 'Used' || cond == 'Refurbished')) {
        _condition = cond;
      }
    }
    
    _titleController.addListener(() {
      setState(() {
        _titleLength = _titleController.text.length;
        _hasChanged = true;
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _descriptionLength = _descriptionController.text.length;
        _hasChanged = true;
      });
    });
    _priceController.addListener(() {
      setState(() {
        _hasChanged = true;
      });
    });
    _shippingPriceController.addListener(() {
      setState(() {
        _hasChanged = true;
      });
    });
    _estimatedArrivalController.addListener(() {
      setState(() {
        _hasChanged = true;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _shippingPriceController.dispose();
    _estimatedArrivalController.dispose();
    super.dispose();
  }

  // Add the missing _buildTextField method
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLength = 0,
    int currentLength = 0,
    int maxLines = 1,
    bool enabled = true,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength > 0 ? maxLength : null,
          maxLines: maxLines,
          enabled: enabled,
          keyboardType: keyboardType ?? (prefixIcon == Icons.attach_money ? TextInputType.number : TextInputType.text),
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: prefixIcon == Icons.attach_money ? Colors.green : null) : null,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: enabled ? Colors.grey.shade300 : Colors.grey.shade600),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNewProduct = widget.product == null;
    
    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
          centerTitle: true,
          title: Text(
            isNewProduct ? 'Add New Product' : 'Edit Product',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isNewProduct ? Icons.add_shopping_cart : Icons.edit,
                                      color: Colors.black,
                                      size: 36,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isNewProduct ? 'Add New Product' : 'Edit Product',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isNewProduct
                                                ? 'Fill in the product details'
                                                : 'Update your product information',
                                            style: const TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Space between info bar and photo requirements
                              const SizedBox(height: 24),
                              // Product Photos Section
                              StorePhotoPicker(
                                label: 'Main Product Photo',
                                aspectRatio: 1.0,
                                initialBytes: _mainPhotoBytes,
                                onChanged: (bytes) => setState(() => _mainPhotoBytes = bytes),
                                width: 200,
                                height: 200,
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Main product photo requirements:\n- Square (1:1)\n- 600x600 px minimum\n- JPG/PNG\n- Max 2MB',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Additional Photos (up to 4)',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(4, (index) {
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
                                      child: StorePhotoPicker(
                                        label: 'Photo ${index + 1}',
                                        aspectRatio: 1.0,
                                        initialBytes: _additionalPhotoBytes[index],
                                        onChanged: (bytes) => setState(() => _additionalPhotoBytes[index] = bytes),
                                        requirementsText: null,
                                        width: 100,
                                        height: 100,
                                        labelStyle: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 24),
                              // Product Condition Dropdown
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Product Condition',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    initialValue: _condition,
                                    dropdownColor: Colors.black,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[900],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    items: const [
                                      DropdownMenuItem(value: 'New', child: Text('New', style: TextStyle(color: Colors.white))),
                                      DropdownMenuItem(value: 'Used', child: Text('Used', style: TextStyle(color: Colors.white))),
                                      DropdownMenuItem(value: 'Refurbished', child: Text('Refurbished', style: TextStyle(color: Colors.white))),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _condition = value ?? 'New';
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Price field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _priceController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                    ],
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "0.00",
                                      hintStyle: const TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Price is required';
                                      }
                                      final price = double.tryParse(value);
                                      if (price == null || price < 0) {
                                        return 'Enter a valid price';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              // Shipping Price field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shipping Price',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _shippingPriceController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                    ],
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "0.00",
                                      hintStyle: const TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null; // Optional
                                      }
                                      final price = double.tryParse(value);
                                      if (price == null || price < 0) {
                                        return 'Enter a valid shipping price';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              // Title field with length indicator
                              _buildTextField(
                                controller: _titleController,
                                label: 'Title',
                                hint: 'Enter product title',
                                maxLength: 100,
                                currentLength: _titleLength,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Title is required';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '$_titleLength / 100',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Description field with length indicator
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                hint: 'Enter product description',
                                maxLength: 500,
                                currentLength: _descriptionLength,
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Description is required';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '$_descriptionLength / 500',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Shipping Time (Estimated Arrival in Days)
                              _buildTextField(
                                controller: _estimatedArrivalController,
                                label: 'Shipping Time',
                                hint: 'Estimated arrival time in days',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Estimated arrival time is required';
                                  }
                                  final days = int.tryParse(value);
                                  if (days == null || days <= 0) {
                                    return 'Enter a valid number of days';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              // Free Shipping Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isFreeShipping,
                                    onChanged: (value) {
                                      setState(() {
                                        _isFreeShipping = value ?? false;
                                        _hasChanged = true;
                                      });
                                    },
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                  ),
                                  const Text(
                                    'Free Shipping',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Save Button (small, bottom right)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    width: 140,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: _hasChanged
                                          ? () async {
                                              if (_formKey.currentState!.validate() && widget.product != null) {
                                                final productId = widget.product!['id'];
                                                final data = {
                                                  'title': _titleController.text,
                                                  'description': _descriptionController.text,
                                                  'price': double.tryParse(_priceController.text) ?? 0.0,
                                                  'shippingPrice': double.tryParse(_shippingPriceController.text) ?? 0.0,
                                                  'condition': _condition,
                                                  'freeShipping': _isFreeShipping,
                                                  'estimatedArrival': _estimatedArrivalController.text,
                                                  // Add more fields as needed
                                                  // 'mainPhoto': _mainPhotoBytes, // If you want to upload photo bytes
                                                  // 'additionalPhotos': _additionalPhotoBytes, // If you want to upload photo bytes
                                                };
                                                try {
                                                  await ProductService.updateProduct(productId, data);
                                                  showCustomSnackBar(context, 'Product updated!', positive: true);
                                                  Navigator.pop(context, true);
                                                } catch (e) {
                                                  showCustomSnackBar(context, 'Failed to update product: $e', positive: false);
                                                }
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _hasChanged ? Colors.blue : const Color.fromARGB(255, 40, 40, 40), // Lighter grey when disabled
                                        disabledBackgroundColor: const Color.fromARGB(255, 40, 40, 40), // Explicitly set disabled background
                                        foregroundColor: Colors.grey.shade300,
                                        disabledForegroundColor: const Color.fromARGB(255, 40, 40, 40),
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ),
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                       