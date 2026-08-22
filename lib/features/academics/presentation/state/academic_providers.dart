// 1. Service Provider
import 'package:amlystuhub/features/academics/data/services/academic_services.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final academicServiceProvider = Provider<AcademicService>((ref) {
  return AcademicService(FirebaseFirestore.instance);
});

// 2. Controller Provider
final academicControllerProvider =
    StateNotifierProvider<AcademicController, AcademicState>((ref) {
      final service = ref.watch(academicServiceProvider);
      return AcademicController(service, ref);
    });

// 3. Filtered Courses Stream (Access Guarded by Grade Level / Scope if needed)
final coursesStreamProvider = StreamProvider<List<CourseModel>>((ref) {
  final service = ref.watch(academicServiceProvider);
  return service.streamCourses();
});

// 4. Stream General Resources
final generalResourcesStreamProvider =
    StreamProvider.family<List<ResourceModel>, String>((ref, courseId) {
      final service = ref.watch(academicServiceProvider);
      return service.streamGeneralResources(courseId);
    });

// 5. Stream Units
final unitsStreamProvider = StreamProvider.family<List<UnitModel>, String>((
  ref,
  courseId,
) {
  final service = ref.watch(academicServiceProvider);
  return service.streamUnits(courseId);
});

// 6. Stream Unit-Specific Resources
final unitResourcesStreamProvider =
    StreamProvider.family<
      List<ResourceModel>,
      ({String courseId, String unitId})
    >((ref, arg) {
      final service = ref.watch(academicServiceProvider);
      return service.streamUnitResources(arg.courseId, arg.unitId);
    });
