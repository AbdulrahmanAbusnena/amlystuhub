import 'dart:async';
import 'package:amlystuhub/features/event_management/data/sheet_services.dart';
import 'package:amlystuhub/features/event_management/domain/models/bbq_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final sheetServiceProvider = Provider<SheetService>((ref) {
  return SheetService();
});

final bbqUpfrontExpenseProvider = StateProvider<double>((ref) => 500.0);

final chickenPriceProvider = StateProvider<double>((ref) => 20.0);

final meatPriceProvider = StateProvider<double>((ref) => 25.0);

class BbqRosterController extends AsyncNotifier<List<BbqAttendee>> {
  @override
  FutureOr<List<BbqAttendee>> build() async {
    return _fetchRoster();
  }

  Future<List<BbqAttendee>> _fetchRoster() async {
    final service = ref.read(sheetServiceProvider);

    // 1. Await the raw List<List<String>> from your sheet service
    final List<List<String>> rawRows = await service.fetchRoster();

    // 2. Map each raw row safely into a BbqAttendee instance
    return rawRows
        .where(
          (row) => row.isNotEmpty && row.length > 1 && row[1].trim().isNotEmpty,
        )
        .map((row) {
          // Parse Food Choice safely from Column E (row[4])
          final rawFood = row.length > 4 ? row[4].toLowerCase().trim() : '';
          FoodChoice food = FoodChoice.none;
          if (rawFood.contains('chicken')) {
            food = FoodChoice.chicken;
          } else if (rawFood.contains('meat') ||
              rawFood.contains('beef') ||
              rawFood.contains('burger')) {
            food = FoodChoice.meat;
          }

          return BbqAttendee(
            fullName: row.length > 1 ? row[1].trim() : 'Unknown',
            grade: row.length > 2 ? row[2].trim() : 'N/A',
            foodChoice: food,
            isCheckedIn: row.length > 6
                ? row[6].trim().toUpperCase() == 'YES'
                : false,
            hasPaid: row.length > 7
                ? row[7].trim().toUpperCase() == 'PAID'
                : false,
          );
        })
        .toList();
  }

  Future<void> refreshRoster() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRoster());
  }
}

final bbqRosterControllerProvider =
    AsyncNotifierProvider<BbqRosterController, List<BbqAttendee>>(() {
      return BbqRosterController();
    });

final bbqSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredBbqRosterProvider = Provider<AsyncValue<List<BbqAttendee>>>((
  ref,
) {
  final rosterAsync = ref.watch(bbqRosterControllerProvider);
  final query = ref.watch(bbqSearchQueryProvider).toLowerCase().trim();

  return rosterAsync.whenData((roster) {
    if (query.isEmpty) return roster;
    return roster.where((attendee) {
      final nameMatches = attendee.fullName.toLowerCase().contains(query);
      final gradeMatches = attendee.grade.toLowerCase().contains(query);
      return nameMatches || gradeMatches;
    }).toList();
  });
});

final bbqFinanceMetricsProvider = Provider<AsyncValue<BbqFinanceMetrics>>((
  ref,
) {
  final rosterAsync = ref.watch(bbqRosterControllerProvider);
  final chickenPrice = ref.watch(chickenPriceProvider);
  final meatPrice = ref.watch(meatPriceProvider);
  final upfrontCost = ref.watch(bbqUpfrontExpenseProvider);

  return rosterAsync.whenData((roster) {
    return BbqFinanceMetrics.fromRoster(
      roster: roster,
      chickenPrice: chickenPrice,
      meatPrice: meatPrice,
      upfrontExpense: upfrontCost,
    );
  });
});
