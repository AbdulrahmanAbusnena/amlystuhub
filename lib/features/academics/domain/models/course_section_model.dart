import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';

class CourseSection {
  final String id;
  final String title;
  final int orderIndex;
  final List<AcademicResource> resources;

  const CourseSection({
    required this.id,
    required this.title,
    this.orderIndex = 0,
    this.resources = const [],
  });

  factory CourseSection.fromMap(Map<String, dynamic> map) {
    return CourseSection(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      orderIndex: map['orderIndex'] as int? ?? 0,
      resources:
          (map['resources'] as List<dynamic>?)
              ?.map(
                (x) => AcademicResource.fromMap(
                  Map<String, dynamic>.from(x as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'orderIndex': orderIndex,
      'resources': resources.map((x) => x.toMap()).toList(),
    };
  }
}
