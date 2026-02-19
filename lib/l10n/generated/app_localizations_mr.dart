// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'स्टोराजार';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get notifications => 'सूचना';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get language => 'भाषा';

  @override
  String get helpSupport => 'मदत आणि समर्थन';

  @override
  String get about => 'विषयी';

  @override
  String get termsConditions => 'अटी आणि शर्ती';

  @override
  String get logout => 'बाहेर पडा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String languageChanged(String language) {
    return 'भाषा $language मध्ये बदलली आहे';
  }

  @override
  String get cancel => 'रद्द करा';

  @override
  String get logoutConfirm => 'आपण खरोखरच बाहेर पडू इच्छिता?';

  @override
  String get loggedOut => 'यशस्वीरित्या बाहेर पडले';

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
