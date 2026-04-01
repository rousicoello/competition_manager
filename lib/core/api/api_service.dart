import '../models/user.dart';
import '../models/competition.dart';
import '../models/category.dart';
import '../models/team.dart';
import '../data/mock_competitions.dart';

class ApiService {
  // Simular delay de red
  static Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // ============ AUTENTICACIÓN ============
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    await _delay();
    
    // Aceptar cualquier email que termine en @sensor.ec
    if (email.endsWith('@sensor.ec') && password.isNotEmpty) {
      // Determinar rol basado en el email
      String role = 'coach';
      if (email.contains('admin')) {
        role = 'admin';
      } else if (email.contains('judge')) {
        role = 'judge';
      } else if (email.contains('student')) {
        role = 'student';
      }
      
      return {
        'success': true,
        'user': User(
          id: 1,
          email: email,
          firstName: email.split('@')[0].split('.').first.capitalize(),
          lastName: 'Usuario',
          birthDate: DateTime(1990, 1, 1),
          idType: 'CEDULA',
          idNumber: '1234567890',
          phone: '0999999999',
          role: role,
          isActive: true,
          profilePhotoUrl: 'https://ui-avatars.com/api/?name=${email.split('@')[0]}&size=100',
        ),
        'token': 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
      };
    } else {
      return {
        'success': false,
        'message': 'Credenciales inválidas. Usa un email @sensor.ec (ej: coach@sensor.ec)',
      };
    }
  }

  // ============ COMPETENCIAS ============
  
  static Future<List<Competition>> getCompetitions() async {
    await _delay();
    // Solo devolver torneos publicados
    return MockCompetitions.getCompetitions()
        .where((c) => c.isPublished)
        .toList();
  }

  static Future<Competition> getCompetition(int id) async {
    await _delay();
    final competitions = MockCompetitions.getCompetitions();
    final competition = competitions.firstWhere((c) => c.id == id);
    if (!competition.isPublished) {
      throw Exception('Competencia no disponible');
    }
    return competition;
  }

  // ============ CATEGORÍAS ============
  
  static Future<List<Category>> getCategories(int competitionId) async {
    await _delay();
    
    // Datos de prueba para categorías
    return [
      Category(
        id: 1,
        competitionId: competitionId,
        name: 'Sumo 1kg',
        description: 'Robots autónomos de hasta 1kg',
        minTeamSize: 1,
        maxTeamSize: 3,
        minAge: 12,
        maxAge: 18,
        judgingType: 'HEAD_TO_HEAD',
        isActive: true,
      ),
      Category(
        id: 2,
        competitionId: competitionId,
        name: 'Seguidor de Línea',
        description: 'Robots que siguen una línea negra',
        minTeamSize: 1,
        maxTeamSize: 2,
        minAge: 10,
        maxAge: 16,
        judgingType: 'SCORE_BASED',
        isActive: true,
      ),
      Category(
        id: 3,
        competitionId: competitionId,
        name: 'VEX IQ',
        description: 'Competencia con kits VEX IQ',
        minTeamSize: 2,
        maxTeamSize: 4,
        minAge: 8,
        maxAge: 14,
        judgingType: 'SCORE_BASED',
        isActive: true,
      ),
    ];
  }

  // ============ EQUIPOS ============
  
  static Future<List<Team>> getTeams(int competitionId) async {
    await _delay();
    
    return [
      Team(
        id: 1,
        competitionId: competitionId,
        categoryId: 1,
        coachId: 1,
        name: 'RoboTigers',
        teamNumber: 'T-001',
        institutionId: 1,
        projectTitle: 'Tigre Mecánico',
        registrationStatus: 'APPROVED',
        registrationDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Team(
        id: 2,
        competitionId: competitionId,
        categoryId: 1,
        coachId: 1,
        name: 'Sumo Masters',
        teamNumber: 'T-002',
        institutionId: 1,
        projectTitle: 'Destructor 3000',
        registrationStatus: 'APPROVED',
        registrationDate: DateTime.now().subtract(const Duration(days: 8)),
      ),
      Team(
        id: 3,
        competitionId: competitionId,
        categoryId: 2,
        coachId: 1,
        name: 'Line Follower',
        teamNumber: 'T-003',
        institutionId: 2,
        projectTitle: 'Rápido y Furioso',
        registrationStatus: 'PENDING',
        registrationDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  // ============ SOLICITUDES DE REGISTRO ============
  
  static Future<Map<String, dynamic>> submitRegistrationRequest({
    required String email,
    required String firstName,
    required String lastName,
    required String idNumber,
    required String phone,
    required String requestedRole,
    String? institution,
  }) async {
    await _delay();
    
    return {
      'success': true,
      'message': 'Solicitud enviada correctamente. Te contactaremos pronto.',
    };
  }

  // ============ VALIDAR CÓDIGO DE INVITACIÓN ============
  
  static Future<Map<String, dynamic>> validateInvitationCode(String code) async {
    await _delay();
    
    if (code.startsWith('INV-2024-') && code.length > 9) {
      return {
        'success': true,
        'role': 'coach',
        'email': 'nuevo@sensor.ec',
      };
    } else if (code == 'TEST123') {
      return {
        'success': true,
        'role': 'coach',
        'email': null,
      };
    } else {
      return {
        'success': false,
        'message': 'Código de invitación inválido. Prueba con TEST123',
      };
    }
  }
}

// Extensión para capitalizar primera letra
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}