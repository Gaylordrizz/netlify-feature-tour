import 'package:flutter/material.dart';

/// Global search state manager using singleton pattern
/// Maintains persistent search controllers across app navigation
class SearchState {
  static final SearchState _instance = SearchState._internal();
  
  factory SearchState() {
    return _instance;
  }
  
  SearchState._internal();
  
  final TextEditingController productSearchController = TextEditingController();
  final TextEditingController storeSearchController = TextEditingController();
  
  void dispose() {
    productSearchController.dispose();
    storeSearchController.dispose();
  }
}
