// Supabase Auth Helper for Flutter
//
// This class provides:
// 1. Signup with email confirmation (uses {{.ConfirmationUrl}} in the Supabase email template)
// 2. Password reset flow (uses {{ .Token }} in the Supabase forgot password email template for 6-digit code)
// 3. Recovery session / no-redirect protection
//
// Make sure the following URLs are added in Supabase (Auth Settings > Redirect URLs):
//   https://storazaar.com
//   https://storazaar.com/auth
//   https://storazaar.com/
//   https://storazaar.com/**
//
// In your Supabase email templates:
//   Use {{.ConfirmationUrl}} for sign-up confirmation emails.
//   Use {{ .Token }} for password reset emails (6-digit code flow).
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
class SupabaseAuthRedirects {
    // ...existing code...
  static const List<String> redirectUrls = [
    'https://storazaar.com',
    'https://storazaar.com/auth',
    'https://storazaar.com/',
    'https://storazaar.com/**', // wildcard for mobile apps
    'https://storazaar.com/stripe-success-post-store', // specific redirect for Stripe success
  ];

  static SupabaseClient get _supabase => Supabase.instance.client;

  // Initialize deep link and auth state listener for Supabase
  // Call this once after Supabase.initialize, passing your navigatorKey.
  static void initDeepLinkListener(GlobalKey<NavigatorState> navigatorKey) {
    // Listen for Supabase auth state changes
    _supabase.auth.onAuthStateChange.listen((event) {
      // Example: print('Auth state changed: \\${event.event}');
      // You can add custom logic here if needed, e.g. navigation or logging
    });

    // Listen for incoming deep links (using app_links package)
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.path == '/create-new-password') {
          navigatorKey.currentState?.pushNamed('/create-new-password');
        } else if (uri.path == '/auth') {
          navigatorKey.currentState?.pushNamed('/auth');
        }
      }
    });
  }

  // Sign in with magic link (OTP)
  static Future<void> signInWithEmail(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: redirectUrls[0], // main landing page
    );
  }

  // Password reset (send reset link)
  // The Supabase forgot password email template should use {{ .Token }} for the 6-digit code flow.
  static Future<void> resetPassword(String email) async {
    // This sends a 6-digit code to the user's email for password reset.
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Send password reset email and print confirmation
  static Future<void> sendPasswordReset(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
    print('Password reset email sent.');
  }

  // Sign up or OAuth with redirect
  // The Supabase sign-up confirmation email template should use {{.ConfirmationUrl}} for the confirmation link.
  static Future<void> signUpOrOAuth(String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirectUrls[1], // auth page
    );
  }
}