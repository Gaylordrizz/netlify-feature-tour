// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Настройки';

  @override
  String get notifications => 'Уведомления';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get language => 'Язык';

  @override
  String get helpSupport => 'Помощь и поддержка';

  @override
  String get about => 'О приложении';

  @override
  String get termsConditions => 'Условия и положения';

  @override
  String get logout => 'Выйти';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String languageChanged(String language) {
    return 'Язык изменён на $language';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get loggedOut => 'Вы успешно вышли из системы';

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
