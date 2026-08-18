import 'dart:async';

import 'package:amlystuhub/features/academics/data/services/academic_services.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/domain/models/course_section_model.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final academicRemoteServiceProvider = Provider<AcademicRemoteService>((ref) {
  return AcademicRemoteService(FirebaseFirestore.instance);
});

final academicControllerProvider =
    StateNotifierProvider<AcademicController, AcademicState>((ref) {
      final service = ref.watch(academicRemoteServiceProvider);
      return AcademicController(service);
    });

class AcademicController extends StateNotifier<AcademicState> {
  final AcademicRemoteService _remoteService;
  StreamSubscription? _coursesSub;
  StreamSubscription? _orientationSub;

  AcademicController(this._remoteService) : super(const AcademicState()) {
    _init();
  }

  void _init() {
    _coursesSub = _remoteService.getApCoursesStream().listen(
      (courses) {
        state = state.copyWith(courses: AsyncValue.data(courses));
      },
      onError: (err, st) {
        state = state.copyWith(courses: AsyncValue.error(err, st));
      },
    );

    _orientationSub = _remoteService.getOrientationScheduleStream().listen(
      (events) {
        state = state.copyWith(orientationEvents: AsyncValue.data(events));
      },
      onError: (err, st) {
        state = state.copyWith(orientationEvents: AsyncValue.error(err, st));
      },
    );
  }

  /// Adds a new section (e.g., "Guides & Syllabus") to a course
  Future<bool> addSectionToCourse({
    required String courseId,
    required String sectionTitle,
  }) async {
    try {
      final currentCourses = state.courses.value ?? [];
      final course = currentCourses.firstWhere((c) => c.id == courseId);

      final newSection = CourseSection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: sectionTitle,
        orderIndex: course.sections.length,
        resources: const [],
      );

      final updatedSections = [...course.sections, newSection];
      await _remoteService.updateCourseSections(courseId, updatedSections);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds a resource (Drive link, PDF, external site) to a specific section inside a course
  Future<bool> addResourceToSection({
    required String courseId,
    required String sectionId,
    required String resourceTitle,
    required String url,
    required ResourceType type,
    String? description,
  }) async {
    try {
      final currentCourses = state.courses.value ?? [];
      final course = currentCourses.firstWhere((c) => c.id == courseId);

      final newResource = AcademicResource(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: resourceTitle,
        description: description,
        url: url,
        type: type,
      );

      final updatedSections = course.sections.map((section) {
        if (section.id == sectionId) {
          return CourseSection(
            id: section.id,
            title: section.title,
            orderIndex: section.orderIndex,
            resources: [...section.resources, newResource],
          );
        }
        return section;
      }).toList();

      await _remoteService.updateCourseSections(courseId, updatedSections);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _coursesSub?.cancel();
    _orientationSub?.cancel();
    super.dispose();
  }
}
