import 'package:flutter/material.dart';
import '../../screens/store_profile/store_profile_page.dart';

class SavedStoresPopup extends StatefulWidget {
  final bool showAccountPrompt;
  const SavedStoresPopup({super.key, this.showAccountPrompt = false});

  static void show(BuildContext context, {bool showAccountPrompt = false}) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width < 700 ? double.infinity : 500,
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
            child: SavedStoresPopup(showAccountPrompt: showAccountPrompt),
          ),
        ),
      ),
    );
  }

  @override
  State<SavedStoresPopup> createState() => _SavedStoresPopupState();
}

class _SavedStoresPopupState extends State<SavedStoresPopup> {
  final List<Map<String, String>> _savedStores = [];

  void _deleteStore(int index) {
    setState(() {
      _savedStores.removeAt(index);
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
              const Icon(Icons.store, color: Colors.black, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Saved Stores',
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
        // Grid of stores
        Expanded(
          child: _savedStores.isEmpty
              ? Center(
                  child: Text(
                    showPrompt
                        ? 'Create a free account to use this feature.'
                        : "No saved stores yet! Save a store you like, it will end up here.",
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _savedStores.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = _savedStores[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoreProfilePage(
                              storeName: store['name'] ?? '',
                              storeDomain: store['domain'] ?? '',
                              // Add more fields if available in store map
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.store, color: Colors.grey, size: 32),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      store['name'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      store['domain'] ?? '',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                                onPressed: () => _deleteStore(index),
                                tooltip: 'Delete',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
