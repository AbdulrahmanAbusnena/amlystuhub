import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AnnouncementModel>> getStudentAnnouncementsStream({
    required int userGrade,
    required bool isApStudent,
    required bool isSchoolAdmin,
  }) {
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

    // Pass userGrade inside arrayContainsAny directly
    return _firestore
        .collection('announcements')
        .where('targetGrades', arrayContainsAny: [userGrade])
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementModel.fromDocument(doc))
              .where((announcement) {
                // Filter out posts targeted to specific AP permissions client side
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
