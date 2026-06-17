import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final int gradeLevel;
  final bool isApStudent;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.gradeLevel,
    required this.isApStudent,
    required this.createdAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      gradeLevel: data['gradeLevel'] ?? 0,
      isApStudent: data['isApStudent'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Converting FireStore JSON map data into Dart
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      gradeLevel: map['gradeLevel'] ?? 9,
      isApStudent: map['isApStudent'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  // Converting Dart back to JSON for Firestore writing
  Map<String, dynamic> toMap() {
    return {
      'fullName': name,
      'email': email,
      'role': role,
      'gradeLevel': gradeLevel,
      'isApStudent': isApStudent,
      'createdAt': Timestamp.fromDate(createdAt),
      // No need to include uid here if it's already used as the Document ID
    };
  }
}
