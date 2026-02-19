// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'স্টোরাজার';

  @override
  String get settings => 'সেটিংস';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get privacy => 'গোপনীয়তা';

  @override
  String get language => 'ভাষা';

  @override
  String get helpSupport => 'সহায়তা ও সমর্থন';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get termsConditions => 'শর্তাবলী';

  @override
  String get logout => 'লগ আউট';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String languageChanged(String language) {
    return 'ভাষা $language এ পরিবর্তন হয়েছে';
  }

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get logoutConfirm => 'আপনি কি নিশ্চিত যে আপনি লগ আউট করতে চান?';

  @override
  String get loggedOut => 'সফলভাবে লগ আউট হয়েছে';

  @override
  String get openMenu => 'মেনু খুলুন';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get home => 'হোম';

  @override
  String get history => 'ইতিহাস';

  @override
  String get savedProducts => 'সংরক্ষিত পণ্যসমূহ';

  @override
  String get savedStores => 'সংরক্ষিত দোকানসমূহ';

  @override
  String get productView => 'পণ্য দেখুন';

  @override
  String get storeProfile => 'দোকানের প্রোফাইল';

  @override
  String get storeOwnerForum => 'দোকান মালিক ফোরাম';

  @override
  String get postYourStore => 'আপনার দোকান পোস্ট করুন';

  @override
  String get storeDashboard => 'দোকান ড্যাশবোর্ড';
}
