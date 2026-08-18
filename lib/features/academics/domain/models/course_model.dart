import 'package:flutter/material.dart';
import 'academic_models.dart';

class ApCourseModel {
  final String id;
  final String title;
  final String code;
  final String description;
  final int colorHex;
  final String? generalGuideDriveUrl;
  final List<AcademicSubBranch> branches;

  const ApCourseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.colorHex,
    this.generalGuideDriveUrl,
    this.branches = const [],
  });

  Color get themeColor => Color(colorHex);

  factory ApCourseModel.fromMap(Map<String, dynamic> map, String docId) {
    return ApCourseModel(
      id: docId,
      title: map['title'] as String? ?? '',
      code: map['code'] as String? ?? '',
      description: map['description'] as String? ?? '',
      colorHex: map['colorHex'] as int? ?? 0xFF0284C7,
      generalGuideDriveUrl: map['generalGuideDriveUrl'] as String?,
      branches:
          (map['branches'] as List<dynamic>?)
              ?.map(
                (x) => AcademicSubBranch.fromMap(
                  Map<String, dynamic>.from(x as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'code': code,
      'description': description,
      'colorHex': colorHex,
      'generalGuideDriveUrl': generalGuideDriveUrl,
      'branches': branches.map((x) => x.toMap()).toList(),
    };
  }
}
