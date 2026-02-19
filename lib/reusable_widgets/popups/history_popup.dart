import 'package:flutter/material.dart';


class HistoryPopup extends StatefulWidget {
  final bool showAccountPrompt;
  const HistoryPopup({super.key, this.showAccountPrompt = false});

  static void show(BuildContext context, {bool showAccountPrompt = false}) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width < 700 ? double.infinity : 600,
            margin: width < 700 ? const EdgeInsets.symmetric(horizontal: 16, vertical: 32) : null,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: HistoryPopup(showAccountPrompt: showAccountPrompt),
          ),
        ),
      ),
    );
  }

  @override
  State<HistoryPopup> createState() => _HistoryPopupState();
}

class _HistoryPopupState extends State<HistoryPopup> {
  // TODO: Replace with real product and store history from backend or local storage
  final List<Map<String, String>> _productHistory = [];
  final List<Map<String, String>> _storeHistory = [];

  void _deleteProductHistory(int index) {
    setState(() {
      _productHistory.removeAt(index);
    });
  }

  void _deleteStoreHistory(int index) {
    setState(() {
      _storeHistory.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    final showPrompt = widget.showAccountPrompt;
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.history, color: Colors.black, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Your History',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
        // Content
        Expanded(
          child: Row(
            children: [
              // Product History
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _productHistory.isEmpty
                          ? Center(
                              child: Text(
                                showPrompt
                                    ? 'Create a free account to use this feature.'
                                    : "Visit a product and your history will appear here.",
                                style: const TextStyle(color: Colors.black87, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _productHistory.length,
                              itemBuilder: (context, index) {
                                final product = _productHistory[index];
                                return ListTile(
                                  dense: true,
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(Icons.shopping_bag, color: Colors.grey.shade400, size: 20),
                                  ),
                                  title: Text(product['name']!, style: const TextStyle(fontSize: 13)),
                                  subtitle: Text(product['price']!, style: const TextStyle(fontSize: 11)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                                    onPressed: () => _deleteProductHistory(index),
                                    tooltip: 'Delete',
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: Colors.grey.shade300),
              // Store History
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Stores',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _storeHistory.isEmpty
                          ? Center(
                              child: Text(
                                showPrompt
                                    ? 'Create a free account to use this feature.'
                                    : "Visit a store and your history will appear here.",
                                style: const TextStyle(color: Colors.black87, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _storeHistory.length,
                              itemBuilder: (context, index) {
                                final store = _storeHistory[index];
                                return ListTile(
                                  dense: true,
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(Icons.store, color: Colors.grey.shade400, size: 20),
                                  ),
                                  title: Text(store['name']!, style: const TextStyle(fontSize: 13)),
                                  subtitle: Text(store['domain']!, style: const TextStyle(fontSize: 11)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                                    onPressed: () => _deleteStoreHistory(index),
                                    tooltip: 'Delete',
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
