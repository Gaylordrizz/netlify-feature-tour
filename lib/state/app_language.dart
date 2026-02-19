import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  static AppLanguage of(BuildContext context, {bool listen = false}) {
    return Provider.of<AppLanguage>(context, listen: listen);
  }

  static const supportedLocales = [
    Locale('en'), // English
    Locale('zh'), // 中文（普通话）
    Locale('es'), // Español
    Locale('hi'), // हिन्दी
    Locale('ar'), // العربية
    Locale('fr'), // Français
    Locale('bn'), // বাংলা
    Locale('pt'), // Português
    Locale('ru'), // Русский
    Locale('ur'), // اردو
    Locale('id'), // Bahasa Indonesia
    Locale('de'), // Deutsch
    Locale('ja'), // 日本語
    Locale('pa'), // ਪੰਜਾਬੀ
    Locale('mr'), // मराठी
    Locale('te'), // తెలుగు
    Locale('tr'), // Türkçe
    Locale('ko'), // 한국어
    Locale('vi'), // Tiếng Việt
    Locale('it'), // Italiano
    Locale('no'), // Norsk
  ];

  Locale get appLocale => _appLocale;

  void changeLanguage(String languageCode) {
    if (languageCode == _appLocale.languageCode) return;
    _appLocale = Locale(languageCode);
    notifyListeners();
  }
}
