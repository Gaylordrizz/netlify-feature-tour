import 'package:flutter/material.dart';
import '../../../reusable_widgets/sidebar/sidebar.dart';
import 'subscription_billing_settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/avatar_color.dart';
import '../../../services/saved_products_manager.dart';
import '../../product_view/product_view_page.dart';
// ignore: unused_import
import '../../store_profile/store_profile_page.dart';
import '../../../reusable_widgets/footer/page_footer.dart';
import '../../community_forum/chat_room_profile_page.dart';

// --- Copied from home_page.dart ---
class _ProductTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String price;
  final double rating;
  final bool small;
  final int id;
  final VoidCallback? onRemove;

  const _ProductTile({
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
    required this.id,
    this.onRemove,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = small ? 12 : 14;
    final double priceFontSize = small ? 13 : 16;
    final double iconSize = small ? 13 : 16;
    final double cardPadding = small ? 8 : 12;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Make the image square and at the top
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey.shade100,
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? Image.network(imageUrl!, fit: BoxFit.cover)
                        : Center(child: Icon(Icons.image, size: iconSize + 27, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onRemove != null)
                        IconButton(
                          icon: Icon(Icons.close, size: small ? 18 : 22, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          tooltip: 'Remove',
                          onPressed: onRemove,
                        ),
                    ],
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: small ? 2 : 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Placeholder infinite scroll for saved products
class _InfiniteScrollProducts extends StatefulWidget {
  @override
  State<_InfiniteScrollProducts> createState() => _InfiniteScrollProductsState();
}

class _InfiniteScrollProductsState extends State<_InfiniteScrollProducts> {
  // Removed unused _controller field
  late SavedProductsManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = SavedProductsManager();
    _manager.addListener(_onManagerChanged);
    // No test/demo data
  }

  @override
  void dispose() {
    _manager.removeListener(_onManagerChanged);
    super.dispose();
  }

  void _onManagerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final savedProducts = _manager.savedProducts;
    // Use a vertical rectangle card by adjusting childAspectRatio
    if (savedProducts.isEmpty) {
      return const Center(
        child: Text('No saved products.'),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65, // vertical rectangle
      ),
      itemCount: savedProducts.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, i) {
        final item = savedProducts[i];
        String formattedPrice = '';
        if (item['price'] != null) {
          try {
            final priceDouble = double.parse(item['price'].toString());
            formattedPrice = '\$${priceDouble.toStringAsFixed(2)}';
          } catch (_) {
            formattedPrice = '\$${item['price']}';
          }
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductViewPage(
                  productTitle: item['title'] ?? '',
                  productPrice: formattedPrice,
                  productDescription: 'Demo description for ${item['title']}',
                  storeName: 'Demo Store',
                  storeDomain: 'demo.com',
                  initialRating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                  publicId: item['id']?.toString(),
                ),
              ),
            );
          },
          child: _ProductTile(
            id: item['id'] ?? (i + 1),
            title: item['title'] ?? '',
            imageUrl: item['image'] ?? '',
            price: formattedPrice,
            rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
            small: true,
            onRemove: () {
              _manager.removeProductAt(i);
            },
          ),
        );
      },
    );
  }
}

// Placeholder infinite scroll for saved stores
class _InfiniteScrollStores extends StatefulWidget {
  @override
  State<_InfiniteScrollStores> createState() => _InfiniteScrollStoresState();
}

class _InfiniteScrollStoresState extends State<_InfiniteScrollStores> {
  // TODO: Implement real saved stores data source here

  @override
  Widget build(BuildContext context) {
    // No test/demo data; implement real store data here
    return const Center(
      child: Text('No saved stores.'),
    );
  }
}

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // TODO: Replace with real chat room/user info from backend
  final bool _hasChatRoom = false;
  final bool _hasSubscription = false; // TODO: Set to true if user is a paying user with a subscription
  final String _chatRoomId = '';
  final String _chatRoomName = '';
  final String _chatRoomUserName = '';
  final String _chatRoomStoreName = '';
  final String _chatRoomDomain = '';
  final String _chatRoomProfilePhoto = '';
  final String _chatRoomStoreThumbnail = '';
    final GlobalKey _avatarKey = GlobalKey();
    OverlayEntry? _dropdownOverlay;

    void _showAccountDropdown() {
      if (_dropdownOverlay != null) return;
      final RenderBox? avatarBox = _avatarKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
      if (avatarBox == null || overlay == null) return;
      final Offset avatarPosition = avatarBox.localToGlobal(Offset.zero, ancestor: overlay);
      const double dropdownWidth = 200;
      // Place the dropdown to the left of the account tile, vertically aligned with the avatar
      double left = avatarPosition.dx - dropdownWidth - 16; // 16px gap
      if (left < 8) left = 8; // Prevent overflow on the left
      double top = avatarPosition.dy;
      _dropdownOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeDropdown,
                child: Container(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: dropdownWidth,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_hasChatRoom) ...[
                        ListTile(
                          title: const Text('My Chat Room', style: TextStyle(fontWeight: FontWeight.w600)),
                          onTap: () {
                            _removeDropdown();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomProfilePage(
                                  roomId: _chatRoomId,
                                  roomName: _chatRoomName,
                                  userName: _chatRoomUserName,
                                  storeName: _chatRoomStoreName,
                                  domain: _chatRoomDomain,
                                  profilePhoto: _chatRoomProfilePhoto,
                                  storeThumbnail: _chatRoomStoreThumbnail,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ],
                      ListTile(
                        title: const Text('Edit'),
                        onTap: () {
                          _removeDropdown();
                          final user = Supabase.instance.client.auth.currentUser;
                          String userName = user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? '';
                          _showEditInfoDialog(userName);
                        },
                      ),
                      Container(
                        height: 1,
                        color: Colors.black,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      if (_hasSubscription) ...[
                        ListTile(
                          title: const Text('Manage Subscription'),
                          onTap: () {
                            _removeDropdown();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionBillingSettingsPage(),
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ],
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () async {
                          _removeDropdown();
                          await Supabase.instance.client.auth.signOut();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out successfully')),
                            );
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      Overlay.of(context).insert(_dropdownOverlay!);
    }

    void _removeDropdown() {
      _dropdownOverlay?.remove();
      _dropdownOverlay = null;
    }
  void _showEditInfoDialog(String currentName) {
    final TextEditingController _editNameController = TextEditingController(text: currentName);
    final FocusNode _focusNode = FocusNode();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            String originalName = currentName;
            double dialogWidth = MediaQuery.of(context).size.width * 0.5;
            if (dialogWidth > 400) dialogWidth = 400;
            // Track if the name is valid and changed
            bool isValidName(String name) {
              return name.isNotEmpty && name == name.trim() && !name.contains(' ') && name != originalName;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_focusNode.hasFocus) {
                _focusNode.requestFocus();
                _editNameController.selection = TextSelection(baseOffset: 0, extentOffset: _editNameController.text.length);
              }
            });
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: SizedBox(
                width: dialogWidth,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _editNameController,
                            focusNode: _focusNode,
                            cursorColor: Colors.black,
                            autofocus: true,
                            onChanged: (_) => setStateDialog(() {}),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black, width: 2),
                              ),
                              errorText: _editNameController.text.isNotEmpty && _editNameController.text.contains(' ')
                                  ? 'No spaces allowed'
                                  : null,
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: isValidName(_editNameController.text)
                                    ? () async {
                                        final newName = _editNameController.text.trim();
                                        final user = Supabase.instance.client.auth.currentUser;
                                        if (user != null) {
                                          await Supabase.instance.client.auth.updateUser(
                                            UserAttributes(data: {'name': newName}),
                                          );
                                          await Supabase.instance.client.auth.refreshSession();
                                          if (mounted) {
                                            setState(() {}); // Refresh account bar
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isValidName(_editNameController.text)
                                      ? Colors.blue
                                      : Colors.grey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Save Changes'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    String userName =
        user?.userMetadata?['name'] ?? user?.email?.split('@').first ?? '';
    String userEmail = user?.email ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const GlobalSidebarDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          tooltip: 'Back',
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ...existing code...
            // Main content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Image.asset(
                          'assets/storazaar_logo.png',
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Account bar layout with width matching the combined width of the saved products and stores boxes
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double boxSize = (constraints.maxWidth - 48) / 2;
                          boxSize = boxSize > 300 ? 300 : boxSize;
                          double totalWidth = boxSize * 2 + 16;
                          return Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (_dropdownOverlay == null) {
                                  _showAccountDropdown();
                                } else {
                                  _removeDropdown();
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  width: totalWidth,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Add key to avatar for dropdown positioning
                                      Container(
                                        key: _avatarKey,
                                        child: getUserAvatar(userName, radius: 32),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userName,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              userEmail,
                                              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Removed edit icon button; edit now in dropdown
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Responsive: stack vertically on narrow screens, side by side on wide screens
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Threshold: if width < 700, stack vertically; else side by side
                          bool isNarrow = constraints.maxWidth < 700;
                          double boxSize = isNarrow
                              ? constraints.maxWidth - 32
                              : (constraints.maxWidth - 48) / 2;
                          boxSize = boxSize > 300 ? 300 : boxSize;
                          final productBox = Container(
                            width: boxSize,
                            height: boxSize,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Saved Products',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _InfiniteScrollProducts(),
                                  ),
                                ),
                              ],
                            ),
                          );
                          final storesBox = Container(
                            width: boxSize,
                            height: boxSize,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Saved Stores',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _InfiniteScrollStores(),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (isNarrow) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [productBox, storesBox],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [productBox, storesBox],
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 120,
                      ), // Increased extra space at bottom
                      const PageFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }
}
