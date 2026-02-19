// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
/// Header and search bars
class AppLocalizationsNo extends AppLocalizations {
    String get login => 'Logg inn';

    String get signUp => 'Registrer deg';
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  String get headerTitle => 'Storazaar';

  String get searchProductBarHint => 'Søk etter et produkt';

  String get searchStoreBarHint => 'Søk etter en butikk';
/// Sidebar
  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Innstillinger';

  @override
  String get notifications => 'Varsler';

  @override
  String get privacy => 'Personvern';

  @override
  String get language => 'Språk';

  @override
  String get helpSupport => 'Hjelp og støtte';

  @override
  String get about => 'Om';

  @override
  String get termsConditions => 'Vilkår og betingelser';

  @override
  String get logout => 'Logg ut';

  @override
  String get selectLanguage => 'Velg språk';
/// Snackbar
  @override
  String languageChanged(String language) {
    return 'Språk endret til $language';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String get logoutConfirm => 'Er du sikker på at du vil logge ut?';

  @override
  String get loggedOut => 'Logget ut vellykket';

  @override
  String get openMenu => 'Åpne meny';

  @override
  String get account => 'Konto';

  @override
  String get home => 'Hjem';

  @override
  String get history => 'Historikk';

  @override
  String get savedProducts => 'Lagrede produkter';

  @override
  String get savedStores => 'Lagrede butikker';

  @override
  String get productView => 'Produktvisning';

  @override
  String get storeProfile => 'Butikkprofil';

  @override
  String get storeOwnerForum => 'Butikkeierforum';

  @override
  String get postYourStore => 'Legg ut butikken din';

  @override
  String get storeDashboard => 'Butikkdashbord';
}
