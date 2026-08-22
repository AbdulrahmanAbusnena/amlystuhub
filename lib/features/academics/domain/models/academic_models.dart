enum ResourceType { link, pdf, googleDrive, video }

class ResourceModel {
  final String id;
  final String title;
  final String url;
  final ResourceType type;
  final String? tag; // Optional metadata (e.g., "FRQ Strategy", "Cheat Sheet")
  final int order;
  final DateTime createdAt;

  ResourceModel({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    this.tag,
    this.order = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'type': type.name,
    'tag': tag,
    'order': order,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ResourceModel.fromJson(Map<String, dynamic> json, String docId) =>
      ResourceModel(
        id: docId,
        title: json['title'] ?? '',
        url: json['url'] ?? '',
        type: ResourceType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ResourceType.link,
        ),
        tag: json['tag'],
        order: json['order'] ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class UnitModel {
  final String id;
  final int unitNumber;
  final String title;
  final String description;
  final int order;

  UnitModel({
    required this.id,
    required this.unitNumber,
    required this.title,
    required this.description,
    this.order = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'unitNumber': unitNumber,
    'title': title,
    'description': description,
    'order': order,
  };

  factory UnitModel.fromJson(Map<String, dynamic> json, String docId) =>
      UnitModel(
        id: docId,
        unitNumber: json['unitNumber'] ?? 1,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        order: json['order'] ?? 0,
      );
}

class CourseModel {
  final String id;
  final String title;
  final String code;
  final String description;
  final String category; // "AP", "General", "Advisory"
  final int order;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.category,
    this.order = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'code': code,
    'description': description,
    'category': category,
    'order': order,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CourseModel.fromJson(Map<String, dynamic> json, String docId) =>
      CourseModel(
        id: docId,
        title: json['title'] ?? '',
        code: json['code'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? 'AP',
        order: json['order'] ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}
