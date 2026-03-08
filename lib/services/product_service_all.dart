import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
    static Future<List<Map<String, dynamic>>> fetchProductsByStoreDomain(String storeDomain) async {
      final response = await _client
          .from('products')
          .select()
          .eq('store_domain', storeDomain)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    }
  static final _client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final response = await _client
        .from('products')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
