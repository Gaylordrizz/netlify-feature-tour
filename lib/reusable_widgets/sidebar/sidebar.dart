import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import '../snackbar.dart';
import '../../state/app_state_provider.dart';
import '../popups/history_popup.dart';
import '../popups/saved_products_popup.dart';
import '../popups/saved_stores_popup.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../screens/settings/settings_page.dart';
import '../../screens/subscription/subscription_page.dart';
import '../../services/pro_status_service.dart';
import '../../screens/store_backend/store_backend_page.dart';
import '../../screens/community_forum/store_owner_forum_page.dart';
class GlobalSidebar extends StatelessWidget {
  const GlobalSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, size: 28),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      tooltip: AppLocalizations.of(context)?.openMenu ?? 'Open Menu',
    );
  }
}

class GlobalSidebarDrawer extends StatelessWidget {
  const GlobalSidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final loc = AppLocalizations.of(context)!;
    // Determine user tier using orders table (ProStatusService)
    return FutureBuilder<bool>(
      future: user == null ? Future.value(false) : ProStatusService.isUserPro(),
      builder: (context, snapshot) {
        UserTier userTier = UserTier.nonAccount;
        if (user != null) {
          final isPaying = snapshot.data == true;
          userTier = isPaying ? UserTier.accountPaying : UserTier.accountFree;
        }
        return Drawer(
          child: Builder(
            builder: (drawerContext) => Column(
          children: [
          // Header section with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)], // pink to gold
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/storazaar_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Menu options below header
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ...existing code...
                if (UserPrivileges.canAccessHome(userTier))
                  _buildMenuItem(
                    drawerContext,
                    icon: Icons.home,
                    title: loc.home,
                    onTap: () {
                      Navigator.pop(drawerContext);
                      Navigator.pushNamedAndRemoveUntil(drawerContext, '/', (route) => false);
                    },
                  ),
                // History, Saved Products, Saved Stores are always visible
                _buildMenuItem(
                  drawerContext,
                  icon: Icons.history,
                  title: loc.history,
                  onTap: () {
                    HistoryPopup.show(
                      drawerContext,
                      showAccountPrompt: user == null,
                    );
                  },
                ),
                _buildMenuItem(
                  drawerContext,
                  icon: Icons.bookmark,
                  title: loc.savedProducts,
                  onTap: () {
                    SavedProductsPopup.show(
                      drawerContext,
                      showAccountPrompt: user == null,
                    );
                  },
                ),
                _buildMenuItem(
                  drawerContext,
                  icon: Icons.store,
                  title: loc.savedStores,
                  onTap: () {
                    SavedStoresPopup.show(
                      drawerContext,
                      showAccountPrompt: user == null,
                    );
                  },
                ),
                // ...existing code...
                const Divider(),
                if (UserPrivileges.canAccessStoreOwnerForum(userTier))
                  _buildMenuItem(
                    context,
                    icon: Icons.forum,
                    title: loc.storeOwnerForum,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreOwnerForumPage(),
                        ),
                      );
                    },
                  ),
                if (UserPrivileges.canAccessSettings(userTier))
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: loc.settings,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                // 'Post Your Store' is always visible
                ListTile(
                  leading: Icon(
                    Icons.add_business,
                    color: Colors.grey.shade700,
                  ),
                  title: Text(
                    loc.postYourStore,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'FREE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubscriptionPage()),
                    );
                  },
                  tileColor: null,
                ),
                // Store Backend/Store Dashboard only for paying users
                if (userTier == UserTier.accountPaying)
                  _buildMenuItem(
                    context,
                    icon: Icons.analytics,
                    title: loc.storeDashboard,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoreBackendPage(
                            impressions: 1000,
                            clicks: 250,
                            visits: 0,
                            daysOnStorazaar: 0,
                            impressionsData: [],
                            clicksData: [],
                            visitsData: [],
                            daysOnStorazaarData: [],
                            productImpressionsData: {},
                            productClicksData: {},
                            productDaysSincePostedData: {},
                            productNames: [],
                            domain: 'demo.com',
                            storeName: 'Demo Store',
                            category: 'General',
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
        );
      },
    );
  }

  static Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      tileColor: null,
    );
  }
}
