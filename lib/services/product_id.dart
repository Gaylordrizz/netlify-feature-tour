/// =======================================
/// Product Public ID Generator
/// =======================================
/// Generates a human-readable, globally-unique product ID
/// Safe for billions of products
/// Displayed on the product view page under the price
///
/// Format:
/// ID: 8Ga4-B197-fJ90-64zk-eR3h
///

/// Example usage:
/// 
/// ```dart
/// // Generate a product ID
/// final productId = generateProductId();
/// 
/// // Insert into database
/// repo.insert('products', {
///   'name': productName,
///   'price': price,
///   'public_id': productId,
/// });
/// 
/// // Display in UI
/// Text(productId); // Shows: ID: 8Ga4-B197-fJ90-64zk-eR3h
/// ```

import 'dart:math';

String generateProductId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();

  String block(int length) =>
      List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();

  final id = [
    block(4),
    block(4),
    block(4),
    block(4),
    block(4),
  ].join('-');
  return 'ID: $id';
}
