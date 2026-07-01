// Service Provider
import 'package:amlystuhub/features/announcements/data/announcement_services.dart';
import 'package:amlystuhub/features/announcements/domain/models/announcement_model.dart';
import 'package:amlystuhub/features/announcements/presentation/controllers/announcement_controllers.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../controllers/announcement_state.dart';

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

// Stream Provider
final filterAnnouncementProvider = StreamProvider<List<AnnouncementsModel>>((
  ref,
) {
  // Grabbing the database service handler
  final services = ref.watch(announcementServicesProvider);

  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;

  if (user == null) {
    return Stream.value([]);
  }

  if (user.role.toSystemString() == 'stuco_leads' ||
      user.role.toSystemString() == 'head_of_academics' ||
      user.role.toSystemString() == 'stuCoAdmin') {
    return services.getAnnouncementsStream();
  } else {
    return services
        .getSudentFeedStream(
          gradeLevel: user.gradeLevel,
          isApStudent: user.isApStudent,
        )
        .asStream()
        .map(
          (announcementGroups) =>
              announcementGroups.expand((group) => group).toList(),
        );
  }
});
