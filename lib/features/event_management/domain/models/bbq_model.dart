enum FoodChoice { chicken, meat, none }

class BbqAttendee {
  final String fullName;
  final String grade;
  final FoodChoice foodChoice;
  final bool isCheckedIn;
  final bool hasPaid;

  BbqAttendee({
    required this.fullName,
    required this.grade,
    required this.foodChoice,
    required this.isCheckedIn,
    required this.hasPaid,
  });

  /// Maps a raw row from Google Sheets API (fromRow: 2) directly into typed data.
  factory BbqAttendee.fromSheetRow(List<String> row) {
    // Column Mapping based on Form Layout:
    // row[0] = Column A: Timestamp
    // row[1] = Column B: Full Name
    // row[2] = Column C: Grade / Class
    // row[3] = Column D: Attendance & Ticket Confirmation
    // row[4] = Column E: Meal Preference
    // row[5] = Column F: Commitment Acknowledgment
    // row[6] = Column G: Checked In (Manual Admin Column)
    // row[7] = Column H: Payment Status (Manual Admin Column)

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
      hasPaid: row.length > 7 ? row[7].trim().toUpperCase() == 'PAID' : false,
    );
  }
}

class BbqFinanceMetrics {
  final int totalRsvps;
  final int chickenCount;
  final int meatCount;
  final int noFoodCount;
  final double chickenPrice;
  final double meatPrice;
  final double upfrontExpense;

  BbqFinanceMetrics({
    required this.totalRsvps,
    required this.chickenCount,
    required this.meatCount,
    required this.noFoodCount,
    required this.chickenPrice,
    required this.meatPrice,
    required this.upfrontExpense,
  });

  factory BbqFinanceMetrics.fromRoster({
    required List<BbqAttendee> roster,
    required double chickenPrice,
    required double meatPrice,
    required double upfrontExpense,
  }) {
    int chicken = 0;
    int meat = 0;
    int noFood = 0;

    for (final person in roster) {
      switch (person.foodChoice) {
        case FoodChoice.chicken:
          chicken++;
          break;
        case FoodChoice.meat:
          meat++;
          break;
        case FoodChoice.none:
          noFood++;
          break;
      }
    }

    return BbqFinanceMetrics(
      totalRsvps: roster.length,
      chickenCount: chicken,
      meatCount: meat,
      noFoodCount: noFood,
      chickenPrice: chickenPrice,
      meatPrice: meatPrice,
      upfrontExpense: upfrontExpense,
    );
  }

  double get maxProjectedRevenue =>
      (chickenCount * chickenPrice) + (meatCount * meatPrice);
  double get estimatedRevenue80Percent => maxProjectedRevenue * 0.80;
  double get projectedNetProfit => maxProjectedRevenue - upfrontExpense;
}
