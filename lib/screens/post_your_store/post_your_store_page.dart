import '../../services/store_id.dart';
import '../../services/product_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../services/search_state.dart';
import '../store_backend/store_backend_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/draft_store_service.dart';
import '../../reusable_widgets/snackbar.dart';
// --- Validators from apply_form_requirements.dart ---

String? validateStoreName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Store name is required';
  }
  if (value.length < 1) {
    return 'Store name must be at least 1 character';
  }
  return null;
}

String? validateStoreDomain(String? value) {
  if (value == null || value.isEmpty) {
    return 'Store domain is required';
  }
  if (value.contains(' ')) {
    return 'No spaces allowed in domain';
  }
  final domainRegex = RegExp(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!domainRegex.hasMatch(value)) {
    return 'Enter a valid domain (e.g., abc.com)';
  }
  return null;
}

String? validateCategory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a category';
  }
  return null;
}

String? validateStoreSubheading(String? value) {
  if (value == null || value.isEmpty) {
    return 'Store subheading is required';
  }
  return null;
}

String? validateAboutStore(String? value) {
  if (value == null || value.isEmpty) {
    return 'About store is required';
  }
  return null;
}

String? validateSocialLink(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/\S*)?$');
  if (!urlRegex.hasMatch(value)) {
    return 'Enter a valid link to the social media page';
  }
  return null;
}

String? validateBannerPhoto(dynamic imageBytes) {
  if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
    return 'Store banner photo is required';
  }
  return null;
}

String? validateThumbnailPhoto(dynamic imageBytes) {
  if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
    return 'Store thumbnail photo is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return null;
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validateContactAddress(String? value) {
  return null;
}

String? validatePostalCode(String? value) {
  if (value == null || value.isEmpty) return null;
  // Only allow letters, numbers, and dashes (-)
  final postalRegex = RegExp(r'^[a-zA-Z0-9-]*$');
  if (!postalRegex.hasMatch(value)) {
    return 'Postal code can only contain letters, numbers, and dashes';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) return null;
  final phoneRegex = RegExp(r'^[0-9\-]+$');
  if (!phoneRegex.hasMatch(value)) {
    return 'Phone can only contain numbers and dashes';
  }
  return null;
}

String? validateProductPhoto(dynamic imageBytes) {
  if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
    return 'At least 1 product photo is required';
  }
  return null;
}

String? validateProductCondition(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product condition is required';
  }
  const allowed = ['New', 'Used', 'Refurbished'];
  if (!allowed.contains(value)) {
    return 'Invalid product condition';
  }
  return null;
}

String? validateProductTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product title is required';
  }
  final titleRegex = RegExp(r'^[a-zA-Z ]+$');
  if (!titleRegex.hasMatch(value)) {
    return 'Product title can only contain letters and spaces';
  }
  return null;
}

String? validateProductPrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product price is required';
  }
  final priceRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
  if (!priceRegex.hasMatch(value)) {
    return 'Enter a valid price (numbers and one ".")';
  }
  return null;
}

String? validateEstimatedArrival(String? value) {
  if (value == null || value.isEmpty) {
    return 'Estimated arrival is required';
  }
  final arrivalRegex = RegExp(r'^[0-9]+$');
  if (!arrivalRegex.hasMatch(value)) {
    return 'Only numbers allowed for estimated arrival';
  }
  return null;
}
// --- End validators ---

class PostYourStorePage extends StatefulWidget {
  const PostYourStorePage({super.key});

  @override
  State<PostYourStorePage> createState() => _PostYourStorePageState();
}

class ProductFormData {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController shippingPriceController = TextEditingController();
  final TextEditingController estimatedArrivalController =
      TextEditingController();
  int titleLength = 0;
  int descriptionLength = 0;
  String? productImagePath;
  Uint8List? productImageBytes;
  List<String?> additionalImagePaths = List<String?>.filled(4, null);
  List<Uint8List?> additionalImageBytes = List<Uint8List?>.filled(4, null);
  String productCondition = '';
  bool isFreeShipping = false;

  // Spinner and product id state per product
  bool isFinishing = false;
  String? finishedProductId;

  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    shippingPriceController.dispose();
    estimatedArrivalController.dispose();
  }
}

class _PostYourStorePageState extends State<PostYourStorePage> {
      bool _canShowSubmit = false;
      void _handleFinishForm() {
        if (_isFormComplete()) {
          setState(() {
            _canShowSubmit = true;
          });
        } else {
          showCustomSnackBar(context, 'Please fill all required fields before finishing the form.', positive: false);
        }
      }
    Widget _buildTextField({
      required TextEditingController controller,
      required String label,
      required String hint,
      int? maxLength,
      int? currentLength,
      IconData? prefixIcon,
      int maxLines = 1,
      bool enabled = true,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
      bool isPostalCode = false,
    }) {
      final isRequired = (validator != null);
      // Remove (Required) from individual field labels for required sections
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLength: maxLength ?? 200,
            maxLines: maxLines,
            enabled: enabled,
            inputFormatters: isPostalCode
                ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]'))]
                : inputFormatters,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              filled: true,
              fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              counterText: maxLength != null && currentLength != null
                  ? '$currentLength/$maxLength'
                  : '',
            ),
            validator: validator,
            onChanged: (_) {
              if (isRequired) setState(() {});
            },
          ),
        ],
      );
    }

  bool _loadingDraft = true;

  // Store and product data fetched from Supabase
  bool _loadingSupabaseData = true;
  String? _fetchError;

  // _searchState is reserved for future search bar integration in the header/app bar.
  // ignore: unused_field
  final SearchState _searchState = SearchState();
  String? _thumbnailImagePath;
  // ignore: unused_field
  Uint8List? _thumbnailImageBytes;
  String? _bannerImagePath;
  // ignore: unused_field
  Uint8List? _bannerImageBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<ProductFormData> _products = [ProductFormData()];

  // Store form controllers
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _subheadingController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  // Contact info controllers
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactAddressController =
      TextEditingController();
  final TextEditingController _contactPostalController =
      TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();

  // Length trackers
  // ignore: unused_field
  // ignore: unused_field
  int _storeNameLength = 0;
  // ignore: unused_field
  int _domainLength = 0;
  // ignore: unused_field
  int _subheadingLength = 0;
  // ignore: unused_field
  int _aboutLength = 0;
  // ignore: unused_field
  int _facebookLength = 0;
  // ignore: unused_field
  int _instagramLength = 0;
  // ignore: unused_field
  int _contactEmailLength = 0;
  // ignore: unused_field
  int _contactAddressLength = 0;
  // ignore: unused_field
  int _contactPostalLength = 0;
  // ignore: unused_field
  int _contactPhoneLength = 0;

  // Category dropdown
  // ignore: unused_field
  final List<String> _categoryOptions = [
    'electronics',
    'clothing',
    'home',
    'beauty',
    'sports',
    'auto',
    'tools',
    'books',
    'toys',
    'health',
    'pets',
    'office',
    'jewelry',
    'food',
    'furniture',
    'baby',
    'garden',
    'hobbies',
    'digital products',
    'services',
  ];
  String? _selectedCategory;

  void _initializeAndFetch() {
    _clearForm();
    _storeNameController.addListener(() {
      setState(() => _storeNameLength = _storeNameController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _domainController.addListener(() {
      setState(() => _domainLength = _domainController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _subheadingController.addListener(() {
      setState(() => _subheadingLength = _subheadingController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _aboutController.addListener(() {
      setState(() => _aboutLength = _aboutController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _facebookController.addListener(() {
      setState(() => _facebookLength = _facebookController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _instagramController.addListener(() {
      setState(() => _instagramLength = _instagramController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _contactEmailController.addListener(() {
      setState(() => _contactEmailLength = _contactEmailController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _contactAddressController.addListener(() {
      setState(() => _contactAddressLength = _contactAddressController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _contactPostalController.addListener(() {
      setState(() => _contactPostalLength = _contactPostalController.text.length);
      _checkFormCompleteAndUpdate();
    });
    _contactPhoneController.addListener(() {
      setState(() => _contactPhoneLength = _contactPhoneController.text.length);
      _checkFormCompleteAndUpdate();
    });
    // Add listeners to every field to always update UI and validation
    _storeNameController.addListener(() { setState(() {}); });
    _domainController.addListener(() { setState(() {}); });
    _subheadingController.addListener(() { setState(() {}); });
    _aboutController.addListener(() { setState(() {}); });
    _facebookController.addListener(() { setState(() {}); });
    _instagramController.addListener(() { setState(() {}); });
    _contactEmailController.addListener(() { setState(() {}); });
    _contactAddressController.addListener(() { setState(() {}); });
    _contactPostalController.addListener(() { setState(() {}); });
    _contactPhoneController.addListener(() { setState(() {}); });
    _setupProductListeners(0);
    _fetchStoreAndProducts();
  }

  void _clearForm() {
    _storeNameController.clear();
    _domainController.clear();
    _subheadingController.clear();
    _aboutController.clear();
    _facebookController.clear();
    _instagramController.clear();
    _contactEmailController.clear();
    _contactAddressController.clear();
    _contactPostalController.clear();
    _contactPhoneController.clear();
    _thumbnailImagePath = null;
    _bannerImagePath = null;
    _selectedCategory = null;
    _products.clear();
    _products.add(ProductFormData());
    _loadingDraft = false;
    setState(() {});
  }

  Future<void> _fetchStoreAndProducts() async {
    setState(() {
      _loadingSupabaseData = true;
      _fetchError = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          _loadingSupabaseData = false;
        });
        return;
      }
      // Fetch store (assuming one store per user)
      // ignore: unused_local_variable
      final storeResp = await Supabase.instance.client
          .from('stores')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
      // Fetch products
      // ignore: unused_local_variable
      final productsResp = await Supabase.instance.client
          .from('products')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      setState(() {
        _loadingSupabaseData = false;
      });
    } catch (e) {
      setState(() {
        _fetchError = 'Failed to fetch data: $e';
        _loadingSupabaseData = false;
      });
    }
  }

  Future<String?> _uploadStoreImage(
    Uint8List? imageBytes,
    String fileName,
    String folder,
  ) async {
    if (imageBytes == null || imageBytes.isEmpty) return null;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    await Supabase.instance.client.storage
        .from('store-images')
        .uploadBinary(
          '${user.id}/$folder/$fileName',
          imageBytes,
          fileOptions: const FileOptions(upsert: true),
        );
    // If uploadBinary fails, it throws an exception, otherwise returns the file path as String
    final publicUrl = Supabase.instance.client.storage
        .from('store-images')
        .getPublicUrl('${user.id}/$folder/$fileName');
    return publicUrl;
  }

  Future<void> _saveStoreToSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? thumbnailUrl;
    String? bannerUrl;
    if (_thumbnailImageBytes != null) {
      thumbnailUrl = await _uploadStoreImage(
        _thumbnailImageBytes,
        'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'thumbnail',
      );
    }
    if (_bannerImageBytes != null) {
      bannerUrl = await _uploadStoreImage(
        _bannerImageBytes,
        'banner_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'banner',
      );
    }

    final storeId = generateStoreId();
    final response = await Supabase.instance.client.from('stores').insert({
      'user_id': user.id,
      'store_id': storeId,
      'store_name': _storeNameController.text,
      'domain': _domainController.text,
      'category': _selectedCategory ?? '',
      'subheading': _subheadingController.text,
      'about': _aboutController.text,
      'facebook': _facebookController.text,
      'instagram': _instagramController.text,
      'contact_email': _contactEmailController.text,
      'contact_address': _contactAddressController.text,
      'contact_postal': _contactPostalController.text,
      'contact_phone': _contactPhoneController.text,
      'thumbnail_url': thumbnailUrl,
      'banner_url': bannerUrl,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Robust error handling for Supabase response
    if (response == null) {
      throw Exception('Failed to save store: Null response');
    } else if (response is String && response.toLowerCase().contains('error')) {
      throw Exception('Failed to save store: $response');
    } else if (response is Map &&
        response is Map<String, dynamic> &&
        response.containsKey('error') &&
        response['error'] != null) {
      throw Exception('Failed to save store: ${response['error']}');
    } else if (response is Map &&
        response.containsKey('status') &&
        response['status'] != 201) {
      throw Exception(
        'Failed to save store: ${response['status']} ${response['statusText'] ?? ''}',
      );
    } else if (response is Map &&
        response.containsKey('data') &&
        response['data'] == null) {
      throw Exception('Failed to save store: Unknown error, no data returned');
    }
  }

  Future<String?> _uploadProductImage(
    Uint8List? imageBytes,
    String fileName,
  ) async {
    if (imageBytes == null || imageBytes.isEmpty) return null;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    final storageResponse = await Supabase.instance.client.storage
        .from('product-images')
        .uploadBinary(
          '${user.id}/$fileName',
          imageBytes,
          fileOptions: const FileOptions(upsert: true),
        );
    // Robust error handling for storage response
    if (storageResponse.toString().toLowerCase().contains('error')) {
      return null;
    } else if (storageResponse is Map) {
      if ((storageResponse as Map<String, dynamic>).containsKey('error') &&
          (storageResponse as Map<String, dynamic>)['error'] != null) {
        return null;
      }
    }
    final publicUrl = Supabase.instance.client.storage
        .from('product-images')
        .getPublicUrl('${user.id}/$fileName');
    return publicUrl;
  }

  Future<void> _saveProductToSupabase(ProductFormData product) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? mainImageUrl;
    if (product.productImageBytes != null) {
      mainImageUrl = await _uploadProductImage(
        product.productImageBytes,
        'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }
    List<String?> additionalImageUrls = [];
    for (int i = 0; i < product.additionalImageBytes.length; i++) {
      final bytes = product.additionalImageBytes[i];
      if (bytes != null) {
        final url = await _uploadProductImage(
          bytes,
          'product_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
        );
        additionalImageUrls.add(url);
      } else {
        additionalImageUrls.add(null);
      }
    }

    // Fetch store_id from the store (assume only one store per user)
    final storeResp = await Supabase.instance.client
        .from('stores')
        .select('store_id')
        .eq('user_id', user.id)
        .maybeSingle();
    final storeId = storeResp != null && storeResp['store_id'] != null
        ? storeResp['store_id']
        : null;
    final response = await Supabase.instance.client.from('products').insert({
      'user_id': user.id,
      'store_id': storeId,
      'store_domain': _domainController.text,
      'title': product.titleController.text,
      'price': double.tryParse(product.priceController.text) ?? 0.0,
      'description': product.descriptionController.text,
      'condition': product.productCondition,
      'free_shipping': product.isFreeShipping,
      'main_image_url': mainImageUrl,
      'additional_image_urls': additionalImageUrls,
      'created_at': DateTime.now().toIso8601String(),
      'public_id': generateProductId(),
    });

    if (response == null) {
      throw Exception('Failed to save product: Null response');
    } else if (response is String && response.toLowerCase().contains('error')) {
      throw Exception('Failed to save product: $response');
    } else if (response is Map &&
        response.containsKey('error') &&
        response['error'] != null) {
      throw Exception('Failed to save product: ${response['error']}');
    } else if (response is Map &&
        response.containsKey('status') &&
        response['status'] != 201) {
      throw Exception(
        'Failed to save product: ${response['status']} ${response['statusText'] ?? ''}',
      );
    } else if (response is Map &&
        response.containsKey('data') &&
        response['data'] == null) {
      throw Exception(
        'Failed to save product: Unknown error, no data returned',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAndFetch();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _domainController.dispose();
    _subheadingController.dispose();
    _aboutController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _contactEmailController.dispose();
    _contactAddressController.dispose();
    _contactPostalController.dispose();
    _contactPhoneController.dispose();
    for (final product in _products) {
      product.dispose();
    }
    super.dispose();
  }

  Future<void> _pickProductImage(int index, int imgIdx) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        if (imgIdx == 0) {
          _products[index].productImagePath = file.path;
          _products[index].productImageBytes = file.bytes;
        } else {
          _products[index].additionalImagePaths[imgIdx - 1] = file.path;
          _products[index].additionalImageBytes[imgIdx - 1] = file.bytes;
        }
      });
      _checkFormCompleteAndUpdate();
      showCustomSnackBar(
        context,
        'Product ${index + 1} image ${imgIdx == 0 ? "main" : "#${imgIdx}"} selected',
      );
    }
  }

  // ignore: unused_element
  void _addProduct() {
    if (_products.length >= 10) {
      showCustomSnackBar(context, 'Maximum product posting amount reached (10)', positive: false);
      return;
    }
    setState(() {
      final newProduct = ProductFormData();
      _products.add(newProduct);
      _setupProductListeners(_products.length - 1);
    });
  }

  void _setupProductListeners(int index) {
    _products[index].titleController.addListener(() {
      setState(() => _products[index].titleLength = _products[index].titleController.text.length);
      _saveDraft();
      _checkFormCompleteAndUpdate();
    });
    _products[index].descriptionController.addListener(() {
      setState(() => _products[index].descriptionLength = _products[index].descriptionController.text.length);
      _saveDraft();
      _checkFormCompleteAndUpdate();
    });
    _products[index].priceController.addListener(() {
      setState(() {});
      _checkFormCompleteAndUpdate();
    });
    _products[index].estimatedArrivalController.addListener(() {
      setState(() {});
      _checkFormCompleteAndUpdate();
    });
    // Also update on product image change
    // (handled in _pickProductImage already via setState)
  }


  // ignore: unused_element
  Future<void> _pickThumbnailImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (!mounted) return;
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        _thumbnailImagePath = file.path;
        _thumbnailImageBytes = file.bytes;
        _saveDraft();
      });
      _checkFormCompleteAndUpdate();
      showCustomSnackBar(context, 'Thumbnail image selected');
    }
  }

  // ignore: unused_element
  Future<void> _pickBannerImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (!mounted) return;
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      if (file.bytes != null) {
        final decoded = await decodeImageFromList(file.bytes!);
        final isLandscape = decoded.width > decoded.height;
        if (!isLandscape) {
          showCustomSnackBar(
            context,
            'Warning: Banner image is portrait. Landscape images look best!',
            positive: false,
          );
        }
        setState(() {
          _bannerImagePath = file.path;
          _bannerImageBytes = file.bytes;
          _saveDraft();
        });
        _checkFormCompleteAndUpdate();
        showCustomSnackBar(context, 'Banner image selected');
      }
    }
  }

  // ignore: unused_element
  bool _isFormComplete() {
    // Only require required fields: store name, domain, subheading, about, category, thumbnail, banner, at least 1 product (with required fields)
    if (_storeNameController.text.trim().isEmpty) return false;
    if (_domainController.text.trim().isEmpty) return false;
    if (_subheadingController.text.trim().isEmpty) return false;
    if (_aboutController.text.trim().isEmpty) return false;
    if (_thumbnailImageBytes == null || _thumbnailImageBytes!.isEmpty) return false;
    if (_bannerImageBytes == null || _bannerImageBytes!.isEmpty) return false;
    if (_selectedCategory == null || _selectedCategory!.isEmpty) return false;
    if (_products.isEmpty) return false;
    final firstProduct = _products[0];
    if (firstProduct.titleController.text.trim().isEmpty) return false;
    if (firstProduct.priceController.text.trim().isEmpty) return false;
    if (firstProduct.descriptionController.text.trim().isEmpty) return false;
    if (firstProduct.productImageBytes == null || firstProduct.productImageBytes!.isEmpty) return false;
    if (firstProduct.productCondition.isEmpty) return false;
    if (firstProduct.estimatedArrivalController.text.trim().isEmpty) return false;
    return true;
  }

  // ignore: unused_element
  Future<void> _submitStore() async {
    if (!_isFormComplete()) {
      showCustomSnackBar(context, 'Please fill all required fields.', positive: false);
      return;
    }
    try {
      generateStoreId();
      await _saveStoreToSupabase();
      // Save all products, not just the first
      for (final product in _products) {
        if (_isProductComplete(product)) {
          await _saveProductToSupabase(product);
        }
      }
      await DraftStoreService.clearDraft();
      if (mounted) {
        showCustomSnackBar(context, 'Store and products saved!', positive: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoreBackendPage(
              impressions: 0,
              clicks: 0,
              visits: 0,
              daysOnStorazaar: 1,
              impressionsData: List.generate(30, (i) => 0.0),
              clicksData: List.generate(30, (i) => 0.0),
              visitsData: List.generate(30, (i) => 0.0),
              daysOnStorazaarData: List.generate(30, (i) => (i + 1).toDouble()),
              productImpressionsData: {
                for (var name in _products.map((p) => p.titleController.text))
                  name: List.generate(30, (i) => 0.0),
              },
              productClicksData: {
                for (var name in _products.map((p) => p.titleController.text))
                  name: List.generate(30, (i) => 0.0),
              },
              productDaysSincePostedData: {
                for (var name in _products.map((p) => p.titleController.text))
                  name: List.generate(30, (i) => (i + 1).toDouble()),
              },
              productNames: _products.map((p) => p.titleController.text).toList(),
              storeName: _storeNameController.text,
              domain: _domainController.text,
              category: _selectedCategory ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Error saving to Supabase: $e', positive: false);
      }
    }
  }

  void _checkFormCompleteAndUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingDraft) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const GlobalSidebarDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar with lighter pink, gold, black text, square corners, and thinner height
            Container(
              width: double.infinity,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFB6D5), // Lighter Pink
                    Color(0xFFFFD700), // Gold
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      tooltip: 'Back',
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Post your Store',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content scrollable area
            Expanded(
              child: _loadingSupabaseData
                  ? const Center(child: CircularProgressIndicator())
                  : _fetchError != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              _fetchError!,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              // Storazaar logo above the message
                              Image.asset(
                                'assets/storazaar_logo.png',
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Thank you for subscribing to Storazaar! Your subscription helps us improve the platform.\n\nPlease fill in the required fields to create your store, and add info of your 1st product.\nPlease note the domain of your store must be your exact domain, not a link.\nYou will be required to create your store profile and at least 1 product to continue.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                    // Store Details section with border
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              _buildSectionHeader('Store Details', Icons.store),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTextField(
                                      controller: _storeNameController,
                                      label: 'Store Name',
                                      hint: 'Enter your store name',
                                      maxLength: 40,
                                      currentLength: _storeNameLength,
                                      prefixIcon: Icons.store,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Store name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _domainController,
                                      label: 'Store Domain',
                                      hint: 'e.g. mystore',
                                      maxLength: 30,
                                      currentLength: _domainLength,
                                      prefixIcon: Icons.language,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Domain is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4, bottom: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Category',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _selectedCategory,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                      hint: const Text('Select Category'),
                                      items: _categoryOptions
                                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCategory = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Category is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _subheadingController,
                                      label: 'Store Subheading',
                                      hint: 'Short tagline for your store',
                                      maxLength: 60,
                                      currentLength: _subheadingLength,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Store subheading is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _aboutController,
                                      label: 'About Store',
                                      hint: 'Describe your store...',
                                      maxLength: 200,
                                      currentLength: _aboutLength,
                                      maxLines: 3,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'About store is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _facebookController,
                                      label: 'Facebook (optional)',
                                      hint: 'Facebook page URL',
                                        maxLength: null,
                                      currentLength: _facebookLength,
                                      prefixIcon: Icons.facebook,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _instagramController,
                                      label: 'Instagram (optional)',
                                      hint: 'Instagram handle',
                                        maxLength: null,
                                      currentLength: _instagramLength,
                                      prefixIcon: Icons.camera_alt,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Store Banner Photo Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Store Banner Photo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickBannerImage,
                                child: Container(
                                  width: 280,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _bannerImageBytes != null
                                          ? Colors.green
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: _bannerImageBytes != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.memory(
                                            _bannerImageBytes!,
                                            fit: BoxFit.cover,
                                            width: 280,
                                            height: 180,
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image, size: 40, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text(
                                              'Tap to upload banner (landscape recommended)',
                                              style: TextStyle(color: Colors.grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              if (_bannerImageBytes != null)
                                Positioned(
                                  top: 12,
                                  right: 24,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _bannerImagePath = null;
                                        _bannerImageBytes = null;
                                        _saveDraft();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Store Thumbnail: horizontal rectangle with square photo, name, domain, thin black border
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Column(
                        children: [
                          const Text(
                            'Store Thumbnail',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              constraints: const BoxConstraints(
                                maxWidth: 440,
                                minHeight: 110,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _thumbnailImageBytes != null
                                              ? Colors.green
                                              : Colors.grey.shade400,
                                          width: 1.2,
                                        ),
                                      ),
                                      width: 80,
                                      height: 80,
                                      child: _thumbnailImageBytes != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.memory(
                                                _thumbnailImageBytes!,
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                            )
                                          : Icon(
                                              Icons.add_photo_alternate,
                                              size: 38,
                                              color: Colors.grey.shade600,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _storeNameController.text.isNotEmpty ? _storeNameController.text : 'Store Name',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            _domainController.text.isNotEmpty ? _domainController.text : 'domain',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This is what your customers will see in the homepage.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Details section header removed
                              // ...existing code...
                              // Contact Info section with border
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionHeader(
                                        'Contact Info',
                                        Icons.contact_mail,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 12.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildTextField(
                                              controller:
                                                  _contactEmailController,
                                              label: 'Contact Email (optional)',
                                              hint: 'your@email.com',
                                              maxLength: 60,
                                              currentLength:
                                                  _contactEmailLength,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                            const SizedBox(height: 16),
                                            _buildTextField(
                                              controller:
                                                  _contactAddressController,
                                              label:
                                                  'Contact Address (optional)',
                                              hint: 'Street, City, Country',
                                              maxLength: 100,
                                              currentLength:
                                                  _contactAddressLength,
                                            ),
                                            const SizedBox(height: 16),
                                            _buildTextField(
                                              controller: _contactPostalController,
                                              label: 'Postal Code (optional)',
                                              hint: 'Postal code',
                                              maxLength: 10,
                                              currentLength: _contactPostalLength,
                                              isPostalCode: true,
                                            ),
                                            const SizedBox(height: 16),
                                            _buildTextField(
                                              controller:
                                                  _contactPhoneController,
                                              label: 'Contact Phone (optional)',
                                              hint: 'Phone number',
                                              maxLength: 20,
                                              currentLength:
                                                  _contactPhoneLength,
                                              keyboardType: TextInputType.phone,
                                               inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildSectionHeader(
                                'Products',
                                Icons.shopping_bag,
                              ),
                              const SizedBox(height: 16),
                              ..._products
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => _buildProductForm(
                                      entry.key,
                                      entry.value,
                                    ),
                                  )
                                  .toList(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _addProduct,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Product'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  if (!_canShowSubmit)
                                    ElevatedButton(
                                      onPressed: _handleFinishForm,
                                      child: const Text('Finish Form'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  if (_canShowSubmit)
                                    ElevatedButton(
                                      onPressed: _isFormComplete() ? _submitStore : null,
                                      child: const Text('Submit Store'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isFormComplete() ? Colors.blue : Colors.grey,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (!_canShowSubmit) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  'Note: You must fill all required fields and upload images before finishing the form.',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      )
          ],
        ),
      ),
    );
  }

  Future<void> _saveDraft() async {
    // Save all form data to local storage
    final draft = <String, dynamic>{
      'storeName': _storeNameController.text,
      'domain': _domainController.text,
      'subheading': _subheadingController.text,
      'about': _aboutController.text,
      'facebook': _facebookController.text,
      'instagram': _instagramController.text,
      'contactEmail': _contactEmailController.text,
      'contactAddress': _contactAddressController.text,
      'contactPostal': _contactPostalController.text,
      'contactPhone': _contactPhoneController.text,
      'thumbnailImagePath': _thumbnailImagePath,
      'bannerImagePath': _bannerImagePath,
      'selectedCategory': _selectedCategory,
      'products': _products
          .map(
            (p) => {
              'title': p.titleController.text,
              'price': p.priceController.text,
              'description': p.descriptionController.text,
              'shippingPrice': p.shippingPriceController.text,
              'estimatedArrival': p.estimatedArrivalController.text,
              'productCondition': p.productCondition,
              'isFreeShipping': p.isFreeShipping,
            },
          )
          .toList(),
    };
    await DraftStoreService.saveDraft(draft);
  }

  // ignore: unused_element
  Widget _buildSectionHeader(String title, IconData icon) {
    // Show (Required) at the top right for required sections
    // final isRequiredSection = title == 'Store Details' || title == 'Products';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildProductForm(int index, ProductFormData product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Description
          const SizedBox(height: 16),
          // Product Photos with 'Main' label under the first photo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Photos',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(5, (imgIdx) {
                  final imgBytes = imgIdx == 0
                      ? product.productImageBytes
                      : product.additionalImageBytes[imgIdx - 1];
                  final isUploaded = imgBytes != null && imgBytes.isNotEmpty;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickProductImage(index, imgIdx),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUploaded
                                        ? Colors.green
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                              ),
                              if (isUploaded)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    imgBytes,
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              if (!isUploaded)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 32,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ),
                              if (isUploaded)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (imgIdx == 0) {
                                          product.productImagePath = null;
                                          product.productImageBytes = null;
                                        } else {
                                          product.additionalImagePaths[imgIdx - 1] = null;
                                          product.additionalImageBytes[imgIdx - 1] = null;
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (imgIdx == 0)
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Main',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product Condition Dropdown
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Condition',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: product.productCondition.isEmpty ? null : product.productCondition,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  hint: const Text('Select Condition'),
                  items: ['New', 'Used', 'Refurbished']
                      .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      product.productCondition = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a product condition';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          // Product Title
          _buildTextField(
            controller: product.titleController,
            label: 'Product Title',
            hint: 'Enter product name',
            maxLength: 50,
            currentLength: product.titleLength,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Product title is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Product Price
          const Text(
            'Price',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: product.priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Product price is required';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 16),

          // Estimated Arrival
          _buildTextField(
            controller: product.estimatedArrivalController,
            label: 'Estimated Arrival in Days',
            hint: 'Enter number of days',
            maxLength: 3,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Estimated arrival is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Free Shipping Checkbox
          Row(
            children: [
              Checkbox(
                value: product.isFreeShipping,
                onChanged: (value) {
                  setState(() {
                    product.isFreeShipping = value ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
              const Text(
                'Free Shipping',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: (product.isFinishing || product.finishedProductId != null)
                  ? null
                  : () async {
                      if (_isProductComplete(product)) {
                        setState(() {
                          product.isFinishing = true;
                        });
                        await Future.delayed(const Duration(seconds: 5));
                        setState(() {
                          product.isFinishing = false;
                          product.finishedProductId = generateProductId();
                        });
                        showCustomSnackBar(context, 'Product ${index + 1} finished!', positive: true);
                      } else {
                        showCustomSnackBar(context, 'Please complete all required product fields before finishing.', positive: false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Finish Product', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  bool _isProductComplete(ProductFormData product) {
    if (product.titleController.text.trim().isEmpty) return false;
    if (product.priceController.text.trim().isEmpty) return false;
    if (product.descriptionController.text.trim().isEmpty) return false;
    if (product.estimatedArrivalController.text.trim().isEmpty) return false;
    if (product.productImageBytes == null || product.productImageBytes!.isEmpty) return false;
    final price = double.tryParse(product.priceController.text);
    if (price == null || price <= 0) return false;
    return true;
  }
}
