import 'package:flutter/material.dart';

class CategorySelectionPopup extends StatefulWidget {
  final Function(String)? onCategorySelected;

  // Static variable to remember last selected category
  static String? _lastSelectedCategory;

  const CategorySelectionPopup({
    super.key,
    this.onCategorySelected,
  });

  @override
  State<CategorySelectionPopup> createState() => _CategorySelectionPopupState();

  static void show(BuildContext context, {Function(String)? onCategorySelected}) {
    showDialog(
      context: context,
      builder: (context) => CategorySelectionPopup(onCategorySelected: onCategorySelected),
    );
  }

  // Static method to create the category selection button for the header
  static Widget filterButton(BuildContext context, {Function(String)? onCategorySelected}) {
    return IconButton(
      icon: const Icon(Icons.category, size: 24),
      tooltip: 'Select Category',
      onPressed: () {
        CategorySelectionPopup.show(context, onCategorySelected: onCategorySelected);
      },
    );
  }
}

class _CategorySelectionPopupState extends State<CategorySelectionPopup> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electronics'},
    {'name': 'Clothing'},
    {'name': 'Home'},
    {'name': 'Beauty'},
    {'name': 'Sport'},
    {'name': 'Auto'},
    {'name': 'Tools'},
    {'name': 'Books'},
    {'name': 'Toys'},
    {'name': 'Health'},
    {'name': 'Pets'},
    {'name': 'Office'},
    {'name': 'Jewelry'},
    {'name': 'Food'},
    {'name': 'Furniture'},
    {'name': 'Baby'},
    {'name': 'Garden'},
    {'name': 'Hobbies'},
    {'name': 'Digital Products'},
    {'name': 'Services'},
  ];

  @override
  Widget build(BuildContext context) {
    // Restore last selected category when popup is opened
    _selectedCategory ??= CategorySelectionPopup._lastSelectedCategory;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, color: Colors.black, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Select Category',
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

            // Category list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['name'];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: isSelected ? 4 : 1,
                    color: isSelected ? Colors.blue.shade50 : null,
                    child: ListTile(
                      leading: Text(
                        '\u2022',
                        style: TextStyle(
                          fontSize: 28,
                          color: isSelected ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                      title: Text(
                        category['name'] as String,
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
                          _selectedCategory = category['name'] as String;
                          CategorySelectionPopup._lastSelectedCategory = _selectedCategory;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Footer buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        CategorySelectionPopup._lastSelectedCategory = null;
                      });
                    },
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectedCategory != null
                        ? () {
                            widget.onCategorySelected?.call(_selectedCategory!);
                            CategorySelectionPopup._lastSelectedCategory = _selectedCategory;
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Apply Filter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}