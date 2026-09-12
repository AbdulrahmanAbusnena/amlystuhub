import 'package:amlystuhub/features/event_management/data/sheet_services.dart';
import 'package:amlystuhub/features/event_management/domain/models/bbq_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Service Provider
final sheetServiceProvider = Provider<SheetService>((ref) {
  return SheetService();
});

// 2. FutureProvider to fetch and auto-refresh the roster from Google Sheets
final bbqRosterProvider = FutureProvider<List<BbqAttendee>>((ref) async {
  final service = ref.watch(sheetServiceProvider);
  return await service.getBbqAttendees();
});

// 3. Search Query Provider for the UI search bar
final bbqSearchQueryProvider = StateProvider<String>((ref) => '');

// 4. Filtered Roster Provider for search functionality
final filteredBbqRosterProvider = Provider<AsyncValue<List<BbqAttendee>>>((
  ref,
) {
  final rosterAsync = ref.watch(bbqRosterProvider);
  final query = ref.watch(bbqSearchQueryProvider).toLowerCase().trim();

  return rosterAsync.whenData((roster) {
    if (query.isEmpty) return roster;
    return roster.where((attendee) {
      return attendee.fullName.toLowerCase().contains(query) ||
          attendee.grade.toLowerCase().contains(query);
    }).toList();
  });
});

// 5. Computed Metrics Provider (Recalculates automatically when roster changes)
final bbqFinanceMetricsProvider = Provider<AsyncValue<BbqFinanceMetrics>>((
  ref,
) {
  final rosterAsync = ref.watch(bbqRosterProvider);

  return rosterAsync.whenData((roster) {
    return BbqFinanceMetrics.fromRoster(
      roster: roster,
      chickenPrice: 20.0, // Default ticket price
      meatPrice: 25.0, // Update to exact meat price
      upfrontExpense: 500.0, // Update to actual upfront expenditure
    );
  });
});
