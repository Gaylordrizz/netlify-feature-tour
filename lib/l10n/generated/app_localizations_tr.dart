// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Ayarlar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get language => 'Dil';

  @override
  String get helpSupport => 'Yardım ve Destek';

  @override
  String get about => 'Hakkında';

  @override
  String get termsConditions => 'Şartlar ve Koşullar';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String languageChanged(String language) {
    return 'Dil $language olarak değiştirildi';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get logoutConfirm => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get loggedOut => 'Başarıyla çıkış yapıldı';

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
