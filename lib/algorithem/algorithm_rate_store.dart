/// Store Rating System Algorithm
///
/// Handles store ratings: submission, aggregation, validation, and analytics.
library algorithm_rate_store;

class StoreRating {
	final String storeId;
	final String shopperId;
	final double value; // 1–5
	final String? review;
	final DateTime timestamp;

	StoreRating({
		required this.storeId,
		required this.shopperId,
		required this.value,
		this.review,
		required this.timestamp,
	});
}

class StoreRatingSystem {
	// In-memory ratings store: storeId -> List<StoreRating>
	final Map<String, List<StoreRating>> _ratings = {};

	/// Submit a rating for a store
	/// Returns true if successful, false if duplicate or invalid
	bool submitRating({
		required String storeId,
		required String shopperId,
		required double value,
		String? review,
	}) {
		if (value < 1 || value > 5) return false; // Validate rating
		final now = DateTime.now();
		final ratings = _ratings.putIfAbsent(storeId, () => []);
		// Prevent multiple ratings by same shopper for same store
		if (ratings.any((r) => r.shopperId == shopperId)) return false;
		ratings.add(StoreRating(
			storeId: storeId,
			shopperId: shopperId,
			value: value,
			review: review,
			timestamp: now,
		));
		return true;
	}

	/// Get average rating and count for a store
	Map<String, dynamic> getStoreRatingStats(String storeId) {
		final ratings = _ratings[storeId] ?? [];
		final count = ratings.length;
		final avg = count > 0 ? ratings.map((r) => r.value).reduce((a, b) => a + b) / count : 0.0;
		return {
			'average': avg,
			'count': count,
		};
	}

	/// Get all reviews for a store
	List<String> getStoreReviews(String storeId) {
		final ratings = _ratings[storeId] ?? [];
		return ratings.where((r) => r.review != null && r.review!.isNotEmpty).map((r) => r.review!).toList();
	}

	/// Get recent ratings for a store (last N days)
	List<StoreRating> getRecentRatings(String storeId, int days) {
		final ratings = _ratings[storeId] ?? [];
		final cutoff = DateTime.now().subtract(Duration(days: days));
		return ratings.where((r) => r.timestamp.isAfter(cutoff)).toList();
	}
}

// --- DEMO USAGE ---
void main() {
	final system = StoreRatingSystem();
	// Submit ratings
	print(system.submitRating(storeId: 'store1', shopperId: 'user1', value: 4.5, review: 'Great store!'));
	print(system.submitRating(storeId: 'store1', shopperId: 'user2', value: 5.0));
	print(system.submitRating(storeId: 'store1', shopperId: 'user1', value: 3.0)); // Duplicate, should fail
	print(system.submitRating(storeId: 'store1', shopperId: 'user3', value: 2.0, review: 'Not bad'));
	print(system.submitRating(storeId: 'store1', shopperId: 'user4', value: 6.0)); // Invalid, should fail

	// Get stats
	final stats = system.getStoreRatingStats('store1');
	print('Average rating: ${stats['average']}, Count: ${stats['count']}');

	// Get reviews
	final reviews = system.getStoreReviews('store1');
	print('Reviews: $reviews');

	// Get recent ratings (last 1 day)
	final recent = system.getRecentRatings('store1', 1);
	print('Recent ratings: ${recent.length}');
}
