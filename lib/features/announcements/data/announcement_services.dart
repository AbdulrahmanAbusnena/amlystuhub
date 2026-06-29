import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/announcement_model.dart';

class AnnouncementServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Planning on creating server side filtering

  /*  

 So after doing research, and reviews done by Gemini and ChatGPT I found a 
 structural error, I found the query fetches every single announcement ever 
 created in the entire school database. For example if the school hits 1,000
 announcements, a grade 9 students will have to download 1,000 documents over the 
 networks just to read 3 updates relevant to them. It will make the reads skyrockets 
 and the rendering process, highly inefficient. 
  */
  //  // fetching the Stream
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
