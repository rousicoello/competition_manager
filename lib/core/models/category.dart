class Category {
  final int id;
  final int competitionId;
  final String name;
  final String? description;
  final int minTeamSize;
  final int maxTeamSize;
  final int? minAge;
  final int? maxAge;
  final String judgingType; // 'HEAD_TO_HEAD', 'SCORE_BASED', etc.
  final bool isActive;

  Category({
    required this.id,
    required this.competitionId,
    required this.name,
    this.description,
    required this.minTeamSize,
    required this.maxTeamSize,
    this.minAge,
    this.maxAge,
    required this.judgingType,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      competitionId: json['competition_id'],
      name: json['name'],
      description: json['description'],
      minTeamSize: json['min_team_size'] ?? 1,
      maxTeamSize: json['max_team_size'] ?? 10,
      minAge: json['min_age'],
      maxAge: json['max_age'],
      judgingType: json['judging_type'],
      isActive: json['is_active'] ?? true,
    );
  }
}