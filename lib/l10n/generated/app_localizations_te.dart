// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'స్టోరాజార్';

  @override
  String get settings => 'సెట్టింగ్స్';

  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get privacy => 'గోప్యత';

  @override
  String get language => 'భాష';

  @override
  String get helpSupport => 'సహాయం & మద్దతు';

  @override
  String get about => 'గురించి';

  @override
  String get termsConditions => 'నిబంధనలు & షరతులు';

  @override
  String get logout => 'లాగ్ అవుట్';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';

  @override
  String languageChanged(String language) {
    return 'భాష $languageకి మార్చబడింది';
  }

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get logoutConfirm => 'మీరు నిజంగా లాగ్ అవుట్ కావాలనుకుంటున్నారా?';

  @override
  String get loggedOut => 'విజయవంతంగా లాగ్ అవుట్ అయ్యారు';

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
