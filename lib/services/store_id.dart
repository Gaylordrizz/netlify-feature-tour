
/// =======================================
/// Store Public ID Generator
/// =======================================
/// Generates a human-readable, globally-unique store ID
/// Format: S-{RandomID}
/// Example: S-1g68-aB1g-GH0a-z5D9
///
/// Usage:
/// final storeId = generateStoreId();
///
/// repo.insert('stores', {
///   'store_id': storeId,
///   'name': storeName,
///   ...
/// });
///
/// Display:
/// Text('Store ID: $storeId');


import 'dart:math';
import 'product_id.dart';

String generateStoreId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();
  String block(int length) => List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  final id = [
    block(4),
    block(4),
    block(4),
    block(4),
    block(4),
  ].join('-');
  return 'S-$id';
}

// ...existing product ID logic below...

String generateProductIdWithStorePrefix(String storeName) {
  if (storeName.isEmpty) return generateProductId(); // fallback if no store name

  final String prefix = storeName[0].toUpperCase(); // first letter of store

  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();

  String randomBlock(int length) => List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();

  // Generate 5 blocks of 4 chars (total 20 chars)
  String randomId = [
    randomBlock(4),
    randomBlock(4),
    randomBlock(4),
    randomBlock(4),
    randomBlock(4),
  ].join('-');

  return '$prefix-$randomId';
}
