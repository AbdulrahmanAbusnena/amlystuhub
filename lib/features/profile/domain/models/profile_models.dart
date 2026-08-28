import 'package:cloud_firestore/cloud_firestore.dart';

enum ProfileRequestStatus { pending, approved, rejected }

class ProfileRequestModel {
  final String id;
  final String uid;
  final String studentName;
  final String studentEmail;
  final int requestedGradeLevel;
  final bool requestedIsApStudent;
  final int currentGradeLevel;
  final bool currentIsApStudent;
  final ProfileRequestStatus status;
  final DateTime createdAt;

  ProfileRequestModel({
    required this.id,
    required this.uid,
    required this.studentName,
    required this.studentEmail,
    required this.requestedGradeLevel,
    required this.requestedIsApStudent,
    required this.currentGradeLevel,
    required this.currentIsApStudent,
    required this.status,
    required this.createdAt,
  });

  factory ProfileRequestModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return ProfileRequestModel(
      id: docId,
      uid: json['uid'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      studentEmail: json['studentEmail'] as String? ?? '',
      requestedGradeLevel: (json['requestedGradeLevel'] as num?)?.toInt() ?? 9,
      requestedIsApStudent: json['requestedIsApStudent'] as bool? ?? false,
      currentGradeLevel: (json['currentGradeLevel'] as num?)?.toInt() ?? 9,
      currentIsApStudent: json['currentIsApStudent'] as bool? ?? false,
      status: ProfileRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProfileRequestStatus.pending,
      ),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'requestedGradeLevel': requestedGradeLevel,
      'requestedIsApStudent': requestedIsApStudent,
      'currentGradeLevel': currentGradeLevel,
      'currentIsApStudent': currentIsApStudent,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
