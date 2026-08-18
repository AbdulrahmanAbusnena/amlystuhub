import 'package:amlystuhub/features/academics/domain/models/course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/course_section_model.dart';
import 'package:amlystuhub/features/academics/domain/models/orientation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicRemoteService {
  final FirebaseFirestore _firestore;

  AcademicRemoteService(this._firestore);

  /// Streams all courses from Firestore
  Stream<List<SubjectCourseModel>> getApCoursesStream() {
    return _firestore.collection('ap_courses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SubjectCourseModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Streams all orientation timeline events ordered by index
  Stream<List<OrientationEventModel>> getOrientationScheduleStream() {
    return _firestore
        .collection('orientation_schedule')
        .orderBy('orderIndex', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => OrientationEventModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  /// Updates the entire list of sections for a specific course
  Future<void> updateCourseSections(
    String courseId,
    List<CourseSection> sections,
  ) async {
    final rawSections = sections.map((s) => s.toMap()).toList();
    await _firestore.collection('ap_courses').doc(courseId).update({
      'sections': rawSections,
    });
  }

  /// Adds a single course document
  Future<void> addCourse(SubjectCourseModel course) async {
    await _firestore.collection('ap_courses').add(course.toMap());
  }

  /// Updates top-level course details (title, code, description, color)
  Future<void> updateCourseDetails(
    String courseId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('ap_courses').doc(courseId).update(data);
  }
}
