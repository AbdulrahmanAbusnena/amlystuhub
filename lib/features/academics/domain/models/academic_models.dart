enum ResourceType { driveFolder, driveDoc, pdf, externalLink }

class AcademicResource {
  final String id;
  final String title;
  final String url;
  final ResourceType type;

  const AcademicResource({
    required this.id,
    required this.title,
    required this.url,
    this.type = ResourceType.driveFolder,
  });

  factory AcademicResource.fromMap(Map<String, dynamic> map) {
    return AcademicResource(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      url: map['url'] as String? ?? '',
      type: ResourceType.values.firstWhere(
        (e) => e.name == (map['type'] as String? ?? ''),
        orElse: () => ResourceType.driveFolder,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'url': url, 'type': type.name};
  }
}
