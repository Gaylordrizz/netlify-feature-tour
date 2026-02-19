/// Store Flagging System Algorithm
///
/// Handles store flagging: submission, moderation tracking, abuse prevention, and analytics.
library algorithm_flag_store;

enum FlagStatus { active, reviewed, dismissed }

class StoreFlag {
	final String storeId;
	final String shopperId;
	final String reason;
	final DateTime timestamp;
	FlagStatus status;

	StoreFlag({
		required this.storeId,
		required this.shopperId,
		required this.reason,
		required this.timestamp,
		this.status = FlagStatus.active,
	});
}

class StoreFlagSystem {
	// In-memory flags store: storeId -> List<StoreFlag>
	final Map<String, List<StoreFlag>> _flags = {};
	// Limit: max 1 active flag per shopper per store
	static const int maxFlagsPerShopperPerStore = 1;

	/// Submit a flag for a store
	/// Returns true if successful, false if duplicate or invalid
	bool submitFlag({
		required String storeId,
		required String shopperId,
		required String reason,
	}) {
		if (reason.isEmpty) return false;
		final now = DateTime.now();
		final flags = _flags.putIfAbsent(storeId, () => []);
		// Prevent abuse: limit flags per shopper per store
		final activeFlags = flags.where((f) => f.shopperId == shopperId && f.status == FlagStatus.active);
		if (activeFlags.length >= maxFlagsPerShopperPerStore) return false;
		flags.add(StoreFlag(
			storeId: storeId,
			shopperId: shopperId,
			reason: reason,
			timestamp: now,
		));
		return true;
	}

	/// Get count of active flags for a store
	int getActiveFlagCount(String storeId) {
		final flags = _flags[storeId] ?? [];
		return flags.where((f) => f.status == FlagStatus.active).length;
	}

	/// Get all flag records for a store
	List<StoreFlag> getAllFlags(String storeId) {
		return _flags[storeId] ?? [];
	}

	/// Mark a flag as reviewed or dismissed (moderation workflow)
	bool updateFlagStatus({
		required String storeId,
		required int flagIndex,
		required FlagStatus status,
	}) {
		final flags = _flags[storeId];
		if (flags == null || flagIndex < 0 || flagIndex >= flags.length) return false;
		flags[flagIndex].status = status;
		return true;
	}

	/// Get recent flags for a store (last N days)
	List<StoreFlag> getRecentFlags(String storeId, int days) {
		final flags = _flags[storeId] ?? [];
		final cutoff = DateTime.now().subtract(Duration(days: days));
		return flags.where((f) => f.timestamp.isAfter(cutoff)).toList();
	}
}

// --- DEMO USAGE ---
void main() {
	final system = StoreFlagSystem();
	// Submit flags
	print(system.submitFlag(storeId: 'store1', shopperId: 'user1', reason: 'Spam'));
	print(system.submitFlag(storeId: 'store1', shopperId: 'user2', reason: 'Fraud'));
	print(system.submitFlag(storeId: 'store1', shopperId: 'user1', reason: 'Policy violation')); // Duplicate, should fail
	print(system.submitFlag(storeId: 'store1', shopperId: 'user3', reason: 'Inappropriate content'));
	print(system.submitFlag(storeId: 'store1', shopperId: 'user4', reason: ''));// Invalid, should fail

	// Get active flag count
	final activeCount = system.getActiveFlagCount('store1');
	print('Active flags: $activeCount');

	// Get all flags
	final allFlags = system.getAllFlags('store1');
	print('All flags: ${allFlags.length}');

	// Update flag status (moderation)
	system.updateFlagStatus(storeId: 'store1', flagIndex: 0, status: FlagStatus.reviewed);
	print('Flag 0 status: ${allFlags[0].status}');

	// Get recent flags (last 1 day)
	final recent = system.getRecentFlags('store1', 1);
	print('Recent flags: ${recent.length}');
}
