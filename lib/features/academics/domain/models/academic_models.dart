enum ResourceType {
  richText,
  pdf,
  driveFolder,
  externalLink;

  static ResourceType fromString(String? value) {
    return ResourceType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ResourceType.richText,
    );
  }
}

class AcademicResource {
  final String id;
  final String title;
  final String? description;
  final String? url;
  final String? richTextContent; // For in-app native markdown/rich text reader
  final ResourceType type;
  final bool isFeatured;

  const AcademicResource({
    required this.id,
    required this.title,
    this.description,
    this.url,
    this.richTextContent,
    required this.type,
    this.isFeatured = false,
  });

  factory AcademicResource.fromMap(Map<String, dynamic> map) {
    return AcademicResource(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      url: map['url'] as String?,
      richTextContent: map['richTextContent'] as String?,
      type: ResourceType.fromString(map['type'] as String?),
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'richTextContent': richTextContent,
      'type': type.name,
      'isFeatured': isFeatured,
    };
  }
}
