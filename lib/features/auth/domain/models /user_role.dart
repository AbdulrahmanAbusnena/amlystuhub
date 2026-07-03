enum UserRole {
  student,
  stuCoLead,
  headOfAcademics,
  stuCoAdmin;

  static UserRole fromString(String roleStr) {
    switch (roleStr) {
      case 'stuco_leads':
        return UserRole.stuCoLead;
      case 'head_of_academics':
        return UserRole.headOfAcademics;
      case 'stuCoAdmin':
        return UserRole.stuCoAdmin;
      case 'student':
      default:
        return UserRole.student;
    }
  }

  String toSystemString() {
    switch (this) {
      case UserRole.stuCoLead:
        return 'stuco_leads'; // Updated persistence string
      case UserRole.headOfAcademics:
        return 'head_of_academics';
      case UserRole.stuCoAdmin:
        return 'stuCoAdmin';
      case UserRole.student:
        return 'student';
    }
  }

  // Can create announcements?
  bool get canPublishAnnouncements => this != UserRole.student;

  // What kind of announcement categories can this role issue?
  List<String> get allowedAnnouncementCategories {
    switch (this) {
      case UserRole.stuCoAdmin:
        return ['General', 'Exam', 'AP', 'StuCo', 'Emergency'];
      case UserRole.headOfAcademics:
        return ['AP', 'Exam', 'General', 'StuCo'];
      case UserRole.stuCoLead: // Updated capabilities map
        return ['StuCo', 'General'];
      case UserRole.student:
        return [];
    }
  }

  int get hierarchyLevel {
    switch (this) {
      case UserRole.stuCoAdmin:
        return 4;
      case UserRole.headOfAcademics:
        return 3;
      case UserRole.stuCoLead:
        return 2; // Updated hierarchy tracking
      case UserRole.student:
        return 1;
    }
  }
}
