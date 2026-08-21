class AcademicCourseModel {
  final String id;
  final String title;
  final String code;
  final String description;
  final String mainDriveFolderUrl;
  final bool isAp;
  final List<String> unitIds;

  const AcademicCourseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.mainDriveFolderUrl,
    this.isAp = true,
    this.unitIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'description': description,
      'mainDriveFolderUrl': mainDriveFolderUrl,
      'isAp': isAp,
      'unitIds': unitIds,
    };
  }

  factory AcademicCourseModel.fromMap(Map<String, dynamic> map, String docId) {
    return AcademicCourseModel(
      id: docId,
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      mainDriveFolderUrl: map['mainDriveFolderUrl'] ?? '',
      isAp: map['isAp'] ?? true,
      unitIds: List<String>.from(map['unitIds'] ?? []),
    );
  }
}
