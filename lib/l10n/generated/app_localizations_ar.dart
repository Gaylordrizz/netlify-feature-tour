// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ستورازار';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get language => 'اللغة';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get about => 'حول';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String languageChanged(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get loggedOut => 'تم تسجيل الخروج بنجاح';

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
