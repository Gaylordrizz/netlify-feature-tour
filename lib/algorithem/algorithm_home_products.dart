
/// Home Product Visibility & Ranking Algorithm (Standalone Demo)
///
/// This module demonstrates a functional, personalized product discovery algorithm
/// using mock data and the unified personalization logic described.

class Product {
	final String id;
	final String name;
	final String category;
	final String storeId;
	final bool isActive;
	final bool isInStock;
	final bool isCurated;
	final DateTime listedAt;
	double score = 0.0;

	Product({
		required this.id,
		required this.name,
		required this.category,
		required this.storeId,
		required this.isActive,
		required this.isInStock,
		required this.isCurated,
		required this.listedAt,
	});
}

class Store {
	final String id;
	final String name;
	final bool isEligible;
	Store({required this.id, required this.name, required this.isEligible});
}

class Shopper {
	final Set<String> savedProductIds;
	final Set<String> savedStoreIds;
	final Set<String> productHistoryIds;
	final Set<String> storeHistoryIds;
	final Set<String> blockedProductIds;
	final Set<String> recentlyShownProductIds;
	final String location;

	Shopper({
		required this.savedProductIds,
		required this.savedStoreIds,
		required this.productHistoryIds,
		required this.storeHistoryIds,
		required this.blockedProductIds,
		required this.recentlyShownProductIds,
		required this.location,
	});
}

List<Product> getPersonalizedHomeProducts({
	required Shopper shopper,
	required List<Product> allProducts,
	required Map<String, Store> storeMap,
	int maxResults = 30,
}) {
	// 1. Filter products
	List<Product> candidates = allProducts.where((p) {
		final store = storeMap[p.storeId];
		return p.isActive &&
				p.isInStock &&
				!shopper.blockedProductIds.contains(p.id) &&
				store != null &&
				store.isEligible;
	}).toList();

	// 2. Score products
	for (final product in candidates) {
		product.score = 0.0;
		// Boost for saved/history categories and stores
		if (shopper.savedProductIds.contains(product.id) || shopper.productHistoryIds.contains(product.id)) {
			product.score += 2.0;
		}
		if (shopper.savedStoreIds.contains(product.storeId) || shopper.storeHistoryIds.contains(product.storeId)) {
			product.score += 1.5;
		}
		// Freshness decay (recently listed/updated)
		product.score += _freshnessBoost(product.listedAt);
		// Penalize if recently shown (cooldown)
		if (shopper.recentlyShownProductIds.contains(product.id)) {
			product.score -= 2.0;
		}
		// Editor/curated boost
		if (product.isCurated) product.score += 3.0;
	}

	// 3. Find products similar to saved products
	List<Product> similarToSaved = _findSimilarProductsToSaved(shopper, candidates);
	// Remove duplicates
	Set<String> similarIds = similarToSaved.map((p) => p.id).toSet();
	List<Product> otherProducts = candidates.where((p) => !similarIds.contains(p.id)).toList();

	// 4. Sort both lists by score descending
	similarToSaved.sort((a, b) => b.score.compareTo(a.score));
	otherProducts.sort((a, b) => b.score.compareTo(a.score));

	// 5. Take 50% from each (or as close as possible)
	int half = (maxResults / 2).ceil();
	List<Product> result = [];
	int i = 0, j = 0;
	while (result.length < maxResults && (i < similarToSaved.length || j < otherProducts.length)) {
		if (i < half && i < similarToSaved.length) {
			result.add(similarToSaved[i]);
			i++;
		}
		if (result.length < maxResults && j < half && j < otherProducts.length) {
			result.add(otherProducts[j]);
			j++;
		}
	}

	// 6. Enforce diversity (no consecutive products from same store)
	result = _enforceStoreDiversity(result);

	// 7. Insert exploration content (random new products)
	result = _insertExplorationContent(result, allProducts, storeMap);

	// 8. Return top N
	return result.take(maxResults).toList();
}

// Helper: Find products similar to any saved product (by category or store)
List<Product> _findSimilarProductsToSaved(Shopper shopper, List<Product> candidates) {
	// Similar if same category or same store as a saved product
	// (excluding the saved products themselves)
	Set<String> savedIds = shopper.savedProductIds;
	Set<String> savedCategories = candidates
			.where((p) => savedIds.contains(p.id))
			.map((p) => p.category)
			.toSet();
	Set<String> savedStores = candidates
			.where((p) => savedIds.contains(p.id))
			.map((p) => p.storeId)
			.toSet();
	return candidates.where((p) =>
			!savedIds.contains(p.id) &&
			(savedCategories.contains(p.category) || savedStores.contains(p.storeId))
	).toList();
}

double _freshnessBoost(DateTime listedAt) {
	final now = DateTime.now();
	final days = now.difference(listedAt).inDays;
	if (days < 2) return 2.0;
	if (days < 7) return 1.0;
	if (days < 30) return 0.5;
	return 0.0;
}

List<Product> _enforceStoreDiversity(List<Product> products) {
	final List<Product> result = [];
	final Set<String> usedStores = {};
	for (final product in products) {
		if (result.isEmpty || result.last.storeId != product.storeId) {
			result.add(product);
			usedStores.add(product.storeId);
		}
	}
	// Add remaining products, skipping consecutive from same store
	for (final product in products) {
		if (!result.contains(product)) {
			if (result.isEmpty || result.last.storeId != product.storeId) {
				result.add(product);
			}
		}
	}
	return result;
}

List<Product> _insertExplorationContent(List<Product> ranked, List<Product> allProducts, Map<String, Store> storeMap) {
	// Insert a few random products from new categories or stores not in ranked
	final Set<String> seenIds = ranked.map((p) => p.id).toSet();
	final List<Product> exploration = allProducts.where((p) {
		final store = storeMap[p.storeId];
		return p.isActive && p.isInStock && store != null && store.isEligible && !seenIds.contains(p.id);
	}).toList();
	exploration.shuffle();
	for (int i = 0; i < exploration.length && i < 3; i++) {
		ranked.insert((i + 1) * 5, exploration[i]);
	}
	return ranked;
}

// --- DEMO USAGE ---
void main() {
	// Mock stores
	final stores = [
		Store(id: 's1', name: 'Cool Shoes', isEligible: true),
		Store(id: 's2', name: 'Gadget World', isEligible: true),
		Store(id: 's3', name: 'Book Nook', isEligible: false),
	];
	final storeMap = {for (var s in stores) s.id: s};

	// Mock products
	final products = [
		Product(id: 'p1', name: 'Sneaker X', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 1))),
		Product(id: 'p2', name: 'Smart Watch', category: 'Gadgets', storeId: 's2', isActive: true, isInStock: true, isCurated: true, listedAt: DateTime.now().subtract(Duration(days: 3))),
		Product(id: 'p3', name: 'Classic Novel', category: 'Books', storeId: 's3', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 10))),
		Product(id: 'p4', name: 'Running Shoes', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 5))),
		Product(id: 'p5', name: 'Bluetooth Earbuds', category: 'Gadgets', storeId: 's2', isActive: true, isInStock: false, isCurated: false, listedAt: DateTime.now().subtract(Duration(days: 2))),
		Product(id: 'p6', name: 'Limited Edition Sneakers', category: 'Shoes', storeId: 's1', isActive: true, isInStock: true, isCurated: true, listedAt: DateTime.now().subtract(Duration(hours: 12))),
	];

	// Mock shopper
	final shopper = Shopper(
		savedProductIds: {'p1', 'p6'},
		savedStoreIds: {'s1'},
		productHistoryIds: {'p2'},
		storeHistoryIds: {'s2'},
		blockedProductIds: {'p3'},
		recentlyShownProductIds: {'p4'},
		location: 'NY',
	);

	final personalized = getPersonalizedHomeProducts(
		shopper: shopper,
		allProducts: products,
		storeMap: storeMap,
		maxResults: 10,
	);

	print('Personalized Home Products:');
	for (final p in personalized) {
		print('${p.name} (score: ${p.score.toStringAsFixed(2)})');
	}
}
