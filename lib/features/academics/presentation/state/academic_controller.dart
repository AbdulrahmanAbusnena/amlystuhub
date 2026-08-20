import 'package:amlystuhub/features/academics/data/services/academic_services.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/domain/models/course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/course_section_model.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final academicServiceProvider = Provider((ref) => AcademicRemoteService());

// Stream Provider for the UI grid
final coursesStreamProvider = StreamProvider<List<SubjectCourseModel>>((ref) {
  return ref.watch(academicServiceProvider).getCourses();
});

class AcademicController extends StateNotifier<AsyncValue<void>> {
  final AcademicRemoteService _service;

  AcademicController(this._service) : super(const AsyncValue.data(null));

  // 1. Admin creates a new course card from the main screen
  Future<bool> createCourse({
    required String code,
    required String title,
    required String description,
    required bool isAp,
    required String category,
  }) async {
    state = const AsyncValue.loading();
    try {
      final course = SubjectCourseModel(
        id: '',
        code: code,
        title: title,
        description: description,
        isAp: isAp,
        colorHex: 0xFF0284C7,
        sections: const [],
      );
      await _service.addCourse(course);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  // 2. Admin adds a new unit/section inside a specific course detail page
  Future<bool> createSection({
    required String courseId,
    required String sectionTitle,
  }) async {
    try {
      final section = CourseSection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: sectionTitle,
        resources: const [],
      );
      await _service.addSection(courseId, section);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 3. Admin adds a Drive link or PDF to a section
  Future<bool> createResource({
    required String courseId,
    required String sectionId,
    required String resourceTitle,
    required String url,
    required ResourceType type,
  }) async {
    try {
      final resource = AcademicResource(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: resourceTitle,
        url: url,
        type: type,
      );
      await _service.addResource(
        courseId: courseId,
        sectionId: sectionId,
        resource: resource,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final academicControllerProvider =
    StateNotifierProvider<AcademicController, AsyncValue<void>>((ref) {
      return AcademicController(ref.watch(academicServiceProvider));
    });
