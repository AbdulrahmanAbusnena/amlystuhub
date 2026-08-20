import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _subjectsRef =>
      _firestore.collection('academic_subjects');

  CollectionReference<Map<String, dynamic>> get _resourcesRef =>
      _firestore.collection('academic_resources');

  // Streams
  Stream<List<AcademicSubjectModel>> getSubjectsByProgram(
    ProgramType programType,
  ) {
    return _subjectsRef
        .where('programType', isEqualTo: programType.name)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AcademicSubjectModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AcademicResourceModel>> getGeneralApResources() {
    return _resourcesRef
        .where('isGeneralAp', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AcademicResourceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<AcademicResourceModel>> getSubjectResources(String subjectId) {
    return _resourcesRef
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AcademicResourceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Mutations
  Future<void> addSubject(AcademicSubjectModel subject) async {
    await _subjectsRef.add(subject.toMap());
  }

  Future<void> updateSubject(
    String subjectId,
    AcademicSubjectModel subject,
  ) async {
    await _subjectsRef.doc(subjectId).update(subject.toMap());
  }

  Future<void> deleteSubject(String subjectId) async {
    await _subjectsRef.doc(subjectId).delete();
  }

  Future<void> addResource(AcademicResourceModel resource) async {
    await _resourcesRef.add(resource.toMap());
  }

  Future<void> updateResource(
    String resourceId,
    AcademicResourceModel resource,
  ) async {
    await _resourcesRef.doc(resourceId).update(resource.toMap());
  }

  Future<void> deleteResource(String resourceId) async {
    await _resourcesRef.doc(resourceId).delete();
  }
}
