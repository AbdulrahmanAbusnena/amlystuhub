import 'package:amlystuhub/features/academics/domain/models/course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/orientation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicState {
  final AsyncValue<List<SubjectCourseModel>> courses;
  final AsyncValue<List<OrientationEventModel>> orientationEvents;

  const AcademicState({
    this.courses = const AsyncValue.loading(),
    this.orientationEvents = const AsyncValue.loading(),
  });

  AcademicState copyWith({
    AsyncValue<List<SubjectCourseModel>>? courses,
    AsyncValue<List<OrientationEventModel>>? orientationEvents,
  }) {
    return AcademicState(
      courses: courses ?? this.courses,
      orientationEvents: orientationEvents ?? this.orientationEvents,
    );
  }
}
