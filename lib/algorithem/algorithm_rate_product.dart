/// Product Rating System Algorithm
///
/// Handles product ratings: submission, aggregation, validation, and analytics.
library algorithm_rate_product;

class ProductRating {
	final String productId;
	final String shopperId;
	final double value; // 1–5
	final String? review;
	final DateTime timestamp;

	ProductRating({
		required this.productId,
		required this.shopperId,
		required this.value,
		this.review,
		required this.timestamp,
	});
}

class ProductRatingSystem {
	// In-memory ratings store: productId -> List<ProductRating>
	final Map<String, List<ProductRating>> _ratings = {};

	/// Submit a rating for a product
	/// Returns true if successful, false if duplicate or invalid
	bool submitRating({
		required String productId,
		required String shopperId,
		required double value,
		String? review,
	}) {
		if (value < 1 || value > 5) return false; // Validate rating
		final now = DateTime.now();
		final ratings = _ratings.putIfAbsent(productId, () => []);
		// Prevent multiple ratings by same shopper for same product
		if (ratings.any((r) => r.shopperId == shopperId)) return false;
		ratings.add(ProductRating(
			productId: productId,
			shopperId: shopperId,
			value: value,
			review: review,
			timestamp: now,
		));
		return true;
	}

	/// Get average rating and count for a product
	Map<String, dynamic> getProductRatingStats(String productId) {
		final ratings = _ratings[productId] ?? [];
		final count = ratings.length;
		final avg = count > 0 ? ratings.map((r) => r.value).reduce((a, b) => a + b) / count : 0.0;
		return {
			'average': avg,
			'count': count,
		};
	}

	/// Get all reviews for a product
	List<String> getProductReviews(String productId) {
		final ratings = _ratings[productId] ?? [];
		return ratings.where((r) => r.review != null && r.review!.isNotEmpty).map((r) => r.review!).toList();
	}

	/// Get recent ratings for a product (last N days)
	List<ProductRating> getRecentRatings(String productId, int days) {
		final ratings = _ratings[productId] ?? [];
		final cutoff = DateTime.now().subtract(Duration(days: days));
		return ratings.where((r) => r.timestamp.isAfter(cutoff)).toList();
	}
}

// --- DEMO USAGE ---
void main() {
	final system = ProductRatingSystem();
	// Submit ratings
	print(system.submitRating(productId: 'prod1', shopperId: 'user1', value: 4.0, review: 'Nice product!'));
	print(system.submitRating(productId: 'prod1', shopperId: 'user2', value: 5.0));
	print(system.submitRating(productId: 'prod1', shopperId: 'user1', value: 3.0)); // Duplicate, should fail
	print(system.submitRating(productId: 'prod1', shopperId: 'user3', value: 2.5, review: 'Could be better'));
	print(system.submitRating(productId: 'prod1', shopperId: 'user4', value: 0.0)); // Invalid, should fail

	// Get stats
	final stats = system.getProductRatingStats('prod1');
	print('Average rating: ${stats['average']}, Count: ${stats['count']}');

	// Get reviews
	final reviews = system.getProductReviews('prod1');
	print('Reviews: $reviews');

	// Get recent ratings (last 1 day)
	final recent = system.getRecentRatings('prod1', 1);
	print('Recent ratings: ${recent.length}');
}
