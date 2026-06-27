enum UserRole {
  student,
  stuCoLead,
  headOfAcademics,
  stuCoAdmin;

  static UserRole fromString(String roleStr) {
    switch (roleStr) {
      case 'stuco_leads':
        return UserRole.stuCoLead; // Updated lookup
      case 'head_of_academics':
        return UserRole.headOfAcademics;
      case 'school_admin':
        return UserRole.stuCoAdmin;
      case 'student':
      default:
        return UserRole.student;
    }
  }
}
