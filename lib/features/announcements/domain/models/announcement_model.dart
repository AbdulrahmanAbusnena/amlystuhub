import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String authRole; // Role: 'head_of_academics' or 'school_admin
  final String category; // 'AP' 'General' 'Grade 9'

  final List<int> targetGrades; // e.g., [10, 11] to restrict visibility
  final bool apOnly;

  final DateTime createdAt;
  final List<String> pinnedByUids;
}
