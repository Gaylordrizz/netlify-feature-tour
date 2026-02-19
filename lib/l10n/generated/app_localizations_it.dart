// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Impostazioni';

  @override
  String get notifications => 'Notifiche';

  @override
  String get privacy => 'Privacy';

  @override
  String get language => 'Lingua';

  @override
  String get helpSupport => 'Aiuto e supporto';

  @override
  String get about => 'Informazioni';

  @override
  String get termsConditions => 'Termini e condizioni';

  @override
  String get logout => 'Disconnettersi';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String languageChanged(String language) {
    return 'Lingua cambiata in $language';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get logoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get loggedOut => 'Disconnessione avvenuta con successo';

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
