import '../../../services/loading_spinner.dart';
import '../../../services/avatar_color.dart';
import 'package:flutter/material.dart';
import '../popups/filters_popup.dart';
import '../../screens/auth/auth_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/settings/settings_widgets/account_settings_page.dart';
import '../../state/app_state_provider.dart';
class GlobalHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(String)? onCategorySelected;
  final Function(Map<String, dynamic>)? onFiltersApplied;
  final Function(String)? onProductSearch;
  final Function(String)? onStoreSearch;
  final TextEditingController? productSearchController;
  final TextEditingController? storeSearchController;

  const GlobalHeader({
    Key? key,
    required this.title,
    this.onCategorySelected,
    this.onFiltersApplied,
    this.onProductSearch,
    this.onStoreSearch,
    this.productSearchController,
    this.storeSearchController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<GlobalHeader> createState() => _GlobalHeaderState();
}

class _GlobalHeaderState extends State<GlobalHeader> {
  String? _miniSearchType; // 'product' or 'store' or null

  void _showMiniSearch(String type) {
    setState(() {
      _miniSearchType = type;
    });
  }

  void _hideMiniSearch() {
    setState(() {
      _miniSearchType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = screenWidth - 600;
    bool showProductSearch = availableWidth / 2 > 100 && _miniSearchType == null;
    bool showStoreSearch = availableWidth / 2 > 100 && _miniSearchType == null;
    bool isMobile = screenWidth <= 600;

    if (_miniSearchType != null) {
      return Container(
        height: 100,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _hideMiniSearch,
              // No tooltip for back arrow
            ),
            Expanded(
              child: Container(
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: _miniSearchType == 'product'
                      ? widget.productSearchController
                      : widget.storeSearchController,
                  textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: _miniSearchType == 'product'
                        ? 'Search Product'
                        : 'Search Stores',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        final value = (_miniSearchType == 'product'
                                ? widget.productSearchController?.text
                                : widget.storeSearchController?.text) ?? '';
                        if (ModalRoute.of(context)?.settings.name != '/') {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                              arguments: {
                                _miniSearchType == 'product' ? 'productSearch' : 'storeSearch': value,
                              },
                            );
                          });
                        } else {
                          if (_miniSearchType == 'product') {
                            widget.onProductSearch?.call(value);
                          } else {
                            widget.onStoreSearch?.call(value);
                          }
                        }
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    if (ModalRoute.of(context)?.settings.name != '/') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                          arguments: {
                            _miniSearchType == 'product' ? 'productSearch' : 'storeSearch': value,
                          },
                        );
                      });
                    } else {
                      if (_miniSearchType == 'product') {
                        widget.onProductSearch?.call(value);
                      } else {
                        widget.onStoreSearch?.call(value);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    final user = Supabase.instance.client.auth.currentUser;
    // Determine user tier
    UserTier userTier = UserTier.nonAccount;
    if (user != null) {
      final isPaying = user.appMetadata['isPaying'] == true;
      userTier = isPaying ? UserTier.accountPaying : UserTier.accountFree;
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                if (isMobile) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.3),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/storazaar_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FiltersPopup.filterButton(
                    context,
                    onCategorySelected: widget.onCategorySelected,
                    onFiltersApplied: widget.onFiltersApplied,
                  ),
                  const SizedBox(width: 4),
                  // Product search icon (magnifying glass with circle)
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      tooltip: 'Product Search',
                      onPressed: () => _showMiniSearch('product'),
                    ),
                  ),
                  // Store search icon (also magnifying glass with circle)
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      tooltip: 'Store Search',
                      onPressed: () => _showMiniSearch('store'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: UserPrivileges.canAccessAccountPage(userTier)
                        ? PopupMenuButton<String>(
                            tooltip: 'Account options',
                            offset: const Offset(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onSelected: (value) async {
                              if (value == 'account') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AccountSettingsPage(),
                                  ),
                                );
                              } else if (value == 'logout') {
                                try {
                                  await Supabase.instance.client.auth.signOut();
                                  if (mounted) setState(() {});
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Logout failed: \\${e.toString()}')),
                                    );
                                  }
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              if (UserPrivileges.canAccessAccountPage(userTier))
                                const PopupMenuItem<String>(
                                  value: 'account',
                                  child: Text('Account'),
                                ),
                              if (userTier != UserTier.nonAccount)
                                const PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Text('Log out'),
                                ),
                            ],
                            child: Builder(
                              builder: (context) {
                                final userName = user?.userMetadata?['name'] ?? user?.email ?? '';
                                return getUserAvatar(userName, radius: 20);
                              },
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 40),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black, width: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                    minimumSize: const Size(0, 40),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AuthPage(),
                                        settings: const RouteSettings(arguments: {'signUp': true}),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ]
                else ...[
                  // MENU, 'Storazaar' TEXT, FILTERS, PRODUCT SEARCH BAR, STORE SEARCH BAR, LOGIN/ACCOUNT
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Storazaar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FiltersPopup.filterButton(
                    context,
                    onCategorySelected: widget.onCategorySelected,
                    onFiltersApplied: widget.onFiltersApplied,
                  ),
                  const SizedBox(width: 4),
                  showProductSearch
                      ? Flexible(
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 100, maxWidth: 420),
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: widget.productSearchController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search, color: Colors.black),
                                  onPressed: () {
                                    final value = widget.productSearchController?.text ?? '';
                                    if (ModalRoute.of(context)?.settings.name != '/') {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/',
                                          (route) => false,
                                          arguments: {'productSearch': value},
                                        );
                                      });
                                    } else {
                                      widget.onProductSearch?.call(value);
                                    }
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                if (ModalRoute.of(context)?.settings.name != '/') {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/',
                                      (route) => false,
                                      arguments: {'productSearch': value},
                                    );
                                  });
                                } else {
                                  widget.onProductSearch?.call(value);
                                }
                              },
                            ),
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.black),
                            tooltip: 'Product Search',
                            onPressed: () => _showMiniSearch('product'),
                          ),
                        ),
                  const SizedBox(width: 6),
                  showStoreSearch
                      ? Flexible(
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 100, maxWidth: 420),
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: widget.storeSearchController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'Search stores...',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search, color: Colors.black),
                                  onPressed: () {
                                    final value = widget.storeSearchController?.text ?? '';
                                    if (ModalRoute.of(context)?.settings.name != '/') {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/',
                                          (route) => false,
                                          arguments: {'storeSearch': value},
                                        );
                                      });
                                    } else {
                                      widget.onStoreSearch?.call(value);
                                    }
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                if (ModalRoute.of(context)?.settings.name != '/') {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/',
                                      (route) => false,
                                      arguments: {'storeSearch': value},
                                    );
                                  });
                                } else {
                                  widget.onStoreSearch?.call(value);
                                }
                              },
                            ),
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.black),
                            tooltip: 'Store Search',
                            onPressed: () => _showMiniSearch('store'),
                          ),
                        ),
                  const Spacer(),
                  if (UserPrivileges.canAccessAccountPage(userTier))
                    PopupMenuButton<String>(
                      tooltip: 'Account options',
                      offset: const Offset(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (value) async {
                        if (value == 'account') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountSettingsPage(),
                            ),
                          );
                        } else if (value == 'logout') {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(child: PageLoadingSpinner()),
                          );
                          try {
                            await Supabase.instance.client.auth.signOut();
                            if (mounted) {
                              Navigator.of(context).pop(); // Remove spinner dialog
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.of(context).pop(); // Remove spinner dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Logout failed: ${e.toString()}')),
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        if (UserPrivileges.canAccessAccountPage(userTier))
                          const PopupMenuItem<String>(
                            value: 'account',
                            child: Text('Account'),
                          ),
                        if (userTier != UserTier.nonAccount)
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Log out'),
                          ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        constraints: const BoxConstraints(minWidth: 0, maxWidth: 220, minHeight: 40),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Builder(
                              builder: (context) {
                                final userName = user?.userMetadata?['name'] ?? user?.email ?? '';
                                return getUserAvatar(userName, radius: 16);
                              },
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                user?.email ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Button side walls as close as possible to text
                        return ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 40),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthPage(),
                                  settings: const RouteSettings(arguments: {'signUp': true}),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
  }