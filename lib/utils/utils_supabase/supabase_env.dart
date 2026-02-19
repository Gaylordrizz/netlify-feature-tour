import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUtils {
  static const String supabaseUrl = 'https://ltbmbvsvdghrignsegod.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0Ym1idnN2ZGdocmlnbnNlZ29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5OTczMzIsImV4cCI6MjA3ODU3MzMzMn0.elXcLdZuqo062oGs8BhsZMup7_cexbut3zkUTI6nvLU';

  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
