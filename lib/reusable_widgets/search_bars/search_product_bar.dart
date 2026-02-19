import 'package:flutter/material.dart';

/// SearchProductBar
/// Reusable product search field with a gray placeholder: "Search a Product".
/// Designed to sit on the left side of a paired search unit.
class SearchProductBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchProductBar({
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
          hintText: 'Search a Product',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
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
