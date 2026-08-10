import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AnnouncementModel>> getAnnouncementsStream() {
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

  Future<void> publishAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore.collection('announcements').add(announcement.toMap());
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to publish announcement.';
    } catch (e) {
      throw 'An unexpected connection error occurred.';
    }
  }

  Future<void> updateAnnouncement(
    String announcementId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(announcementId)
          .update(updatedData);
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to update announcement.';
    } catch (e) {
      throw 'An unexpected error occurred while updating.';
    }
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await _firestore.collection('announcements').doc(announcementId).delete();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to delete announcement.';
    } catch (e) {
      throw 'An unexpected error occurred while deleting.';
    }
  }

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
