import 'package:amlystuhub/features/auth/domain/models /user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/domain/models /user_role.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final UserRole authorRole;
  final String authorName;
  final String category;
  final List<int> targetGrades;
  final bool apOnly;
  final DateTime createdAt;
  final List<String> pinnedByUids;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorRole,
    required this.authorName,
    required this.category,
    required this.targetGrades,
    required this.apOnly,
    required this.createdAt,
    this.pinnedByUids = const [],
  });

  static DateTime _safeTimestampToDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  factory AnnouncementModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Announcement document payload is empty');

    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorRole: UserRole.fromString(data['authorRole'] ?? 'student'),
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
      'authorRole': authorRole.toSystemString(),
      'category': category,
      'targetGrades': targetGrades,
      'apOnly': apOnly,
      'createdAt': Timestamp.fromDate(createdAt),
      'pinnedByUids': pinnedByUids,
    };
  }
}
