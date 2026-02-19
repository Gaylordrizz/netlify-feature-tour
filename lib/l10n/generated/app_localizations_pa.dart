// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਸਟੋਰਾਜ਼ਾਰ';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get notifications => 'ਨੋਟੀਫਿਕੇਸ਼ਨ';

  @override
  String get privacy => 'ਪਰਦੇਦਾਰੀ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get helpSupport => 'ਮਦਦ ਅਤੇ ਸਹਾਇਤਾ';

  @override
  String get about => 'ਬਾਰੇ';

  @override
  String get termsConditions => 'ਨਿਯਮ ਅਤੇ ਸ਼ਰਤਾਂ';

  @override
  String get logout => 'ਲੌਗ ਆਉਟ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String languageChanged(String language) {
    return 'ਭਾਸ਼ਾ $language ਵਿੱਚ ਬਦਲੀ ਗਈ ਹੈ';
  }

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get logoutConfirm => 'ਕੀ ਤੁਸੀਂ ਯਕੀਨਨ ਲੌਗ ਆਉਟ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?';

  @override
  String get loggedOut => 'ਸਫਲਤਾਪੂਰਵਕ ਲੌਗ ਆਉਟ ਹੋ ਗਿਆ';

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
