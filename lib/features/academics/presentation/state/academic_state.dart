enum AcademicStatus { initial, loading, success, error }

class AcademicState {
  final AcademicStatus status;
  final String? errorMessage;

  AcademicState({required this.status, this.errorMessage});

  factory AcademicState.initial() =>
      AcademicState(status: AcademicStatus.initial);
  factory AcademicState.loading() =>
      AcademicState(status: AcademicStatus.loading);
  factory AcademicState.success() =>
      AcademicState(status: AcademicStatus.success);
  factory AcademicState.error(String message) =>
      AcademicState(status: AcademicStatus.error, errorMessage: message);
}
