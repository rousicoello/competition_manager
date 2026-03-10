import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/competition.dart';
import '../models/category.dart';
import '../models/team.dart';

class ApiService {
  // Cambia esto por la URL real de tu API
  static const String baseUrl = 'https://ares.magozolutions.net/api';
  
  // Almacenar token de autenticación
  static String? _authToken;
  
  // Headers por defecto
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // ============ AUTENTICACIÓN ============
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Guardar token
        _authToken = data['token'];
        
        // Devolver usuario y token
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al iniciar sesión',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // ============ COMPETENCIAS ============
  
  static Future<List<Competition>> getCompetitions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/competitions'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Competition.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar competencias');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Competition> getCompetition(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/competitions/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Competition.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al cargar competencia');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ============ CATEGORÍAS ============
  
  static Future<List<Category>> getCategories(int competitionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/competitions/$competitionId/categories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar categorías');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ============ EQUIPOS ============
  
  static Future<List<Team>> getTeams(int competitionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/competitions/$competitionId/teams'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Team.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar equipos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ============ REGISTRO DE SOLICITUDES ============
  
  static Future<Map<String, dynamic>> submitRegistrationRequest({
    required String email,
    required String firstName,
    required String lastName,
    required String idNumber,
    required String phone,
    required String requestedRole,
    String? institution,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registration-requests'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'id_number': idNumber,
          'phone': phone,
          'requested_role': requestedRole,
          'institution': institution,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Solicitud enviada correctamente',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al enviar solicitud',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // ============ VALIDAR CÓDIGO DE INVITACIÓN ============
  
  static Future<Map<String, dynamic>> validateInvitationCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-invitation'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': code}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'role': data['role'],
          'email': data['email'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Código inválido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}