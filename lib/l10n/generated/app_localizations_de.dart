// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get language => 'Sprache';

  @override
  String get helpSupport => 'Hilfe & Support';

  @override
  String get about => 'Über';

  @override
  String get termsConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String languageChanged(String language) {
    return 'Sprache geändert zu $language';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get logoutConfirm => 'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get loggedOut => 'Erfolgreich abgemeldet';

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
