// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्टोराजार';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get language => 'भाषा';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get about => 'के बारे में';

  @override
  String get termsConditions => 'नियम और शर्तें';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String languageChanged(String language) {
    return 'भाषा $language में बदल गई है';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get loggedOut => 'सफलतापूर्वक लॉग आउट किया गया';

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
