import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/models/announcement_model.dart';
import 'announcement_state.dart';
import 'package:amlystuhub/features/auth/domain/models /user_model.dart';
import '../../data/announcement_services.dart';

class AnnouncementController extends StateNotifier<AnnouncementState> {
  final AnnouncementServices _service;

  AnnouncementController({required AnnouncementServices service})
    : _service = service,
      super(AnnouncementState.initial());

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

    return false;
  }
}
