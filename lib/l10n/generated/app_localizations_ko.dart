// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '스토라자르';

  @override
  String get settings => '설정';

  @override
  String get notifications => '알림';

  @override
  String get privacy => '개인정보';

  @override
  String get language => '언어';

  @override
  String get helpSupport => '도움말 및 지원';

  @override
  String get about => '정보';

  @override
  String get termsConditions => '이용 약관';

  @override
  String get logout => '로그아웃';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String languageChanged(String language) {
    return '언어가 $language(으)로 변경되었습니다';
  }

  @override
  String get cancel => '취소';

  @override
  String get logoutConfirm => '정말 로그아웃하시겠습니까?';

  @override
  String get loggedOut => '성공적으로 로그아웃되었습니다';

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
