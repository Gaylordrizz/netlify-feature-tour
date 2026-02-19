class HistoryManager {
  static final HistoryManager _instance = HistoryManager._internal();
  factory HistoryManager() => _instance;
  HistoryManager._internal();

  final List<Map<String, String>> productHistory = [];
  final List<Map<String, String>> storeHistory = [];

  void addProduct(Map<String, String> product) {
    // Prevent duplicates (by title)
    productHistory.removeWhere((p) => p['title'] == product['title']);
    productHistory.insert(0, product); // newest first
    if (productHistory.length > 50) productHistory.removeLast();
  }

  void addStore(Map<String, String> store) {
    // Prevent duplicates (by name)
    storeHistory.removeWhere((s) => s['name'] == store['name']);
    storeHistory.insert(0, store);
    if (storeHistory.length > 50) storeHistory.removeLast();
  }
}
