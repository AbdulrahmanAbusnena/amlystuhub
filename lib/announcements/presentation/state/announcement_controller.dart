import 'package:amlystuhub/announcements/data/announcement_services.dart';
import 'package:amlystuhub/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/announcements/presentation/state/announcement_state.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AnnouncementController extends StateNotifier<AnnouncementState> {
  final AnnouncementServices _service;

  AnnouncementController({required AnnouncementServices service})
    : _service = service,
      super(AnnouncementState.initial());

  Future<bool> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required List<int> targetGrades,
    required bool apOnly,
  }) async {
    state = AnnouncementState.loading();

    try {
      if (title.trim().isEmpty || content.trim().isEmpty) {
        throw 'Title and Content fields cannot be empty.';
      }

      await _service.publishAnnouncement(
        title: title.trim(),
        content: content.trim(),
        category: category,
        targetGrades: targetGrades,
        apOnly: apOnly,
      );

      state = AnnouncementState.success();
      return true;
    } catch (e) {
      state = AnnouncementState.error(e.toString());
      return false;
    }
  }

  Future<void> togglePin({
    required String announcementId,
    required String userId,
    required bool currentlyPinned,
  }) async {
    try {
      await _service.togglePin(announcementId, userId, !currentlyPinned);
    } catch (_) {
      // Handle or log silent pin failure
    }
  }

  void resetState() {
    state = AnnouncementState.initial();
  }
}

final announcementServiceProvider = Provider<AnnouncementServices>((ref) {
  return AnnouncementServices();
});

final announcementControllerProvider =
    StateNotifierProvider<AnnouncementController, AnnouncementState>((ref) {
      final service = ref.watch(announcementServiceProvider);
      return AnnouncementController(service: service);
    });

/// REACTIVE STREAM PROVIDER: Auto-filters items according to the logged-in user profile
final filteredAnnouncementsProvider = StreamProvider<List<AnnouncementModel>>((
  ref,
) {
  final service = ref.watch(announcementServiceProvider);
  final userAsync = ref.watch(
    currentUserModelProvider,
  ); // Reads active logged-in user
  final user = userAsync.value;

  if (user == null) return Stream.value([]);

  return service.getAnnouncementsStream().map((list) {
    // School Admin sees EVERYTHING
    if (user.role.toSystemString() == 'stuCoAdmin') return list;

    // Apply Grade & AP Filters for students
    return list.where((item) {
      if (item.targetGrades.isNotEmpty &&
          !item.targetGrades.contains(user.gradeLevel)) {
        return false;
      }
      if (item.apOnly && !user.isApStudent) {
        return false;
      }
      return true;
    }).toList();
  });
});
