
/// Stat Box Analytics Algorithm (Standalone Demo)
///
/// Computes the values displayed in admin stat boxes for both store and product contexts.
library algorithm_stat_boxes;

import 'algorithm_line_chart.dart' as chart_algo;

class Rating {
	final double value;
	final DateTime timestamp;
	Rating({required this.value, required this.timestamp});
}

// --- STORE ANALYTICS ---
Map<String, dynamic> computeStoreAnalytics({
	required List<chart_algo.Event> events,
	required DateTime storeActivatedAt,
	required Set<String> validProductIds,
	required Set<String> validSessionIds, // for unique visits
	required int repeatVisitorCount,
}) {
	final now = DateTime.now();
	final daysListed = now.difference(storeActivatedAt).inDays + 1;
	final impressions = events.where((e) => e.type == 'impression').length;
	final clicks = events.where((e) => e.type == 'click').length;
	final visits = validSessionIds.length;
	final conversionRate = impressions > 0 ? clicks / impressions : 0.0;
	return {
		'Impressions': impressions,
		'Clicks': clicks,
		'Visits to Store': visits,
		'Days Listed': daysListed,
		'Conversion Rate': conversionRate,
		'Repeat Visitors': repeatVisitorCount,
	};
}

// --- PRODUCT ANALYTICS ---
Map<String, dynamic> computeProductAnalytics({
	required List<chart_algo.Event> events,
	required DateTime productListedAt,
	required List<Rating> ratings,
	required int repeatBuyerCount,
}) {
	final now = DateTime.now();
	final days = now.difference(productListedAt).inDays + 1;
	final impressions = events.where((e) => e.type == 'impression').length;
	final clicks = events.where((e) => e.type == 'click').length;
	final conversionRate = impressions > 0 ? clicks / impressions : 0.0;
	final avgRating = ratings.isNotEmpty ? ratings.map((r) => r.value).reduce((a, b) => a + b) / ratings.length : 0.0;
	final ratingCount = ratings.length;
	return {
		'Impressions': impressions,
		'Clicks': clicks,
		'Days': days,
		'Product Rating': avgRating,
		'Rating Count': ratingCount,
		'Conversion Rate': conversionRate,
		'Repeat Buyers': repeatBuyerCount,
	};
}

// --- DEMO USAGE ---
void main() {
	final now = DateTime.now();
	// Mock store events
	final storeEvents = <chart_algo.Event>[
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 2)), type: 'impression'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 2)), type: 'click'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 1)), type: 'impression'),
		chart_algo.Event(timestamp: now, type: 'impression'),
		chart_algo.Event(timestamp: now, type: 'click'),
	];
	final storeActivatedAt = now.subtract(const Duration(days: 10));
	final validProductIds = {'p1', 'p2'};
	final validSessionIds = {'sess1', 'sess2', 'sess3'};
	final repeatVisitorCount = 1;

	final storeStats = computeStoreAnalytics(
		events: storeEvents,
		storeActivatedAt: storeActivatedAt,
		validProductIds: validProductIds,
		validSessionIds: validSessionIds,
		repeatVisitorCount: repeatVisitorCount,
	);
	print('Store Analytics:');
	storeStats.forEach((k, v) => print('$k: $v'));

	// Mock product events and ratings
	final productEvents = <chart_algo.Event>[
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 1)), type: 'impression'),
		chart_algo.Event(timestamp: now, type: 'impression'),
		chart_algo.Event(timestamp: now, type: 'click'),
	];
	final productListedAt = now.subtract(const Duration(days: 3));
	final ratings = [
		Rating(value: 4.5, timestamp: now.subtract(const Duration(days: 2))),
		Rating(value: 5.0, timestamp: now.subtract(const Duration(days: 1))),
	];
	final repeatBuyerCount = 1;

	final productStats = computeProductAnalytics(
		events: productEvents,
		productListedAt: productListedAt,
		ratings: ratings,
		repeatBuyerCount: repeatBuyerCount,
	);
	print('\nProduct Analytics:');
	productStats.forEach((k, v) => print('$k: $v'));
}
