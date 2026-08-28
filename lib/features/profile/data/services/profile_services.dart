import 'package:amlystuhub/features/profile/domain/models/profile_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Direct Name Update
  Future<void> updateName(String uid, String newName) async {
    await _firestore.collection('users').doc(uid).update({'name': newName});
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(newName);
    }
  }

  /// Password Update (Requires fresh credentials or current password check upstream)
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw 'User is not authenticated.';
    await user.updatePassword(newPassword);
  }

  /// Create Approval Request for Grade / AP Status Changes
  Future<void> submitProfileChangeRequest({
    required String uid,
    required String studentName,
    required String studentEmail,
    required int currentGrade,
    required bool currentAp,
    required int requestedGrade,
    required bool requestedAp,
  }) async {
    final requestDoc = _firestore.collection('profile_requests').doc();
    final request = ProfileRequestModel(
      id: requestDoc.id,
      uid: uid,
      studentName: studentName,
      studentEmail: studentEmail,
      requestedGradeLevel: requestedGrade,
      requestedIsApStudent: requestedAp,
      currentGradeLevel: currentGrade,
      currentIsApStudent: currentAp,
      status: ProfileRequestStatus.pending,
      createdAt: DateTime.now(),
    );

    await requestDoc.set(request.toJson());
  }

  /// Watch pending requests for the current student
  Stream<List<ProfileRequestModel>> watchUserRequests(String uid) {
    return _firestore
        .collection('profile_requests')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProfileRequestModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Admin View: Watch all pending requests
  Stream<List<ProfileRequestModel>> watchPendingAdminRequests() {
    return _firestore
        .collection('profile_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProfileRequestModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Admin Action: Process Request
  Future<void> processRequest(ProfileRequestModel request, bool approve) async {
    final batch = _firestore.batch();
    final requestRef = _firestore
        .collection('profile_requests')
        .doc(request.id);

    if (approve) {
      final userRef = _firestore.collection('users').doc(request.uid);
      batch.update(userRef, {
        'gradeLevel': request.requestedGradeLevel,
        'isApStudent': request.requestedIsApStudent,
      });
      batch.update(requestRef, {'status': ProfileRequestStatus.approved.name});
    } else {
      batch.update(requestRef, {'status': ProfileRequestStatus.rejected.name});
    }

    await batch.commit();
  }
}
