class RegistrationRequest {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String idNumber;
  final String phone;
  final String requestedRole; // 'coach', 'judge', 'student'
  final String? institution;
  final String idDocumentUrl;
  final String? supportingDocumentUrl;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final DateTime createdAt;

  RegistrationRequest({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.phone,
    required this.requestedRole,
    this.institution,
    required this.idDocumentUrl,
    this.supportingDocumentUrl,
    required this.status,
    required this.createdAt,
  });

  // Para crear desde JSON (cuando conectes con API)
  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      idNumber: json['id_number'],
      phone: json['phone'],
      requestedRole: json['requested_role'],
      institution: json['institution'],
      idDocumentUrl: json['id_document_url'],
      supportingDocumentUrl: json['supporting_document_url'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}