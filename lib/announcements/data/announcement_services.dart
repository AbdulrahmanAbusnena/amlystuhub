import 'package:amlystuhub/announcements/domain/models/announcement_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AnnouncementServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Stream new announcements orderd by the newwest first

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

  // Publishing new announcement

  Future<void> publishAnnouncement({
    required String title,
    required String content,
    required String category,
    required List<int> targetGrades,
    required bool apOnly,
  }) async {
    try {
      final callable = _functions.httpsCallable('createAnnouncement');
      await callable.call({
        'title': title,
        'content': content,
        'category': category,
        'targetGrades': targetGrades,
        'apOnly': apOnly,
      });
    } on FirebaseFunctionsException catch (e) {
      throw e.message ??
          'Failed to publish announcement. (Report this back to Abdulrahman!!)';
    } catch (e) {
      throw 'A network connection error occurred.';
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
