
import 'screens/auth/check_email_page.dart';
import 'screens/auth/auth_page.dart';
import 'screens/privacy_policy_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'state/app_language.dart';
import 'screens/home/home_page.dart';
import 'screens/settings/settings_widgets/account_settings_page.dart' as account_settings;
import 'screens/settings/settings_widgets/security_settings_page.dart';
import 'screens/settings/settings_widgets/password_settings_page.dart';
import 'screens/settings/settings_widgets/notifications_settings_page.dart';
import 'screens/settings/settings_widgets/payment_methods_settings_page.dart';
import 'screens/settings/settings_widgets/subscription_billing_settings_page.dart';
import 'screens/settings/settings_widgets/connected_devices_settings_page.dart';
import 'screens/settings/settings_widgets/data_storage_settings_page.dart';
import 'screens/settings/settings_widgets/help_support_settings_page.dart';
import 'screens/settings/settings_widgets/about_settings_page.dart';
import 'screens/settings/settings_widgets/terms_conditions_settings_page.dart';
import 'screens/subscription/subscription_page.dart';
import 'screens/settings/settings_widgets/forgot_password_page.dart';
import 'screens/auth/password_changed_page.dart';
import 'screens/auth/create_new_password_page.dart';
import 'screens/post_your_store/post_your_store_page.dart';
import 'utils/utils_supabase/supabase_env.dart';
import 'utils/deep_link_handler.dart';

// Add for Flutter web path URL strategy




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // Enable path URL strategy for Flutter web
  await SupabaseUtils.initialize();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => AppLanguage(),
        child: DeepLinkHandler(child: const StorazaarApp()),
      ),
    ),
  );
}



class StorazaarApp extends StatelessWidget {
  const StorazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguage.of(context, listen: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storazaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: appLanguage.appLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/check-email': (context) => const CheckEmailPage(),
        '/settings/account': (context) => const account_settings.AccountSettingsPage(),
        '/settings/security': (context) => const SecuritySettingsPage(),
        '/settings/password': (context) => const PasswordSettingsPage(),
        '/settings/notifications': (context) => const NotificationsSettingsPage(),
        '/settings/privacy': (context) => const PrivacyPolicyPage(),
        '/settings/payment-methods': (context) => const PaymentMethodsSettingsPage(),
        '/settings/subscription-billing': (context) => const SubscriptionBillingSettingsPage(),
        '/settings/connected-devices': (context) => const ConnectedDevicesSettingsPage(),
        '/settings/data-storage': (context) => const DataStorageSettingsPage(),
        '/settings/help-support': (context) => const HelpSupportSettingsPage(),
        '/settings/about': (context) => const AboutSettingsPage(),
        '/settings/terms-conditions': (context) => const TermsConditionsSettingsPage(),
        '/privacy_settings': (context) => const PrivacyPolicyPage(),
        '/terms_conditions_settings': (context) => const TermsConditionsSettingsPage(),
        '/password-changed': (context) => const PasswordChangedPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/create-new-password': (context) => const CreateNewPasswordPage(),
        '/subscription': (context) => SubscriptionPage(),
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const AuthPage(),
        '/signup': (context) => const AuthPage(),
        '/post-your-store': (context) => const PostYourStorePage(),
      },
         onGenerateRoute: (settings) {
           // Always show PostYourStorePage for any /post-your-store route, even with query params
           if (settings.name != null && settings.name!.startsWith('/post-your-store')) {
             return MaterialPageRoute(
               builder: (context) => const PostYourStorePage(),
               settings: settings,
             );
           }
           if (settings.name == '/login') {
             return MaterialPageRoute(
               builder: (context) => const AuthPage(),
               settings: const RouteSettings(arguments: {'signIn': true}),
             );
           }
           if (settings.name == '/signup') {
             return MaterialPageRoute(
               builder: (context) => const AuthPage(),
               settings: const RouteSettings(arguments: {'signUp': true}),
             );
           }
           return null;
         },
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
    );
  }
}