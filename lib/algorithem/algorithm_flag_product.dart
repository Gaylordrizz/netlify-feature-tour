/// Product Flagging System Algorithm
///
/// Handles product flagging: submission, moderation tracking, abuse prevention, and analytics.
/// Handles product flagging: submission, moderation tracking, abuse prevention, and analytics.

enum FlagStatus { active, reviewed, dismissed }

class ProductFlag {
	final String productId;
	final String shopperId;
	final String reason;
	final DateTime timestamp;
	FlagStatus status;

	ProductFlag({
		required this.productId,
		required this.shopperId,
		required this.reason,
		required this.timestamp,
		this.status = FlagStatus.active,
	});
}

class ProductFlagSystem {
	// In-memory flags store: productId -> List<ProductFlag>
	final Map<String, List<ProductFlag>> _flags = {};
	// Limit: max 1 active flag per shopper per product
	static const int maxFlagsPerShopperPerProduct = 1;

	/// Submit a flag for a product
	/// Returns true if successful, false if duplicate or invalid
	bool submitFlag({
		required String productId,
		required String shopperId,
		required String reason,
	}) {
		if (reason.isEmpty) return false;
		final now = DateTime.now();
		final flags = _flags.putIfAbsent(productId, () => []);
		// Prevent abuse: limit flags per shopper per product
		final activeFlags = flags.where((f) => f.shopperId == shopperId && f.status == FlagStatus.active);
		if (activeFlags.length >= maxFlagsPerShopperPerProduct) return false;
		flags.add(ProductFlag(
			productId: productId,
			shopperId: shopperId,
			reason: reason,
			timestamp: now,
		));
		return true;
	}

	/// Get count of active flags for a product
	int getActiveFlagCount(String productId) {
		final flags = _flags[productId] ?? [];
		return flags.where((f) => f.status == FlagStatus.active).length;
	}

	/// Get all flag records for a product
	List<ProductFlag> getAllFlags(String productId) {
		return _flags[productId] ?? [];
	}

	/// Mark a flag as reviewed or dismissed (moderation workflow)
	bool updateFlagStatus({
		required String productId,
		required int flagIndex,
		required FlagStatus status,
	}) {
		final flags = _flags[productId];
		if (flags == null || flagIndex < 0 || flagIndex >= flags.length) return false;
		flags[flagIndex].status = status;
		return true;
	}

	/// Get recent flags for a product (last N days)
	List<ProductFlag> getRecentFlags(String productId, int days) {
		final flags = _flags[productId] ?? [];
		final cutoff = DateTime.now().subtract(Duration(days: days));
		return flags.where((f) => f.timestamp.isAfter(cutoff)).toList();
	}
}

// --- DEMO USAGE ---
void main() {
	final system = ProductFlagSystem();
	// Submit flags
	print(system.submitFlag(productId: 'prod1', shopperId: 'user1', reason: 'Spam'));
	print(system.submitFlag(productId: 'prod1', shopperId: 'user2', reason: 'Inappropriate content'));
	print(system.submitFlag(productId: 'prod1', shopperId: 'user1', reason: 'Policy violation')); // Duplicate, should fail
	print(system.submitFlag(productId: 'prod1', shopperId: 'user3', reason: 'Counterfeit'));
	print(system.submitFlag(productId: 'prod1', shopperId: 'user4', reason: ''));// Invalid, should fail

	// Get active flag count
	final activeCount = system.getActiveFlagCount('prod1');
	print('Active flags: $activeCount');

	// Get all flags
	final allFlags = system.getAllFlags('prod1');
	print('All flags: ${allFlags.length}');

	// Update flag status (moderation)
	system.updateFlagStatus(productId: 'prod1', flagIndex: 0, status: FlagStatus.reviewed);
	print('Flag 0 status: ${allFlags[0].status}');

	// Get recent flags (last 1 day)
	final recent = system.getRecentFlags('prod1', 1);
	print('Recent flags: ${recent.length}');
}
