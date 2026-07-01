// ignore_for_file: unused_import

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/models/announcement_model.dart';
import 'announcement_state.dart';
import 'package:amlystuhub/features/auth/domain/models /user_model.dart';
import '../../data/announcement_services.dart';

class AnnouncementController extends StateNotifier<AnnouncementState> {
  // ignore: unused_field
  final AnnouncementServices _service;

  AnnouncementController({required AnnouncementServices service})
    : _service = service,
      super(AnnouncementState.initial());

  // Publishing announcements method
  Future<bool> publishAnnouncement({
    required String title,
    required String content,
    required String category,
    required List<int> targetGrades,
    required bool apOnly,
    required UserModel author,
  }) async {
    state = AnnouncementState.loading();

    // guarding system.
    if (title.trim().isEmpty ||
        content.trim().isEmpty ||
        category.trim().isEmpty) {
      state = AnnouncementState.error(
        'Please fill out the title, content, and category.',
      );
      return false;
    }

    try {
      final newAnnouncement = AnnouncementsModel(
        id: '',
        title: title.trim(),
        content: content.trim(),
        category: category.trim(),
        authorId: author.uid,
        authorName: author.name,
        authorRole: author.role,
        targetGrades: targetGrades,
        apOnly: apOnly,
        createdAt: DateTime.now(),
        pinnedByUids: const [],
      );
      await _service.createAnnouncement(newAnnouncement);

      state = AnnouncementState.success();
      return true;
    } catch (e) {
      state = AnnouncementState.error(e.toString());
    }
    return false;
  }

  Future<void> togglePinStatus(
    String announcementId,
    String userId,
    bool currentlyPinned,
  ) async {
    bool shouldPin = !currentlyPinned;

    // creating a safety circle

    try {
      await _service.togglePin(announcementId, userId, shouldPin);
    } catch (e) {
      print('Error toggling pin status');
    }
  }
}

// Service Provider
final announcementServicesProvider = Provider<AnnouncementServices>((ref) {
  return AnnouncementServices();
});

// The Controller Provider
final announcementControllerProivder =
    StateNotifierProvider<AnnouncementController, AnnouncementState>((ref) {
      final services = ref.watch(announcementServicesProvider);

      // Passing the services into the controller's constructoir

      return AnnouncementController(service: services);
    });
