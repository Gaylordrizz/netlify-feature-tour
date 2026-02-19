
/// Unified Command: Personalized Discovery, Analytics, and Governance
///
/// This file demonstrates how to orchestrate the product, store, and analytics algorithms
/// together for a unified, personalized discovery and analytics experience.
library algorithm_overall;

import 'algorithm_home_products.dart' as products_algo;
import 'algorithm_home_stores.dart' as stores_algo;
import 'algorithm_line_chart.dart' as chart_algo;

void main() {
	// --- MOCK DATA ---
		// Stores
		final stores = [
				stores_algo.Store(id: 's1', name: 'Cool Shoes', category: 'Shoes', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: false, isCurated: false),
				stores_algo.Store(id: 's2', name: 'Gadget World', category: 'Gadgets', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: true, isCurated: false),
				stores_algo.Store(id: 's3', name: 'Book Nook', category: 'Books', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: false, isCurated: true),
		];
		// Adapter: convert stores_algo.Store to products_algo.Store for storeMap
		final storeMap = {
			for (var s in stores)
				s.id: products_algo.Store(
					id: s.id,
					name: s.name,
					isEligible: s.isEligible,
				)
		};

	// Products
	final products = [
		products_algo.Product(id: 'p1', name: 'Sneaker X', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 1))),
		products_algo.Product(id: 'p2', name: 'Smart Watch', category: 'Gadgets', storeId: 's2', isActive: true, isInStock: true, isCurated: true, listedAt: DateTime.now().subtract(Duration(days: 3))),
		products_algo.Product(id: 'p3', name: 'Classic Novel', category: 'Books', storeId: 's3', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 10))),
		products_algo.Product(id: 'p4', name: 'Running Shoes', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 5))),
		products_algo.Product(id: 'p5', name: 'Bluetooth Earbuds', category: 'Gadgets', storeId: 's2', isActive: true, isInStock: false, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 2))),
		products_algo.Product(id: 'p6', name: 'Limited Edition Sneakers', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: true, listedAt: DateTime.now().subtract(Duration(hours: 12))),
	];

	// Shopper
	final shopper = products_algo.Shopper(
		savedProductIds: {'p1', 'p6'},
		savedStoreIds: {'s1'},
		productHistoryIds: {'p2'},
		storeHistoryIds: {'s2'},
		blockedProductIds: {'p3'},
		recentlyShownProductIds: {'p4'},
		location: 'NY',
	);

	// --- ALGORITHM DEMOS ---
	// 1. Personalized Home Products
	final personalizedProducts = products_algo.getPersonalizedHomeProducts(
		shopper: shopper,
		allProducts: products,
		storeMap: storeMap,
		maxResults: 10,
	);

	print('Personalized Home Products:');
	for (final p in personalizedProducts) {
		print('${p.name} (score: ${p.score.toStringAsFixed(2)})');
	}

	// 2. Personalized Home Stores
	final shopperStores = stores_algo.Shopper(
		savedStoreIds: {'s1', 's3'},
		storeHistoryIds: {'s2'},
		savedCategories: {'Shoes'},
		historyCategories: {'Gadgets'},
		location: 'NY',
	);
	final personalizedStores = stores_algo.getPersonalizedHomeStores(
		shopper: shopperStores,
		allStores: stores,
		maxResults: 10,
	);

	print('\nPersonalized Home Stores:');
	for (final s in personalizedStores) {
		print('${s.name} (${s.category}) (score: ${s.score.toStringAsFixed(2)})');
	}

	// 3. Analytics: Line Chart Example
	final now = DateTime.now();
	final start = now.subtract(const Duration(days: 6));
	final end = now;
	final events = <chart_algo.Event>[
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 6, hours: 2)), type: 'impression'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 6, hours: 1)), type: 'impression'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 5)), type: 'click'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 4)), type: 'impression'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 2)), type: 'impression'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 2)), type: 'click'),
		chart_algo.Event(timestamp: now.subtract(const Duration(days: 1)), type: 'visit'),
		chart_algo.Event(timestamp: now, type: 'impression'),
	];
	final impressionsSeries = chart_algo.buildTimeSeries(
		events: events,
		startDate: start,
		endDate: end,
		eventType: 'impression',
	);
	print('\nImpressions (last 7 days): $impressionsSeries');

	// 4. Governance: (Demo) Log algorithm outputs for bias monitoring
	print('\n[Governance] Algorithm outputs logged for bias monitoring and transparency.');
}
