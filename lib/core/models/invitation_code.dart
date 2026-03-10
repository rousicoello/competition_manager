class InvitationCode {
  final int id;
  final String code;
  final String? email;
  final String role;
  final int? competitionId;
  final int generatedBy;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final bool isUsed;
  final int? usedBy;
  final DateTime? usedAt;

  InvitationCode({
    required this.id,
    required this.code,
    this.email,
    required this.role,
    this.competitionId,
    required this.generatedBy,
    required this.generatedAt,
    required this.expiresAt,
    required this.isUsed,
    this.usedBy,
    this.usedAt,
  });

  factory InvitationCode.fromJson(Map<String, dynamic> json) {
    return InvitationCode(
      id: json['id'],
      code: json['code'],
      email: json['email'],
      role: json['role'],
      competitionId: json['competition_id'],
      generatedBy: json['generated_by'],
      generatedAt: DateTime.parse(json['generated_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      isUsed: json['is_used'],
      usedBy: json['used_by'],
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
    );
  }
}