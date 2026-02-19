import 'package:flutter/material.dart';
// import 'settings_widgets/security_settings_page.dart';
import 'settings_widgets/notifications_settings_page.dart';
import '../privacy_policy_page.dart';
import 'settings_widgets/help_support_settings_page.dart';
import 'settings_widgets/about_settings_page.dart';
import 'settings_widgets/terms_conditions_settings_page.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/app_language.dart';
import '../../reusable_widgets/snackbar.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final settingsOptions = [
      {'title': loc.notifications, 'icon': Icons.notifications},
      {'title': loc.privacy, 'icon': Icons.privacy_tip},
      {'title': loc.language, 'icon': Icons.language},
      {'title': loc.helpSupport, 'icon': Icons.help},
      {'title': loc.about, 'icon': Icons.info},
      {'title': loc.termsConditions, 'icon': Icons.description},
    ];

    // Split into two balanced columns
    final midpoint = (settingsOptions.length / 2).ceil();
    final leftColumn = settingsOptions.sublist(0, midpoint);
    final rightColumn = settingsOptions.sublist(midpoint);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(loc.settings),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Removed duplicate title since AppBar now handles it
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      child: _buildSettingsColumn(context, leftColumn),
                    ),
                    const SizedBox(width: 16),
                    // Right column
                    Expanded(
                      child: _buildSettingsColumn(context, rightColumn),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsColumn(BuildContext context, List<Map<String, dynamic>> options) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final loc = AppLocalizations.of(context)!;
        final option = options[index];
        final String title = option['title'];
        final IconData icon = option['icon'];
        final bool isLogout = title == loc.logout;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.04),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            leading: Icon(icon, color: isLogout ? Colors.red : Color(0xFF444444), size: 22),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: isLogout ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            onTap: () {
              if (isLogout) {
                _showLogoutDialog(context);
              } else if (title == loc.language) {
                _showLanguagePicker(context);
              } else if (title == loc.notifications) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsSettingsPage()),
                );
              } else if (title == loc.privacy) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              } else if (title == loc.helpSupport) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportSettingsPage()),
                );
              } else if (title == loc.about) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutSettingsPage()),
                );
              } else if (title == loc.termsConditions) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsConditionsSettingsPage()),
                );
              } else {
                // Fallback for any unhandled cases
                showCustomSnackBar(context, '$title - ${loc.languageChanged(title)}', positive: true);
              }
            },
          ),
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final currentLocale = AppLanguage.of(context, listen: false).appLocale;
    final locales = AppLanguage.supportedLocales;
    final languageNames = <String, String>{
      'en': 'English',
      'zh': '中文（普通话）',
      'es': 'Español',
      'hi': 'हिन्दी',
      'ar': 'العربية',
      'fr': 'Français',
      'bn': 'বাংলা',
      'pt': 'Português',
      'ru': 'Русский',
      'ur': 'اردو',
      'id': 'Bahasa Indonesia',
      'de': 'Deutsch',
      'ja': '日本語',
      'pa': 'ਪੰਜਾਬੀ',
      'mr': 'मराठी',
      'te': 'తెలుగు',
      'tr': 'Türkçe',
      'ko': '한국어',
      'vi': 'Tiếng Việt',
      'it': 'Italiano',
      'no': 'Norsk',
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(loc.selectLanguage),
          content: SizedBox(
            width: 500, // Match sign up tile maxWidth
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: locales.length,
              separatorBuilder: (context, i) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final locale = locales[i];
                final code = locale.languageCode;
                final name = languageNames[code] ?? code;
                final isSelected = locale == currentLocale;
                final isSupported = code == 'en';
                return ListTile(
                  title: Text(name,
                    style: TextStyle(
                      color: isSupported ? Colors.black : Colors.grey,
                    ),
                  ),
                  trailing: isSelected && isSupported ? const Icon(Icons.check, color: Colors.blue) : null,
                  enabled: isSupported,
                  onTap: () {
                    Navigator.pop(context);
                    if (code == 'en') {
                      AppLanguage.of(context, listen: false).changeLanguage(code);
                      showCustomSnackBar(context, loc.languageChanged(name), positive: true);
                    } else {
                      showCustomSnackBar(context, "Cette langue n'est pas encore disponible. Bientôt.", positive: false);
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                loc.cancel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Removed unused _showThemeDialog method

  void _showLogoutDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(loc.logout),
          ],
        ),
        content: Text(loc.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel, style: const TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.loggedOut)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(loc.logout),
          ),
        ],
      ),
    );
  }
}
