// ignore: unused_import
import '../algorithem/algorithm_flag_store.dart' as flag_store_algo;
// ignore: unused_import
import '../algorithem/algorithm_rate_store.dart' as rate_store_algo;
// --- Algorithm Integration Example ---
// Use flag_store_algo.StoreFlagSystem for store flagging/reporting logic.
// Use rate_store_algo.StoreRatingSystem for store rating logic.
// See algorithm_flag_store.dart and algorithm_rate_store.dart for details.
import 'package:supabase_flutter/supabase_flutter.dart';


class StoreService {
  static final _client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchAllStores() async {
    final response = await _client
        .from('stores')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>?> fetchUserStore(String userId) async {
    final response = await _client
        .from('stores')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }

  static Future<void> updateUserStore(String userId, Map<String, dynamic> data) async {
    final response = await _client
        .from('stores')
        .update(data)
        .eq('user_id', userId);
    if (response.error != null) {
      throw Exception('Failed to update store: \\${response.error!.message}');
    }
  }
}
