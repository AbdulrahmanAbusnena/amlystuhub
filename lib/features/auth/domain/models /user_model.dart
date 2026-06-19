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

  // creating a copy with modified fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    int? gradeLevel,
    bool? isApStudent,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      isApStudent: isApStudent ?? this.isApStudent,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// We have top Check who the users are
  bool get isStuCoAdmin => role == 'stuco_admin';

  bool get isStudent => role == 'student';

  bool get isHeadofAcademics => role == 'head_of_academics';

  bool get isSchoolAdmin => role == 'school_admin';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; 

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.gradeLevel == gradeLevel &&
        other.isApStudent == isApStudent &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt;
  } 
  @override 
  int get hashCode { 
    return uid.hasc
  }

}
