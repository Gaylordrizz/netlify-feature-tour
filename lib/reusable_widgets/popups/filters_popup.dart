import 'package:flutter/material.dart';

class FiltersPopup extends StatefulWidget {
  final Function(String)? onCategorySelected;
  final Function(Map<String, dynamic>)? onFiltersApplied;

  const FiltersPopup({
    super.key,
    this.onCategorySelected,
    this.onFiltersApplied,
  });

  // Static variables to remember last selections
  static String? _lastSelectedCategory;
  static String? _lastAvailability;
  static String? _lastShippingOption;
  static String? _lastCondition;
  static List<String> _lastSelectedFeatures = [];
  static String _lastSortBy = 'Relevance';
  @override
  _FiltersPopupState createState() => _FiltersPopupState();

  static void show(
    BuildContext context, {
    Function(String)? onCategorySelected,
    Function(Map<String, dynamic>)? onFiltersApplied,
  }) {
    showDialog(
      context: context,
      builder: (context) => FiltersPopup(
        onCategorySelected: onCategorySelected,
        onFiltersApplied: onFiltersApplied,
      ),
    );
  }

  // Static method to create the filter button for the header
  static Widget filterButton(
    BuildContext context, {
    Function(String)? onCategorySelected,
    Function(Map<String, dynamic>)? onFiltersApplied,
  }) {
    return IconButton(
      icon: const Icon(Icons.tune, size: 28, color: Colors.black),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(),
      // Tooltip removed
      onPressed: () {
        FiltersPopup.show(
          context,
          onCategorySelected: onCategorySelected,
          onFiltersApplied: onFiltersApplied,
        );
      },
    );
  }
}

class _FiltersPopupState extends State<FiltersPopup> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Category selection
  String? _selectedCategory;
  
  // Filter options
  // String? _selectedStore;
  // double _minRating = 0;
  String? _availability;
  String? _shippingOption;
  String? _condition;
  List<String> _selectedFeatures = [];
  String _sortBy = 'Relevance';

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home',
    'Beauty',
    'Sports',
    'Auto',
    'Tools',
    'Books',
    'Toys',
    'Health',
    'Pets',
    'Office',
    'Jewelry',
    'Food',
    'Furniture',
    'Baby',
    'Garden',
    'Hobbies',
    'Digital Products',
  ];

  final List<String> _sortOptions = [
    'Relevance',
    'Price Low→High',
    'Price High→Low',
    'Best Sellers',
    'Newest',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Restore last selections
    _selectedCategory ??= FiltersPopup._lastSelectedCategory;
    _availability ??= FiltersPopup._lastAvailability;
    _shippingOption ??= FiltersPopup._lastShippingOption;
    _condition ??= FiltersPopup._lastCondition;
    _selectedFeatures = FiltersPopup._lastSelectedFeatures.isNotEmpty ? List<String>.from(FiltersPopup._lastSelectedFeatures) : _selectedFeatures;
    _sortBy = FiltersPopup._lastSortBy;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with tabs
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Title and close button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.tune, color: Colors.black, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Filters & Categories',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
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
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Categories'),
                      Tab(text: 'Filters'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCategoriesTab(),
                  _buildFiltersTab(),
                ],
              ),
            ),

            // Footer buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        _availability = null;
                        _shippingOption = null;
                        _condition = null;
                        _selectedFeatures = [];
                        _sortBy = 'Relevance';
                        FiltersPopup._lastSelectedCategory = null;
                        FiltersPopup._lastAvailability = null;
                        FiltersPopup._lastShippingOption = null;
                        FiltersPopup._lastCondition = null;
                        FiltersPopup._lastSelectedFeatures = [];
                        FiltersPopup._lastSortBy = 'Relevance';
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Clear All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Apply category if selected
                      if (_selectedCategory != null) {
                        widget.onCategorySelected?.call(_selectedCategory!);
                        FiltersPopup._lastSelectedCategory = _selectedCategory;
                      }
                      // Apply filters
                      final filters = {
                        'availability': _availability,
                        'shippingOption': _shippingOption,
                        'condition': _condition,
                        'features': _selectedFeatures,
                        'sortBy': _sortBy,
                      };
                      widget.onFiltersApplied?.call(filters);
                      FiltersPopup._lastAvailability = _availability;
                      FiltersPopup._lastShippingOption = _shippingOption;
                      FiltersPopup._lastCondition = _condition;
                      FiltersPopup._lastSelectedFeatures = List<String>.from(_selectedFeatures);
                      FiltersPopup._lastSortBy = _sortBy;
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategory == category;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.blue.shade50 : null,
          child: ListTile(
            leading: Icon(
              Icons.category,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
            title: Text(
              category,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildFiltersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sort By
        _buildFilterSection(
          'Sort By',
          DropdownButtonFormField<String>(
            initialValue: _sortBy,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _sortOptions.map((sort) {
              return DropdownMenuItem(value: sort, child: Text(sort));
            }).toList(),
            onChanged: (value) => setState(() => _sortBy = value!),
          ),
        ),

        // Customer Ratings


        // Availability
        _buildFilterSection(
          'Availability',
          Wrap(
            spacing: 8,
            children: ['In Stock', 'Out of Stock'].map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: _availability == option,
                selectedColor: Colors.blue.withOpacity(0.15),
                onSelected: (selected) {
                  setState(() => _availability = selected ? option : null);
                },
              );
            }).toList(),
          ),
        ),

        // Condition
        _buildFilterSection(
          'Condition',
          Wrap(
            spacing: 8,
            children: ['New', 'Used', 'Refurbished'].map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: _condition == option,
                selectedColor: Colors.blue.withOpacity(0.15),
                onSelected: (selected) {
                  setState(() => _condition = selected ? option : null);
                },
              );
            }).toList(),
          ),
        ),

        // Shipping Options
        _buildFilterSection(
          'Shipping',
          Wrap(
            spacing: 8,
            children: ['Free Shipping'].map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: _shippingOption == option,
                selectedColor: Colors.blue.withOpacity(0.15),
                onSelected: (selected) {
                  setState(() => _shippingOption = selected ? option : null);
                },
              );
            }).toList(),
          ),
        ),

        // Store filter removed
      ],
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 20),
      ],
    );
  }
}
