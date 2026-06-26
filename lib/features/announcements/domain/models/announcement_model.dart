import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String authorRole; // Role: 'head_of_academics' or 'school_admin
  final String category; // 'AP' 'General' 'Grade 9'

  final List<int> targetGrades; // e.g., [10, 11] to restrict visibility
  final bool apOnly;

  final DateTime createdAt;
  final List<String> pinnedByUids;

  AnnouncementsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.category,
    required this.targetGrades,
    required this.apOnly,
    required this.createdAt,
    this.pinnedByUids = const [],
  });
  // safe timestamping
  static DateTime _safeTimestampToDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  factory AnnouncementsModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Announcement data is empty');

    return AnnouncementsModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorRole: data['authorRole'] ?? '',
      category: data['category'] ?? 'General',
      targetGrades: List<int>.from(data['targetGrades'] ?? []),
      apOnly: data['apOnly'] ?? false,
      createdAt: _safeTimestampToDate(data['createdAt']),
      pinnedByUids: List<String>.from(data['pinnedByUids'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'category': category,
      'targetGrades': targetGrades,
      'apOnly': apOnly,
      'createdAt': Timestamp.fromDate(createdAt),
      'pinnedByUids': pinnedByUids,
    };
  }
}
