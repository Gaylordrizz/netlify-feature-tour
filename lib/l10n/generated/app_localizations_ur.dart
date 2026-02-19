// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'اسٹورازار';

  @override
  String get settings => 'ترتیبات';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get privacy => 'رازداری';

  @override
  String get language => 'زبان';

  @override
  String get helpSupport => 'مدد اور معاونت';

  @override
  String get about => 'کے بارے میں';

  @override
  String get termsConditions => 'شرائط و ضوابط';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String languageChanged(String language) {
    return 'زبان $language میں تبدیل ہوگئی ہے';
  }

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get logoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get loggedOut => 'کامیابی سے لاگ آؤٹ ہوگیا';

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
