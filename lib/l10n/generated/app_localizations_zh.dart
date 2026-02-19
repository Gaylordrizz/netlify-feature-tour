// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get privacy => '隐私';

  @override
  String get language => '语言';

  @override
  String get helpSupport => '帮助与支持';

  @override
  String get about => '关于';

  @override
  String get termsConditions => '条款和条件';

  @override
  String get logout => '退出登录';

  @override
  String get selectLanguage => '选择语言';

  @override
  String languageChanged(String language) {
    return '语言已更改为$language';
  }

  @override
  String get cancel => '取消';

  @override
  String get logoutConfirm => '您确定要退出登录吗？';

  @override
  String get loggedOut => '已成功退出登录';

  @override
  String get openMenu => 'Open Menu';

  @override
  String get account => 'Account';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get savedProducts => 'Saved Products';

  @override
  String get savedStores => 'Saved Stores';

  @override
  String get productView => 'Product View';

  @override
  String get storeProfile => 'Store Profile';

  @override
  String get storeOwnerForum => 'Store Owner Forum';

  @override
  String get postYourStore => 'Post Your Store';

  @override
  String get storeDashboard => 'Store Dashboard';
}
