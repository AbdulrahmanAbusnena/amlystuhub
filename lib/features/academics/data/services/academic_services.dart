import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final academicServiceProvider = Provider<AcademicService>((ref) {
  return AcademicService(FirebaseFirestore.instance);
});

class AcademicService {
  final FirebaseFirestore _db;

  AcademicService(this._db);

  // Collection Reference Helper
  CollectionReference<Map<String, dynamic>> get _coursesRef =>
      _db.collection('courses');

  Stream<List<CourseModel>> streamCourses() {
    return _coursesRef
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CourseModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<ResourceModel>> streamGeneralResources(String courseId) {
    return _coursesRef
        .doc(courseId)
        .collection('resources')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ResourceModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Stream of units for a specific course
  Stream<List<UnitModel>> streamUnits(String courseId) {
    return _coursesRef
        .doc(courseId)
        .collection('units')
        .orderBy('unitNumber', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UnitModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Stream of resources specific to a unit
  Stream<List<ResourceModel>> streamUnitResources(
    String courseId,
    String unitId,
  ) {
    return _coursesRef
        .doc(courseId)
        .collection('units')
        .doc(unitId)
        .collection('resources')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ResourceModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Add a new Course
  Future<void> addCourse(CourseModel course) async {
    final docRef = _coursesRef.doc();
    await docRef.set(course.toJson());
  }

  /// Add a General / Course-wide Resource
  Future<void> addGeneralResource(
    String courseId,
    ResourceModel resource,
  ) async {
    final docRef = _coursesRef.doc(courseId).collection('resources').doc();
    await docRef.set(resource.toJson());
  }

  /// Add a Unit to a Course
  Future<void> addUnit(String courseId, UnitModel unit) async {
    final docRef = _coursesRef.doc(courseId).collection('units').doc();
    await docRef.set(unit.toJson());
  }

  /// Add a Resource to a specific Unit
  Future<void> addUnitResource(
    String courseId,
    String unitId,
    ResourceModel resource,
  ) async {
    final docRef = _coursesRef
        .doc(courseId)
        .collection('units')
        .doc(unitId)
        .collection('resources')
        .doc();
    await docRef.set(resource.toJson());
  }
}
