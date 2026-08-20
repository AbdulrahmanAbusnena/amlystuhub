enum ProgramType { ap, generalHS }

enum ResourceCategory { overview, guides, practice, videos }

enum ResourceType { pdf, driveFolder, youtube, externalLink }

class AcademicSubjectModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final ProgramType programType;
  final String category; // e.g., 'STEM', 'Humanities'
  final int colorHex;
  final String? driveFolderUrl;

  const AcademicSubjectModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.programType,
    required this.category,
    required this.colorHex,
    this.driveFolderUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'programType': programType.name,
      'category': category,
      'colorHex': colorHex,
      'driveFolderUrl': driveFolderUrl,
    };
  }

  factory AcademicSubjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return AcademicSubjectModel(
      id: docId,
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      programType: ProgramType.values.firstWhere(
        (e) => e.name == map['programType'],
        orElse: () => ProgramType.ap,
      ),
      category: map['category'] ?? 'General',
      colorHex: map['colorHex'] ?? 0xFF0284C7,
      driveFolderUrl: map['driveFolderUrl'],
    );
  }
}

class AcademicResourceModel {
  final String id;
  final String? subjectId; // null if it belongs to General AP Guide
  final bool isGeneralAp;
  final String title;
  final String description;
  final ResourceCategory tabCategory;
  final ResourceType resourceType;
  final String url;
  final String? unitTag; // e.g., 'Unit 1', 'Exam Prep'

  const AcademicResourceModel({
    required this.id,
    this.subjectId,
    required this.isGeneralAp,
    required this.title,
    required this.description,
    required this.tabCategory,
    required this.resourceType,
    required this.url,
    this.unitTag,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'isGeneralAp': isGeneralAp,
      'title': title,
      'description': description,
      'tabCategory': tabCategory.name,
      'resourceType': resourceType.name,
      'url': url,
      'unitTag': unitTag,
    };
  }

  factory AcademicResourceModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return AcademicResourceModel(
      id: docId,
      subjectId: map['subjectId'],
      isGeneralAp: map['isGeneralAp'] ?? false,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      tabCategory: ResourceCategory.values.firstWhere(
        (e) => e.name == map['tabCategory'],
        orElse: () => ResourceCategory.guides,
      ),
      resourceType: ResourceType.values.firstWhere(
        (e) => e.name == map['resourceType'],
        orElse: () => ResourceType.externalLink,
      ),
      url: map['url'] ?? '',
      unitTag: map['unitTag'],
    );
  }
}
