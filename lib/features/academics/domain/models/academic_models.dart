class AcademicSubBranch {
  final String id;
  final String title;
  final String? description;
  final String? driveUrl;
  final String? richTextNotes;
  final List<AcademicSubBranch> subBranches;

  const AcademicSubBranch({
    required this.id,
    required this.title,
    this.description,
    this.driveUrl,
    this.richTextNotes,
    this.subBranches = const [],
  });

  factory AcademicSubBranch.fromMap(Map<String, dynamic> map) {
    return AcademicSubBranch(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      driveUrl: map['driveUrl'] as String?,
      richTextNotes: map['richTextNotes'] as String?,
      subBranches:
          (map['subBranches'] as List<dynamic>?)
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
      'id': id,
      'title': title,
      'description': description,
      'driveUrl': driveUrl,
      'richTextNotes': richTextNotes,
      'subBranches': subBranches.map((x) => x.toMap()).toList(),
    };
  }
}
