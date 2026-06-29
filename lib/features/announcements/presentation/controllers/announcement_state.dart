enum AnnouncementStatus { initial, loading, success, error }

class AnnouncementState {
  final AnnouncementStatus status;
  final String? errorMessage;

  AnnouncementState({required this.status, this.errorMessage});

  factory AnnouncementState.initial() =>
      AnnouncementState(status: AnnouncementStatus.initial);

  factory AnnouncementState.loading() =>
      AnnouncementState(status: AnnouncementStatus.loading);

  factory AnnouncementState.success() =>
      AnnouncementState(status: AnnouncementStatus.success);

  factory AnnouncementState.error(String message) => AnnouncementState(
    status: AnnouncementStatus.error,
    errorMessage: message,
  );
}
