import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/announcement_model.dart';

class AnnouncementServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // fetching the Stream
  Stream<List<AnnouncementsModel>> getAnnouncementsStream() {
    return _firestore
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementsModel.fromDocument(doc))
              .toList(),
        );
  }

  // writing records : pushing new announcements map to the database
  Future<void> createAnnouncement(AnnouncementsModel announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  // toggling a studens uid inside the  array
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
