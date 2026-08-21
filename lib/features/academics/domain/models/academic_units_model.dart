class AcademicUnitModel {
  final String id;
  final String courseId;
  final int unitNumber;
  final String title;
  final String description;

  const AcademicUnitModel({
    required this.id,
    required this.courseId,
    required this.unitNumber,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'unitNumber': unitNumber,
      'title': title,
      'description': description,
    };
  }

  factory AcademicUnitModel.fromMap(Map<String, dynamic> map, String docId) {
    return AcademicUnitModel(
      id: docId,
      courseId: map['courseId'] ?? '',
      unitNumber: map['unitNumber'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
