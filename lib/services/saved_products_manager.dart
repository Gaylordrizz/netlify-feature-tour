import 'package:flutter/material.dart';

class SavedProductsManager extends ChangeNotifier {
  static final SavedProductsManager _instance = SavedProductsManager._internal();
  factory SavedProductsManager() => _instance;
  SavedProductsManager._internal();

  final List<Map<String, dynamic>> _savedProducts = [];

  List<Map<String, dynamic>> get savedProducts => List.unmodifiable(_savedProducts);

  void addProduct(Map<String, dynamic> product) {
    _savedProducts.add(product);
    notifyListeners();
  }

  void removeProductAt(int index) {
    if (index >= 0 && index < _savedProducts.length) {
      _savedProducts.removeAt(index);
      notifyListeners();
    }
  }

  void removeProductById(dynamic id) {
    _savedProducts.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  void clear() {
    _savedProducts.clear();
    notifyListeners();
  }

  void setProducts(List<Map<String, dynamic>> products) {
    _savedProducts
      ..clear()
      ..addAll(products);
    notifyListeners();
  }
}
