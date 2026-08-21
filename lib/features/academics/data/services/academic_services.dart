import 'package:amlystuhub/features/academics/domain/models/academic_course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_units_model.dart';
import 'package:amlystuhub/features/academics/domain/models/resource_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicsService {
  final FirebaseFirestore _firestore;

  AcademicsService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<AcademicCourseModel>> streamCourses() {
    return _firestore
        .collection('academic_courses')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AcademicCourseModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AcademicUnitModel>> streamUnitsForCourse(String courseId) {
    return _firestore
        .collection('academic_units')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => AcademicUnitModel.fromMap(doc.data(), doc.id))
                  .toList()
                ..sort((a, b) => a.unitNumber.compareTo(b.unitNumber)),
        );
  }

  Stream<List<AcademicResourceModel>> streamResourcesForCourse(
    String courseId,
  ) {
    return _firestore
        .collection('academic_resources')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AcademicResourceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Course Section

  Future<void> createCourse(AcademicCourseModel course) async {
    final docRef = _firestore.collection('academic_courses').doc();
    await docRef.set(course.toMap());
  }

  Future<void> updateCourse(AcademicCourseModel course) async {
    await _firestore
        .collection('academic_courses')
        .doc(course.id)
        .update(course.toMap());
  }

  Future<void> deleteCourse(String courseId) async {
    await _firestore.collection('academic_courses').doc(courseId).delete();
  }

  // Units Section

  Future<void> createUnit(AcademicUnitModel unit) async {
    final docRef = _firestore.collection('academic_units').doc();
    await docRef.set(unit.toMap());
  }

  Future<void> updateUnit(AcademicUnitModel unit) async {
    await _firestore
        .collection('academic_units')
        .doc(unit.id)
        .update(unit.toMap());
  }

  Future<void> deleteUnit(String unitId) async {
    await _firestore.collection('academic_units').doc(unitId).delete();
  }

  // Resources Section

  Future<void> createResource(AcademicResourceModel resource) async {
    final docRef = _firestore.collection('academic_resources').doc();
    await docRef.set(resource.toMap());
  }

  Future<void> updateResource(AcademicResourceModel resource) async {
    await _firestore
        .collection('academic_resources')
        .doc(resource.id)
        .update(resource.toMap());
  }

  Future<void> deleteResource(String resourceId) async {
    await _firestore.collection('academic_resources').doc(resourceId).delete();
  }

  // --- INTERACTION MUTATIONS ---

  Future<void> toggleHelpfulRating(String resourceId, String userId) async {
    final docRef = _firestore.collection('academic_resources').doc(resourceId);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final resource = AcademicResourceModel.fromMap(doc.data()!, doc.id);
    final hasUpvoted = resource.helpfulUserIds.contains(userId);

    if (hasUpvoted) {
      await docRef.update({
        'helpfulCount': FieldValue.increment(-1),
        'helpfulUserIds': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'helpfulCount': FieldValue.increment(1),
        'helpfulUserIds': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
