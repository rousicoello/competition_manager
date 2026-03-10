class Team {
  final int id;
  final int competitionId;
  final int categoryId;
  final int coachId;
  final String name;
  final String? teamNumber;
  final int? institutionId;
  final String? projectTitle;
  final String registrationStatus; // 'PENDING', 'APPROVED', etc.
  final DateTime registrationDate;

  Team({
    required this.id,
    required this.competitionId,
    required this.categoryId,
    required this.coachId,
    required this.name,
    this.teamNumber,
    this.institutionId,
    this.projectTitle,
    required this.registrationStatus,
    required this.registrationDate,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      competitionId: json['competition_id'],
      categoryId: json['category_id'],
      coachId: json['coach_id'],
      name: json['name'],
      teamNumber: json['team_number'],
      institutionId: json['institution_id'],
      projectTitle: json['project_title'],
      registrationStatus: json['registration_status'],
      registrationDate: DateTime.parse(json['registration_date']),
    );
  }
}