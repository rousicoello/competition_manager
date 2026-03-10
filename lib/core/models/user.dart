class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String idType; // 'CEDULA', 'PASSPORT'
  final String idNumber;
  final String phone;
  final String? profilePhotoUrl;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? instagramHandle;
  final String role; // 'coach', 'student', 'judge', 'organizer', 'admin'
  final bool isActive;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.idType,
    required this.idNumber,
    required this.phone,
    this.profilePhotoUrl,
    this.linkedinUrl,
    this.githubUrl,
    this.instagramHandle,
    required this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: DateTime.parse(json['birth_date']),
      idType: json['id_type'],
      idNumber: json['id_number'],
      phone: json['phone'],
      profilePhotoUrl: json['profile_photo_url'],
      linkedinUrl: json['linkedin_url'],
      githubUrl: json['github_url'],
      instagramHandle: json['instagram_handle'],
      role: json['role'],
      isActive: json['is_active'],
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.parse(json['email_verified_at']) 
          : null,
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toIso8601String(),
      'id_type': idType,
      'id_number': idNumber,
      'phone': phone,
      'profile_photo_url': profilePhotoUrl,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'instagram_handle': instagramHandle,
      'role': role,
      'is_active': isActive,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}