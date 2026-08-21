enum AcademicResourceType {
  googleDoc,
  googleDrive,
  youtube,
  externalLink,
  pdfDownload,
}

class AcademicResourceModel {
  final String id;
  final String unitId;
  final String courseId;
  final String title;
  final String description;
  final AcademicResourceType type;
  final String url;
  final int helpfulCount;
  final List<String> helpfulUserIds;
  final bool isOfflinePdf;

  const AcademicResourceModel({
    required this.id,
    required this.unitId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    this.helpfulCount = 0,
    this.helpfulUserIds = const [],
    this.isOfflinePdf = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unitId': unitId,
      'courseId': courseId,
      'title': title,
      'description': description,
      'type': type.name,
      'url': url,
      'helpfulCount': helpfulCount,
      'helpfulUserIds': helpfulUserIds,
      'isOfflinePdf': isOfflinePdf,
    };
  }

  factory AcademicResourceModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return AcademicResourceModel(
      id: docId,
      unitId: map['unitId'] ?? '',
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: AcademicResourceType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AcademicResourceType.externalLink,
      ),
      url: map['url'] ?? '',
      helpfulCount: map['helpfulCount'] ?? 0,
      helpfulUserIds: List<String>.from(map['helpfulUserIds'] ?? []),
      isOfflinePdf: map['isOfflinePdf'] ?? false,
    );
  }
}
