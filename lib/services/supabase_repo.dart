import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_tables_contents.dart';

class SupabaseRepo {
	final _db = Supabase.instance.client;

	  Future<List<Map<String, dynamic>>> getAll(String table) =>
		  _db.from(table).select();

	  Future<Map<String, dynamic>?> getById(String table, String id) =>
		  _db.from(table).select().eq('id', id).single();

	  Future<void> insert(String table, Map<String, dynamic> data) =>
		  _db.from(table).insert(data);

	  Future<void> update(String table, String id, Map<String, dynamic> data) =>
		  _db.from(table).update(data).eq('id', id);

	  Future<void> delete(String table, String id) =>
		  _db.from(table).delete().eq('id', id);
}

// --- Supabase Table Helper Methods ---
// These are ready-to-use static helpers for common table operations.
class SupabaseTableHelpers {
	static final repo = SupabaseRepo();

	static Future<void> logAnalyticsEvent({
		required String userId,
		required String entityType,
		required String eventType,
		String? productId,
		String? storeId,
	}) async {
		await repo.insert(SupabaseTables.analyticsEvents, {
			'user_id': userId,
			'entity_type': entityType,
			'event_type': eventType,
			if (productId != null) 'product_id': productId,
			if (storeId != null) 'store_id': storeId,
		});
	}

	static Future<void> flagProduct({
		required String productId,
		required String userId,
		required String reason,
	}) async {
		await repo.insert(SupabaseTables.productFlags, {
			'product_id': productId,
			'user_id': userId,
			'reason': reason,
		});
	}

	static Future<void> rateProduct({
		required String productId,
		required String userId,
		required int rating,
		String reviewText = '',
	}) async {
		await repo.insert(SupabaseTables.productRating, {
			'product_id': productId,
			'user_id': userId,
			'rating': rating,
			'review_text': reviewText,
		});
	}

	static Future<void> updateProductStats({
		required String productId,
		int? impressions,
		int? clicks,
		num? ratingAvg,
	}) async {
		final data = <String, dynamic>{};
		if (impressions != null) data['impressions'] = impressions;
		if (clicks != null) data['clicks'] = clicks;
		if (ratingAvg != null) data['rating_avg'] = ratingAvg;
		await repo.update(SupabaseTables.productStats, productId, data);
	}

	static Future<void> updateProductVisibilityCooldown({
		required String cooldownId,
		required DateTime lastShownAt,
	}) async {
		await repo.update(SupabaseTables.productVisibilityCooldowns, cooldownId, {
			'last_shown_at': lastShownAt.toIso8601String(),
		});
	}

	static Future<void> createProduct({
		required String storeId,
		required String name,
		required num price,
		String? productUrl,
		String? imageUrl,
	}) async {
		await repo.insert(SupabaseTables.products, {
			'store_id': storeId,
			'name': name,
			'price': price,
			if (productUrl != null) 'product_url': productUrl,
			if (imageUrl != null) 'image_url': imageUrl,
		});
	}

	static Future<void> updateProfile({
		required String userId,
		String? name,
		String? email,
		bool? isPaying,
	}) async {
		final data = <String, dynamic>{};
		if (name != null) data['name'] = name;
		if (email != null) data['email'] = email;
		if (isPaying != null) data['is_paying'] = isPaying;
		await repo.update(SupabaseTables.profiles, userId, data);
	}

	static Future<void> flagStore({
		required String storeId,
		required String userId,
		required String reason,
	}) async {
		await repo.insert(SupabaseTables.storeFlags, {
			'store_id': storeId,
			'user_id': userId,
			'reason': reason,
		});
	}

	static Future<void> rateStore({
		required String storeId,
		required String userId,
		required int rating,
		String? reviewText,
	}) async {
		await repo.insert(SupabaseTables.storeRatings, {
			'store_id': storeId,
			'user_id': userId,
			'rating': rating,
			'review_text': reviewText ?? '',
		});
	}

	static Future<void> updateStoreStats({
		required String storeId,
		int? impressions,
		int? clicks,
		int? visits,
	}) async {
		final data = <String, dynamic>{};
		if (impressions != null) data['impressions'] = impressions;
		if (clicks != null) data['clicks'] = clicks;
		if (visits != null) data['visits'] = visits;
		await repo.update(SupabaseTables.storeStats, storeId, data);
	}

	static Future<void> createStore({
		required String ownerId,
		required String name,
		String? storeUrl,
	}) async {
		await repo.insert(SupabaseTables.stores, {
			'owner_id': ownerId,
			'name': name,
			if (storeUrl != null) 'store_url': storeUrl,
		});
	}

	static Future<void> addUserProductHistory({
		required String userId,
		required String productId,
		DateTime? viewedAt,
	}) async {
		await repo.insert(SupabaseTables.userProductHistory, {
			'user_id': userId,
			'product_id': productId,
			'viewed_at': (viewedAt ?? DateTime.now()).toIso8601String(),
		});
	}

	static Future<void> addUserSavedProduct({
		required String userId,
		required String productId,
		DateTime? savedAt,
	}) async {
		await repo.insert(SupabaseTables.userSavedProducts, {
			'user_id': userId,
			'product_id': productId,
			'saved_at': (savedAt ?? DateTime.now()).toIso8601String(),
		});
	}

	static Future<void> addUserSavedStore({
		required String userId,
		required String storeId,
		DateTime? savedAt,
	}) async {
		await repo.insert(SupabaseTables.userSavedStores, {
			'user_id': userId,
			'store_id': storeId,
			'saved_at': (savedAt ?? DateTime.now()).toIso8601String(),
		});
	}

	static Future<void> addUserStoreHistory({
		required String userId,
		required String storeId,
		DateTime? visitedAt,
	}) async {
		await repo.insert(SupabaseTables.userStoreHistory, {
			'user_id': userId,
			'store_id': storeId,
			'visited_at': (visitedAt ?? DateTime.now()).toIso8601String(),
		});
	}

	// --- New Helper Methods ---

	static Future<void> createPasswordResetCode({
		required String email,
		required String code,
		required DateTime expiresAt,
	}) async {
		await repo.insert(SupabaseTables.passwordResetCodes, {
			'email': email,
			'code': code,
			'expires_at': expiresAt.toIso8601String(),
		});
	}

	static Future<void> createOrder({
		String? userId,
		String? stripeSessionId,
		String? stripePaymentIntentId,
		String? stripeSubscriptionId,
		required int amount,
		String currency = 'usd',
		String status = 'pending',
		DateTime? createdAt,
        String? stripeCustomerId,
	}) async {
		await repo.insert(SupabaseTables.orders, {
			'user_id': userId,
			'stripe_session_id': stripeSessionId,
			'stripe_payment_intent_id': stripePaymentIntentId,
			'stripe_subscription_id': stripeSubscriptionId,
			'amount': amount,
			'currency': currency,
			'status': status,
			'created_at': createdAt?.toIso8601String(),
            'stripe_customer_id': stripeCustomerId,
		});
	}

	static Future<void> updateOrder({
		required String orderId,
		String? userId,
		String? stripeSessionId,
		String? stripePaymentIntentId,
		String? stripeSubscriptionId,
		int? amount,
		String? currency,
		String? status,
		DateTime? createdAt,
		String? stripeCustomerId,
	}) async {
		final data = <String, dynamic>{};
		if (userId != null) data['user_id'] = userId;
		if (stripeSessionId != null) data['stripe_session_id'] = stripeSessionId;
		if (stripePaymentIntentId != null) data['stripe_payment_intent_id'] = stripePaymentIntentId;
		if (stripeSubscriptionId != null) data['stripe_subscription_id'] = stripeSubscriptionId;
		if (amount != null) data['amount'] = amount;
		if (currency != null) data['currency'] = currency;
		if (status != null) data['status'] = status;
		if (createdAt != null) data['created_at'] = createdAt.toIso8601String();
		if (stripeCustomerId != null) data['stripe_customer_id'] = stripeCustomerId;
		await repo.update(SupabaseTables.orders, orderId, data);
	}

	static Future<void> deleteOrder({
		required String orderId,
	}) async {
		await repo.delete(SupabaseTables.orders, orderId);
	}

	static Future<void> addUserPhoto({
		required String userId,
		required String filePath,
		String? description,
		bool? isPublic,
		DateTime? createdAt,
	}) async {
		await repo.insert(SupabaseTables.userPhotos, {
			'user_id': userId,
			'file_path': filePath,
			'description': description,
			'is_public': isPublic,
			'created_at': createdAt?.toIso8601String(),
		});
	}

	static Future<void> createInvoice({
		required String userId,
		required String stripeInvoiceId,
		String? invoiceNumber,
		required int amountDue,
		required String currency,
		required String status,
		String? invoicePdf,
		DateTime? createdAt,
	}) async {
		await repo.insert(SupabaseTables.invoices, {
			'user_id': userId,
			'stripe_invoice_id': stripeInvoiceId,
			'invoice_number': invoiceNumber,
			'amount_due': amountDue,
			'currency': currency,
			'status': status,
			'invoice_pdf': invoicePdf,
			'created_at': createdAt?.toIso8601String(),
		});
	}

	static Future<void> createReceipt({
		required String userId,
		required String stripeInvoiceId,
		String? receiptNumber,
		required int amount,
		required String currency,
		required String status,
		String? receiptPdf,
		DateTime? createdAt,
	}) async {
		await repo.insert(SupabaseTables.receipts, {
			'user_id': userId,
			'stripe_invoice_id': stripeInvoiceId,
			'receipt_number': receiptNumber,
			'amount': amount,
			'currency': currency,
			'status': status,
			'receipt_pdf': receiptPdf,
			'created_at': createdAt?.toIso8601String(),
		});
	}
}
