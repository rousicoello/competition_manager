class Competition {
  final int id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final String venueName;
  final String venueAddress;
  final String venueCity;
  final String status; // 'DRAFT', 'REGISTRATION', 'IN_PROGRESS', 'COMPLETED'
  final int? maxTeams;
  final int registeredTeams;
  final String? logoUrl;
  final String? bannerUrl;
  final bool isPublished;

  Competition({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.registrationStartDate,
    required this.registrationEndDate,
    required this.venueName,
    required this.venueAddress,
    required this.venueCity,
    required this.status,
    this.maxTeams,
    required this.registeredTeams,
    this.logoUrl,
    this.bannerUrl,
    required this.isPublished,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      registrationStartDate: DateTime.parse(json['registration_start_date']),
      registrationEndDate: DateTime.parse(json['registration_end_date']),
      venueName: json['venue_name'],
      venueAddress: json['venue_address'],
      venueCity: json['venue_city'],
      status: json['status'],
      maxTeams: json['max_teams'],
      registeredTeams: json['registered_teams'] ?? 0,
      logoUrl: json['logo_url'],
      bannerUrl: json['banner_url'],
      isPublished: json['is_published'] ?? false,
    );
  }

  // Para saber si las inscripciones están abiertas
  bool get isRegistrationOpen {
    final now = DateTime.now();
    return now.isAfter(registrationStartDate) && 
           now.isBefore(registrationEndDate) &&
           status == 'REGISTRATION';
  }

  // Para saber si ya comenzó
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(startDate) && 
           now.isBefore(endDate) &&
           status == 'IN_PROGRESS';
  }
}