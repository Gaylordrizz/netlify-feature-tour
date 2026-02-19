// ignore: unused_import
import '../algorithem/algorithm_flag_product.dart' as flag_product_algo;
// ignore: unused_import
import '../algorithem/algorithm_rate_product.dart' as rate_product_algo;
// --- Algorithm Integration Example ---
// Use flag_product_algo.ProductFlagSystem for product flagging/reporting logic.
// Use rate_product_algo.ProductRatingSystem for product rating logic.
// See algorithm_flag_product.dart and algorithm_rate_product.dart for details.
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  static final _client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchUserProducts(String userId) async {
    final response = await _client
        .from('products')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> updateProduct(int productId, Map<String, dynamic> data) async {
    final response = await _client
        .from('products')
        .update(data)
        .eq('id', productId);
    if (response.error != null) {
      throw Exception('Failed to update product: \\${response.error!.message}');
    }
  }
}
