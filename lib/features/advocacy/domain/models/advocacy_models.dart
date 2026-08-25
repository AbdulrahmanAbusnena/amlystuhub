import 'package:cloud_firestore/cloud_firestore.dart';

enum TicketCategory {
  academics,
  eventsAndActivities,
  advocacyAndPolicy,
  executiveLeadership,
  platformAndTech,
  generalAdvice;

  String get displayName {
    switch (this) {
      case TicketCategory.academics:
        return 'Academics & Workload';
      case TicketCategory.eventsAndActivities:
        return 'Events & Student Life';
      case TicketCategory.advocacyAndPolicy:
        return 'Advocacy & School Policy';
      case TicketCategory.executiveLeadership:
        return 'Executive Leadership (President & VP)';
      case TicketCategory.platformAndTech:
        return 'Platform & Technical Issues';
      case TicketCategory.generalAdvice:
        return 'General Advice & Feedback';
    }
  }
}

enum TicketStatus {
  submitted,
  underReview,
  inProgress,
  resolved,
  dismissed;

  String get displayName {
    switch (this) {
      case TicketStatus.submitted:
        return 'Submitted';
      case TicketStatus.underReview:
        return 'Under Review';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.dismissed:
        return 'Dismissed';
    }
  }
}

class TicketModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorEmail;
  final TicketCategory category;
  final String subject;
  final String description;
  final bool isDiscreet;
  final bool apOnly;
  final TicketStatus status;
  final String? internalNote;
  final DateTime createdAt;

  TicketModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.category,
    required this.subject,
    required this.description,
    required this.isDiscreet,
    required this.apOnly,
    required this.status,
    this.internalNote,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json, String id) {
    return TicketModel(
      id: id,
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Student',
      authorEmail: json['authorEmail'] as String? ?? '',
      category: TicketCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TicketCategory.generalAdvice,
      ),
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isDiscreet: json['isDiscreet'] as bool? ?? false,
      apOnly: json['apOnly'] as bool? ?? false,
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.submitted,
      ),
      internalNote: json['internalNote'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'category': category.name,
      'subject': subject,
      'description': description,
      'isDiscreet': isDiscreet,
      'apOnly': apOnly,
      'status': status.name,
      if (internalNote != null) 'internalNote': internalNote,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class SurveyModel {
  final String id;
  final String title;
  final String description;
  final String googleFormUrl;
  final String targetGrade;
  final bool apOnly;
  final bool isActive;
  final DateTime createdAt;

  SurveyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.googleFormUrl,
    required this.targetGrade,
    required this.apOnly,
    required this.isActive,
    required this.createdAt,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json, String id) {
    return SurveyModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      googleFormUrl: json['googleFormUrl'] as String? ?? '',
      targetGrade: json['targetGrade'] as String? ?? 'All',
      apOnly: json['apOnly'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'googleFormUrl': googleFormUrl,
      'targetGrade': targetGrade,
      'apOnly': apOnly,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
