class OrientationEventModel {
  final String id;
  final String title;
  final String timeLocation;
  final String description;
  final int orderIndex;

  const OrientationEventModel({
    required this.id,
    required this.title,
    required this.timeLocation,
    required this.description,
    this.orderIndex = 0,
  });

  factory OrientationEventModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return OrientationEventModel(
      id: docId,
      title: map['title'] as String? ?? '',
      timeLocation: map['timeLocation'] as String? ?? '',
      description: map['description'] as String? ?? '',
      orderIndex: map['orderIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timeLocation': timeLocation,
      'description': description,
      'orderIndex': orderIndex,
    };
  }
}
