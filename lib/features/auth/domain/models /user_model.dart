import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final int gradeLevel;
  final bool isApStudent;
  final DateTime createdAt;
  final DateTime? lastLoginAt; // Optional field for tracking last login time

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.gradeLevel,
    required this.isApStudent,
    required this.createdAt,
    this.lastLoginAt,
  });
  // So we have to convert the TimeStamp to DateTime with null checks
  // ignore: unused_element
  static DateTime _safeTimestampToDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      gradeLevel: data['gradeLevel'] ?? 0,
      isApStudent: data['isApStudent'] ?? false,
      createdAt: _safeTimestampToDate(data['createdAt']),
      lastLoginAt: _safeTimestampToDate(data['lastLoginAt']),
    );
  }

  // Converting FireStore JSON map data into Dart
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      gradeLevel: map['gradeLevel'] ?? 9,
      isApStudent: map['isApStudent'] ?? false,
      createdAt: _safeTimestampToDate(map['createdAt']),
      lastLoginAt: _safeTimestampToDate(map['lastLoginAt']),
    );
  }

  // Convrt UserModel to Map for Firestore writing
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'gradeLevel': gradeLevel,
      'isApStudent': isApStudent,
      'createdAt': Timestamp.fromDate(createdAt),
      if (lastLoginAt != null) 'lastLoginAt': Timestamp.fromDate(lastLoginAt!),
    };
  }
}

  UserModel copyWith({ 


  }) { 

}