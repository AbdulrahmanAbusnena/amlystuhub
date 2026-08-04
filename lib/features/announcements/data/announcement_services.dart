import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// OPTIMIZED READ: Only fetches up to 20 announcements relevant to the student
  Stream<List<AnnouncementModel>> getStudentAnnouncementsStream({
    required int userGrade,
    required bool isApStudent,
    required bool isSchoolAdmin,
  }) {
    // School Admins see everything
    if (isSchoolAdmin) {
      return _firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => AnnouncementModel.fromDocument(doc))
                .toList(),
          );
    }

    // Students only fetch recent posts targeted to their grade or general broadcasts
    return _firestore
        .collection('announcements')
        .where('targetGrades', arrayContainsAny: [[], userGrade])
        .orderBy('createdAt', descending: true)
        .limit(20) // Saves database reads & bandwidth
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementModel.fromDocument(doc))
              .where((announcement) {
                if (announcement.apOnly && !isApStudent) return false;
                return true;
              })
              .toList(),
        );
  }

  /// WRITE: Direct write from Flutter (Free Spark Plan compatible)
  Future<void> publishAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore.collection('announcements').add(announcement.toMap());
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to publish announcement.';
    } catch (e) {
      throw 'An unexpected connection error occurred.';
    }
  }

  /// PIN/UNPIN: Direct array update
  Future<void> togglePin(
    String announcementId,
    String userId,
    bool shouldPin,
  ) async {
    final docRef = _firestore.collection('announcements').doc(announcementId);
    await docRef.update({
      'pinnedByUids': shouldPin
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
    });
  }
}
