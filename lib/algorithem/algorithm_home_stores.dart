
/// Home Store Visibility Algorithm (Standalone Demo)
///
/// This module demonstrates a functional, personalized store discovery algorithm
/// using mock data and the unified personalization logic described.

class Store {
	final String id;
	final String name;
	final String category;
	final bool isEligible;
	final bool isActive;
	final bool hasRecentLaunchOrUpdate;
	final bool isCurated;
	double score = 0.0;

	Store({
		required this.id,
		required this.name,
		required this.category,
		required this.isEligible,
		required this.isActive,
		required this.hasRecentLaunchOrUpdate,
		required this.isCurated,
	});
}

class Shopper {
	final Set<String> savedStoreIds;
	final Set<String> storeHistoryIds;
	final Set<String> savedCategories;
	final Set<String> historyCategories;
	final String location;

	Shopper({
		required this.savedStoreIds,
		required this.storeHistoryIds,
		required this.savedCategories,
		required this.historyCategories,
		required this.location,
	});
}

List<Store> getPersonalizedHomeStores({
	required Shopper shopper,
	required List<Store> allStores,
	int maxResults = 20,
}) {
	// 1. Filter eligible stores
	List<Store> candidates = allStores.where((s) => s.isEligible && s.isActive).toList();

	// 2. Score stores
	for (final store in candidates) {
		store.score = 0.0;
		if (shopper.savedStoreIds.contains(store.id)) store.score += 2.0;
		if (shopper.storeHistoryIds.contains(store.id)) store.score += 1.5;
		if (shopper.savedCategories.contains(store.category) || shopper.historyCategories.contains(store.category)) store.score += 1.0;
		if (store.hasRecentLaunchOrUpdate) store.score += 1.0;
		if (store.isCurated) store.score += 3.0;
	}

	// 3. Find stores similar to saved stores (by category)
	List<Store> similarToSaved = _findSimilarStoresToSaved(shopper, candidates);
	Set<String> similarIds = similarToSaved.map((s) => s.id).toSet();
	List<Store> otherStores = candidates.where((s) => !similarIds.contains(s.id)).toList();

	// 4. Sort both lists by score descending
	similarToSaved.sort((a, b) => b.score.compareTo(a.score));
	otherStores.sort((a, b) => b.score.compareTo(a.score));

	// 5. Take 50% from each (or as close as possible)
	int half = (maxResults / 2).ceil();
	List<Store> result = [];
	int i = 0, j = 0;
	while (result.length < maxResults && (i < similarToSaved.length || j < otherStores.length)) {
		if (i < half && i < similarToSaved.length) {
			result.add(similarToSaved[i]);
			i++;
		}
		if (result.length < maxResults && j < half && j < otherStores.length) {
			result.add(otherStores[j]);
			j++;
		}
	}

	// 6. Enforce category/store variety, resurface saved/visited stores, add exploration
	result = _enforceStoreVariety(result);
	result = _insertExplorationStores(result, allStores);

	// 7. Return top N
	return result.take(maxResults).toList();
}

// Helper: Find stores similar to any saved store (by category, excluding saved stores themselves)
List<Store> _findSimilarStoresToSaved(Shopper shopper, List<Store> candidates) {
	Set<String> savedIds = shopper.savedStoreIds;
	Set<String> savedCategories = candidates
			.where((s) => savedIds.contains(s.id))
			.map((s) => s.category)
			.toSet();
	return candidates.where((s) =>
			!savedIds.contains(s.id) &&
			savedCategories.contains(s.category)
	).toList();
}

List<Store> _enforceStoreVariety(List<Store> stores) {
	// Ensure no more than 2 stores from the same category in a row
	final List<Store> result = [];
	String? lastCategory;
	int sameCategoryCount = 0;
	for (final store in stores) {
		if (store.category == lastCategory) {
			sameCategoryCount++;
			if (sameCategoryCount > 2) continue;
		} else {
			lastCategory = store.category;
			sameCategoryCount = 1;
		}
		result.add(store);
	}
	return result;
}

List<Store> _insertExplorationStores(List<Store> ranked, List<Store> allStores) {
	// Insert a few random stores from new categories not in ranked
	final Set<String> seenIds = ranked.map((s) => s.id).toSet();
	final List<Store> exploration = allStores.where((s) => s.isEligible && s.isActive && !seenIds.contains(s.id)).toList();
	exploration.shuffle();
	for (int i = 0; i < exploration.length && i < 2; i++) {
		ranked.insert((i + 1) * 4, exploration[i]);
	}
	return ranked;
}

// --- DEMO USAGE ---
void main() {
	// Mock stores
	final stores = [
		Store(id: 's1', name: 'Cool Shoes', category: 'Shoes', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: false, isCurated: false),
		Store(id: 's2', name: 'Gadget World', category: 'Gadgets', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: true, isCurated: false),
		Store(id: 's3', name: 'Book Nook', category: 'Books', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: false, isCurated: true),
		Store(id: 's4', name: 'Fashion Hub', category: 'Fashion', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: true, isCurated: false),
		Store(id: 's5', name: 'Techie', category: 'Gadgets', isEligible: true, isActive: false, hasRecentLaunchOrUpdate: false, isCurated: false),
		Store(id: 's6', name: 'Sneaker Spot', category: 'Shoes', isEligible: true, isActive: true, hasRecentLaunchOrUpdate: true, isCurated: false),
	];

	// Mock shopper
	final shopper = Shopper(
		savedStoreIds: {'s1', 's3'},
		storeHistoryIds: {'s2'},
		savedCategories: {'Shoes'},
		historyCategories: {'Gadgets'},
		location: 'NY',
	);

	final personalized = getPersonalizedHomeStores(
		shopper: shopper,
		allStores: stores,
		maxResults: 10,
	);

	print('Personalized Home Stores:');
	for (final s in personalized) {
		print('${s.name} (${s.category}) (score: ${s.score.toStringAsFixed(2)})');
	}
}
