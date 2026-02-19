// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get language => 'Idioma';

  @override
  String get helpSupport => 'Ajuda e Suporte';

  @override
  String get about => 'Sobre';

  @override
  String get termsConditions => 'Termos e Condições';

  @override
  String get logout => 'Sair';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String languageChanged(String language) {
    return 'Idioma alterado para $language';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get logoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get loggedOut => 'Saiu com sucesso';

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
