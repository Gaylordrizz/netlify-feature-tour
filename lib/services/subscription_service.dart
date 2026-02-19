import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionService {
  static final _client = Supabase.instance.client;

  static Future<Map<String, dynamic>?> fetchUserSubscription(String userId) async {
    final response = await _client
        .from('subscriptions')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }
}
