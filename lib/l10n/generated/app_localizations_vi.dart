// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Cài đặt';

  @override
  String get notifications => 'Thông báo';

  @override
  String get privacy => 'Quyền riêng tư';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get helpSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get about => 'Giới thiệu';

  @override
  String get termsConditions => 'Điều khoản & Điều kiện';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String languageChanged(String language) {
    return 'Ngôn ngữ đã được đổi sang $language';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get logoutConfirm => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get loggedOut => 'Đăng xuất thành công';

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
