import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicState {
  final AsyncValue<void> operationStatus;
  final String searchQuery;
  final ProgramType selectedProgram;
  final ResourceCategory? selectedCategoryFilter;

  const AcademicState({
    this.operationStatus = const AsyncValue.data(null),
    this.searchQuery = '',
    this.selectedProgram = ProgramType.ap,
    this.selectedCategoryFilter,
  });

  bool get isLoading => operationStatus.isLoading;

  AcademicState copyWith({
    AsyncValue<void>? operationStatus,
    String? searchQuery,
    ProgramType? selectedProgram,
    ResourceCategory? selectedCategoryFilter,
  }) {
    return AcademicState(
      operationStatus: operationStatus ?? this.operationStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProgram: selectedProgram ?? this.selectedProgram,
      selectedCategoryFilter:
          selectedCategoryFilter ?? this.selectedCategoryFilter,
    );
  }
}
