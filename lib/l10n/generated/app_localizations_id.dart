// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Pengaturan';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get privacy => 'Privasi';

  @override
  String get language => 'Bahasa';

  @override
  String get helpSupport => 'Bantuan & Dukungan';

  @override
  String get about => 'Tentang';

  @override
  String get termsConditions => 'Syarat & Ketentuan';

  @override
  String get logout => 'Keluar';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String languageChanged(String language) {
    return 'Bahasa diubah ke $language';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get loggedOut => 'Berhasil keluar';

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
