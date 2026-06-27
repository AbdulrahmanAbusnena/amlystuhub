enum AnnouncementControllers { initial, loading, success, error }

class AnnouncementState {
  final AnnouncementState status;
  final String? errorMessage;
}
