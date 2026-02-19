import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../services/search_state.dart';
import '../../reusable_widgets/store_photo_picker.dart';
import '../../services/store_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class EditStoreInfoPage extends StatefulWidget {
  const EditStoreInfoPage({super.key});

  @override
  State<EditStoreInfoPage> createState() => _EditStoreInfoPageState();
}

class _EditStoreInfoPageState extends State<EditStoreInfoPage> {
  // Controls visibility of photo requirements info
  bool _showPhotoRequirements = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final _storeNameController = TextEditingController();
  final _domainController = TextEditingController();
  final _subheadingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _aboutController = TextEditingController();
  final _contactController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();

  // Store photo bytes
  Uint8List? _bannerBytes;
  Uint8List? _logoBytes;
  // Character counts
  int _storeNameLength = 0;
  int _domainLength = 0;
  int _subheadingLength = 0;
  int _descriptionLength = 0;
  int _aboutLength = 0;
  int _contactLength = 0;
  int _facebookLength = 0;
  int _instagramLength = 0;
  int _addressLength = 0;
  int _postalCodeLength = 0;

  // Track initial values for change detection
  Map<String, String> _initialValues = {};
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _loadStoreInfo();
    _storeNameController.addListener(_onAnyFieldChanged);
    _domainController.addListener(_onAnyFieldChanged);
    _subheadingController.addListener(_onAnyFieldChanged);
    _descriptionController.addListener(_onAnyFieldChanged);
    _aboutController.addListener(_onAnyFieldChanged);
    _contactController.addListener(_onAnyFieldChanged);
    _facebookController.addListener(_onAnyFieldChanged);
    _instagramController.addListener(_onAnyFieldChanged);
    _addressController.addListener(_onAnyFieldChanged);
    _postalCodeController.addListener(_onAnyFieldChanged);
  }

  void _onAnyFieldChanged() {
    setState(() {
      _storeNameLength = _storeNameController.text.length;
      _domainLength = _domainController.text.length;
      _subheadingLength = _subheadingController.text.length;
      _descriptionLength = _descriptionController.text.length;
      _aboutLength = _aboutController.text.length;
      _contactLength = _contactController.text.length;
      _facebookLength = _facebookController.text.length;
      _instagramLength = _instagramController.text.length;
      _addressLength = _addressController.text.length;
      _postalCodeLength = _postalCodeController.text.length;

      // Check if any field has changed from initial values
      _hasChanged =
        _storeNameController.text != (_initialValues['store_name'] ?? '') ||
        _domainController.text != (_initialValues['domain'] ?? '') ||
        _subheadingController.text != (_initialValues['subheading'] ?? '') ||
        _descriptionController.text != (_initialValues['description'] ?? '') ||
        _aboutController.text != (_initialValues['about'] ?? '') ||
        _contactController.text != (_initialValues['contact_email'] ?? '') ||
        _addressController.text != (_initialValues['address'] ?? '') ||
        _postalCodeController.text != (_initialValues['postal_code'] ?? '') ||
        _facebookController.text != (_initialValues['facebook'] ?? '') ||
        _instagramController.text != (_initialValues['instagram'] ?? '');
    });
  }

  Future<void> _loadStoreInfo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final store = await StoreService.fetchUserStore(user.id);
    if (store != null) {
      setState(() {
        _storeNameController.text = store['store_name'] ?? '';
        _domainController.text = store['domain'] ?? '';
        _subheadingController.text = store['subheading'] ?? '';
        _descriptionController.text = store['description'] ?? '';
        _aboutController.text = store['about'] ?? '';
        _contactController.text = store['contact_email'] ?? '';
        _facebookController.text = store['facebook'] ?? '';
        _instagramController.text = store['instagram'] ?? '';
        _addressController.text = store['address'] ?? '';
        _postalCodeController.text = store['postal_code'] ?? '';

        // Save initial values for change detection
        _initialValues = {
          'store_name': _storeNameController.text,
          'domain': _domainController.text,
          'subheading': _subheadingController.text,
          'description': _descriptionController.text,
          'about': _aboutController.text,
          'contact_email': _contactController.text,
          'address': _addressController.text,
          'postal_code': _postalCodeController.text,
          'facebook': _facebookController.text,
          'instagram': _instagramController.text,
        };
        _hasChanged = false;
      });
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _domainController.dispose();
    _subheadingController.dispose();
    _descriptionController.dispose();
    _aboutController.dispose();
    _contactController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      backgroundColor: Colors.black,
      appBar: GlobalHeader(
        title: 'Edit Store Information',
        productSearchController: searchState.productSearchController,
        storeSearchController: searchState.storeSearchController,
        onProductSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        onStoreSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
      body: Column(
        children: [
          // Back arrow at the top left
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
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
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
                            child: const Row(
                              children: [
                                Icon(Icons.edit, color: Colors.black, size: 36),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Edit Your Store Information',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Update your store details and photos',
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),


                          // STORE PHOTOS SECTION
                          _buildSectionHeader('Store Photos', Icons.photo_library),
                          const SizedBox(height: 16),
                          _buildPhotoSectionWithThumbnailPreview(),

                          const SizedBox(height: 32),

                          // STORE INFORMATION SECTION
                          _buildSectionHeader('Store Information', Icons.store),
                          const SizedBox(height: 16),

                    _buildTextField(
                      controller: _storeNameController,
                      label: 'Store Name',
                      hint: 'Enter your store name',
                      maxLength: 50,
                      currentLength: _storeNameLength,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your store name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _domainController,
                      label: 'Store Domain / Website URL',
                      hint: 'https://yourstore.com',
                      maxLength: 100,
                      currentLength: _domainLength,
                      prefixIcon: Icons.link,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your store domain';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _subheadingController,
                      label: 'Store Subheading',
                      hint: 'Brief description that appears on your store profile',
                      maxLength: 100,
                      currentLength: _subheadingLength,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Store Description',
                      hint: 'Detailed description of your store',
                      maxLength: 500,
                      currentLength: _descriptionLength,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _aboutController,
                      label: 'About',
                      hint: 'Tell customers about your business',
                      maxLength: 500,
                      currentLength: _aboutLength,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 32),

                    // CONTACT INFORMATION
                    _buildSectionHeader('Contact Information', Icons.contact_mail),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _contactController,
                      label: 'Contact Email',
                      hint: 'contact@yourstore.com',
                      maxLength: 100,
                      currentLength: _contactLength,
                      prefixIcon: Icons.email,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      hint: '123 Main St, City',
                      maxLength: 150,
                      currentLength: _addressLength,
                      prefixIcon: Icons.location_on,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: 'ZIP or Postal Code',
                      maxLength: 20,
                      currentLength: _postalCodeLength,
                      prefixIcon: Icons.local_post_office,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _facebookController,
                      label: 'Facebook (Optional)',
                      hint: 'Facebook page URL',
                      maxLength: 100,
                      currentLength: _facebookLength,
                      prefixIcon: Icons.facebook,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _instagramController,
                      label: 'Instagram (Optional)',
                      hint: 'Instagram profile URL',
                      maxLength: 100,
                      currentLength: _instagramLength,
                      prefixIcon: Icons.camera_alt,
                    ),

                    const SizedBox(height: 40),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _hasChanged
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  final user = Supabase.instance.client.auth.currentUser;
                                  if (user == null) return;
                                  final data = {
                                    'store_name': _storeNameController.text,
                                    'domain': _domainController.text,
                                    'subheading': _subheadingController.text,
                                    'description': _descriptionController.text,
                                    'about': _aboutController.text,
                                    'contact_email': _contactController.text,
                                    'address': _addressController.text,
                                    'postal_code': _postalCodeController.text,
                                    'facebook': _facebookController.text,
                                    'instagram': _instagramController.text,
                                  };
                                  try {
                                    await StoreService.updateUserStore(user.id, data);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Store information updated successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to update store: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanged ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
              ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
    );
  }

  Widget _buildPhotoSectionWithThumbnailPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with info icon
          Row(
            children: [
              const Text(
                'Store Photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                tooltip: 'Show photo requirements',
                onPressed: () {
                  setState(() {
                    _showPhotoRequirements = !_showPhotoRequirements;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          StorePhotoPicker(
            label: 'Store Banner (Background Photo)',
            aspectRatio: 2.0,
            initialBytes: _bannerBytes,
            onChanged: (bytes) => setState(() => _bannerBytes = bytes),
            width: 400,
            height: 200,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StorePhotoPicker(
                label: 'Store Thumbnail Photo',
                aspectRatio: 1.0,
                initialBytes: _logoBytes,
                onChanged: (bytes) => setState(() => _logoBytes = bytes),
                width: 100,
                height: 100,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
          if (_showPhotoRequirements) ...[
            const SizedBox(height: 16),
            const Text(
              'Banner requirements:\n- Horizontal (2:1)\n- 800x400 px minimum\n- JPG/PNG\n- Max 2MB',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const Text(
              'Logo requirements:\n- Square (1:1)\n- 400x400 px minimum\n- JPG/PNG\n- Max 2MB',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLength,
    required int currentLength,
    int maxLines = 1,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              '$currentLength / $maxLength',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
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
}
