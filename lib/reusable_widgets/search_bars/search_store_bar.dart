import 'package:flutter/material.dart';

/// SearchStoreBar
/// Reusable store search field with a gray placeholder: "Search a Store".
/// Designed to sit on the right side of a paired search unit.
class SearchStoreBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchStoreBar({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: 'Search a Store',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              if (onSubmitted != null) {
                onSubmitted!(controller?.text ?? '');
              }
            },
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClear ?? () => controller?.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
