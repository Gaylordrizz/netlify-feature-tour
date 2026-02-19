import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_language.dart';

/// User tiers for authentication and privilege management
enum UserTier {
  nonAccount,
  accountFree,
  accountPaying,
}

/// Backend privilege mapping for each user tier
class UserPrivileges {
  static bool canAccessHome(UserTier tier) => true;
  static bool canAccessHistory(UserTier tier) => tier != UserTier.nonAccount;
  static bool canSaveProducts(UserTier tier) => tier != UserTier.nonAccount;
  static bool canSaveStores(UserTier tier) => tier != UserTier.nonAccount;
  static bool canAccessSettings(UserTier tier) => true;
  static bool canAccessAccountPage(UserTier tier) => tier != UserTier.nonAccount;
  static bool canPostStore(UserTier tier) => tier == UserTier.accountFree;
  static bool canAccessStoreDashboard(UserTier tier) => tier == UserTier.accountPaying;
  static bool canAccessStoreOwnerForum(UserTier tier) => tier == UserTier.accountPaying;
}

class AppState extends StatefulWidget {
  final Widget child;
  const AppState({required this.child, Key? key}) : super(key: key);

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppLanguage(),
      child: widget.child,
    );
  }
}
