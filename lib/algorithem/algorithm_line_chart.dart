

/// Performance Line Chart Algorithm (Standalone Demo)
///
/// This module builds time-series datasets for line charts
/// in the store and product admin dashboards, using mock event data.
library algorithm_line_chart;

class Event {
	final DateTime timestamp;
	final String type; // 'impression', 'click', 'visit'
	Event({required this.timestamp, required this.type});
}

/// Groups events by day, preserving zero-activity days.
List<int> buildTimeSeries({
	required List<Event> events,
	required DateTime startDate,
	required DateTime endDate,
	required String eventType,
}) {
	// 1. Group events by day
	final Map<DateTime, int> counts = {};
	for (final event in events) {
		if (event.type != eventType) continue;
		final day = DateTime(event.timestamp.year, event.timestamp.month, event.timestamp.day);
		counts[day] = (counts[day] ?? 0) + 1;
	}

	// 2. Build time series, preserving zero-activity days
	final List<int> series = [];
	for (DateTime d = startDate;
			!d.isAfter(endDate);
			d = d.add(const Duration(days: 1))) {
		series.add(counts[d] ?? 0);
	}
	return series;
}

// --- DEMO USAGE ---
void main() {
	final now = DateTime.now();
	final start = now.subtract(const Duration(days: 6));
	final end = now;

	// Mock events: 7 days, some days with no events
	final events = <Event>[
		Event(timestamp: now.subtract(const Duration(days: 6, hours: 2)), type: 'impression'),
		Event(timestamp: now.subtract(const Duration(days: 6, hours: 1)), type: 'impression'),
		Event(timestamp: now.subtract(const Duration(days: 5)), type: 'click'),
		Event(timestamp: now.subtract(const Duration(days: 4)), type: 'impression'),
		Event(timestamp: now.subtract(const Duration(days: 2)), type: 'impression'),
		Event(timestamp: now.subtract(const Duration(days: 2)), type: 'click'),
		Event(timestamp: now.subtract(const Duration(days: 1)), type: 'visit'),
		Event(timestamp: now, type: 'impression'),
	];

	final impressionsSeries = buildTimeSeries(
		events: events,
		startDate: start,
		endDate: end,
		eventType: 'impression',
	);
	final clicksSeries = buildTimeSeries(
		events: events,
		startDate: start,
		endDate: end,
		eventType: 'click',
	);
	final visitsSeries = buildTimeSeries(
		events: events,
		startDate: start,
		endDate: end,
		eventType: 'visit',
	);

	print('Impressions: $impressionsSeries');
	print('Clicks: $clicksSeries');
	print('Visits: $visitsSeries');
}
