import 'package:amlystuhub/features/academics/data/services/academic_services.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_units_model.dart';
import 'package:amlystuhub/features/academics/domain/models/resource_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final academicsServiceProvider = Provider<AcademicsService>((ref) {
  return AcademicsService();
});

final coursesStreamProvider = StreamProvider<List<AcademicCourseModel>>((ref) {
  final service = ref.watch(academicsServiceProvider);
  return service.streamCourses();
});

final courseUnitsStreamProvider =
    StreamProvider.family<List<AcademicUnitModel>, String>((ref, courseId) {
      final service = ref.watch(academicsServiceProvider);
      return service.streamUnitsForCourse(courseId);
    });

final courseResourcesStreamProvider =
    StreamProvider.family<List<AcademicResourceModel>, String>((ref, courseId) {
      final service = ref.watch(academicsServiceProvider);
      return service.streamResourcesForCourse(courseId);
    });

final selectedResourceTypeFilterProvider =
    StateProvider.autoDispose<AcademicResourceType?>((ref) => null);

class AcademicsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createCourse(AcademicCourseModel course) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).createCourse(course),
    );
  }

  Future<void> updateCourse(AcademicCourseModel course) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).updateCourse(course),
    );
  }

  Future<void> deleteCourse(String courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).deleteCourse(courseId),
    );
  }

  Future<void> createResource(AcademicResourceModel resource) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).createResource(resource),
    );
  }

  Future<void> updateResource(AcademicResourceModel resource) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).updateResource(resource),
    );
  }

  Future<void> deleteResource(String resourceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(academicsServiceProvider).deleteResource(resourceId),
    );
  }

  Future<void> toggleHelpfulRating(String resourceId, String userId) async {
    await ref
        .read(academicsServiceProvider)
        .toggleHelpfulRating(resourceId, userId);
  }
}

final academicsControllerProvider =
    AsyncNotifierProvider<AcademicsController, void>(AcademicsController.new);
