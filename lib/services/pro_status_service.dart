import 'package:supabase_flutter/supabase_flutter.dart';

class ProStatusService {
  static final _client = Supabase.instance.client;

  static Future<bool> isUserPro() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;
      final data = await _client
          .from('orders')
          .select('status')
          .eq('user_id', userId)
          .eq('status', 'active')
          .maybeSingle();
      return data != null;
    } catch (e) {
      print("Error checking pro status: $e");
      return false;
    }
  }
}
