import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_tables_contents.dart';

class CommunityService {
  static final _client = Supabase.instance.client;

  /// Creates a new community (chat room) and returns its id.
  static Future<String?> createCommunity({
    required String name,
    required String slug,
    required String? creatorId,
  }) async {
    final response = await _client
        .from(SupabaseTables.communities)
        .insert({
          'name': name,
          'slug': slug,
          'creator_id': creatorId,
        })
        .select()
        .single();
    if (response['id'] == null) return null;
    return response['id'] as String;
  }

  /// Searches for communities using a Supabase RPC (Postgres function)
  static Future<List<Community>> searchCommunities(String query) async {
    final results = await _client.rpc('search_communities', params: {'query': query});
    return (results as List)
        .map((json) => Community.fromJson(json))
        .toList();
  }
}
