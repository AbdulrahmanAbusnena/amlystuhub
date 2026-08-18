import 'package:amlystuhub/features/academics/domain/models/course_section_model.dart';

class SubjectCourseModel {
  final String id;
  final String title;
  final String code;
  final String description;
  final int colorHex;
  final bool isAp;
  final List<CourseSection> sections;

  const SubjectCourseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.colorHex,
    this.isAp = true,
    this.sections = const [],
  });

  factory SubjectCourseModel.fromMap(Map<String, dynamic> map, String docId) {
    return SubjectCourseModel(
      id: docId,
      title: map['title'] as String? ?? '',
      code: map['code'] as String? ?? '',
      description: map['description'] as String? ?? '',
      colorHex: map['colorHex'] as int? ?? 0xFF0284C7,
      isAp: map['isAp'] as bool? ?? true,
      sections:
          (map['sections'] as List<dynamic>?)
              ?.map(
                (x) =>
                    CourseSection.fromMap(Map<String, dynamic>.from(x as Map)),
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
      'isAp': isAp,
      'sections': sections.map((x) => x.toMap()).toList(),
    };
  }
}
