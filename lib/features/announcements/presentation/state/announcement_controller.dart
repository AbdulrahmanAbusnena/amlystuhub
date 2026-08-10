import 'package:amlystuhub/features/announcements/data/announcement_services.dart';
import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_state.dart';
import 'package:amlystuhub/features/auth/domain/models%20/user_role.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AnnouncementController extends StateNotifier<AnnouncementState> {
  final AnnouncementService _service;

  AnnouncementController({required AnnouncementService service})
    : _service = service,
      super(AnnouncementState.initial());

  Future<bool> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required List<int> targetGrades,
    required bool apOnly,
    required String authorId,
    required String authorName,
    required UserRole authorRole,
  }) async {
    state = AnnouncementState.loading();

    try {
      if (title.trim().isEmpty || content.trim().isEmpty) {
        throw 'Title and Content fields cannot be empty.';
      }

      final newAnnouncement = AnnouncementModel(
        id: '',
        title: title.trim(),
        content: content.trim(),
        authorId: authorId,
        authorName: authorName,
        authorRole: authorRole,
        category: category,
        targetGrades: targetGrades,
        apOnly: apOnly,
        createdAt: DateTime.now(),
      );

      await _service.publishAnnouncement(newAnnouncement);

      state = AnnouncementState.success();
      return true;
    } catch (e) {
      state = AnnouncementState.error(e.toString());
      return false;
    }
  }

  Future<bool> editAnnouncement({
    required String announcementId,
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

      final updateMap = {
        'title': title.trim(),
        'content': content.trim(),
        'category': category,
        'targetGrades': targetGrades,
        'apOnly': apOnly,
      };

      await _service.updateAnnouncement(announcementId, updateMap);

      state = AnnouncementState.success();
      return true;
    } catch (e) {
      state = AnnouncementState.error(e.toString());
      return false;
    }
  }

  Future<bool> deleteAnnouncement(String announcementId) async {
    state = AnnouncementState.loading();

    try {
      await _service.deleteAnnouncement(announcementId);
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
    } catch (_) {}
  }

  void resetState() {
    state = AnnouncementState.initial();
  }
}

final announcementServiceProvider = Provider<AnnouncementService>((ref) {
  return AnnouncementService();
});

final announcementControllerProvider =
    StateNotifierProvider<AnnouncementController, AnnouncementState>((ref) {
      final service = ref.watch(announcementServiceProvider);
      return AnnouncementController(service: service);
    });

final filteredAnnouncementsProvider = StreamProvider<List<AnnouncementModel>>((
  ref,
) {
  final userAsync = ref.watch(currentUserModelProvider);
  final service = ref.watch(announcementServiceProvider);

  final user = userAsync.value;
  if (user == null) return Stream.value([]);

  final isPrivilegedUser = user.role.canPublishAnnouncements;

  return service.getAnnouncementsStream().map((announcements) {
    // 1. Filter by role/grade/AP scope
    final visible = announcements.where((a) {
      if (isPrivilegedUser) return true;
      final matchesGrade =
          a.targetGrades.isEmpty || a.targetGrades.contains(user.gradeLevel);
      final matchesAp = !a.apOnly || user.isApStudent;
      return matchesGrade && matchesAp;
    }).toList();

    // 2. Sort pinned items to the top
    visible.sort((a, b) {
      final aIsPinned = a.pinnedByUids.contains(user.uid);
      final bIsPinned = b.pinnedByUids.contains(user.uid);

      if (aIsPinned && !bIsPinned) return -1;
      if (!aIsPinned && bIsPinned) return 1;

      // Secondary sort: newest first
      return b.createdAt.compareTo(a.createdAt);
    });

    return visible;
  });
});
