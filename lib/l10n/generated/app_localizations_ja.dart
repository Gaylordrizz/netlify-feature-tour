// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => '設定';

  @override
  String get notifications => '通知';

  @override
  String get privacy => 'プライバシー';

  @override
  String get language => '言語';

  @override
  String get helpSupport => 'ヘルプとサポート';

  @override
  String get about => '情報';

  @override
  String get termsConditions => '利用規約';

  @override
  String get logout => 'ログアウト';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String languageChanged(String language) {
    return '言語が$languageに変更されました';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get logoutConfirm => '本当にログアウトしますか？';

  @override
  String get loggedOut => '正常にログアウトしました';

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
