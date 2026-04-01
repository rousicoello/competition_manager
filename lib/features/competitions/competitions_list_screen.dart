import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/data/mock_competitions.dart';
import '../../core/models/competition.dart';
import '../../core/providers/auth_provider.dart';
import 'competition_detail_screen.dart';

class CompetitionsListScreen extends StatefulWidget {
  const CompetitionsListScreen({super.key});

  @override
  State<CompetitionsListScreen> createState() => _CompetitionsListScreenState();
}

class _CompetitionsListScreenState extends State<CompetitionsListScreen> {
  List<Competition> _allCompetitions = [];
  List<Competition> _filteredCompetitions = [];
  
  // Filtros seleccionados
  String? _selectedYear;
  String? _selectedCity;
  
  // Opciones para filtros
  List<String> _availableYears = [];
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Obtener competencias y ordenar por fecha (más reciente primero)
    _allCompetitions = MockCompetitions.getCompetitions();
    _allCompetitions.sort((a, b) => b.startDate.compareTo(a.startDate));
    
    _filteredCompetitions = List.from(_allCompetitions);
    
    // Extraer años únicos (orden descendente)
    _availableYears = _allCompetitions
        .map((c) => c.year.toString())
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    
    // Extraer ciudades únicas
    _availableCities = _allCompetitions
        .map((c) => c.venueCity)
        .toSet()
        .toList()
      ..sort();
    
    setState(() {});
  }

  void _applyFilters() {
    setState(() {
      _filteredCompetitions = _allCompetitions.where((comp) {
        // Solo mostrar torneos publicados
        if (!comp.isPublished) return false;
        
        // Filtrar por año
        if (_selectedYear != null && comp.year.toString() != _selectedYear) {
          return false;
        }
        // Filtrar por ciudad
        if (_selectedCity != null && comp.venueCity != _selectedCity) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedYear = null;
      _selectedCity = null;
      _filteredCompetitions = _allCompetitions.where((comp) => comp.isPublished).toList();
    });
  }

  void _logout() {
    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener información del usuario actual
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.firstName ?? 'Usuario';
    final userRole = _getRoleName(authProvider.currentUser?.role);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competencias'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        actions: [
          // Botón de cerrar sesión
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userRole,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de filtros
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                // Filtro por año
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Año'),
                      value: _selectedYear,
                      underline: const SizedBox(),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todos')),
                        ..._availableYears.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value;
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                ),
                
                // Filtro por ciudad
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Ciudad'),
                      value: _selectedCity,
                      underline: const SizedBox(),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todas')),
                        ..._availableCities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                ),
                
                // Contador de resultados
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_filteredCompetitions.length}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de torneos
          Expanded(
            child: _filteredCompetitions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay torneos con esos filtros',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Limpiar filtros'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCompetitions.length,
                    itemBuilder: (context, index) {
                      final competition = _filteredCompetitions[index];
                      return _buildCompetitionCard(competition);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard(Competition competition) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompetitionDetailScreen(
                competitionId: competition.id,
                currentUser: authProvider.currentUser!,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con año y estado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      competition.year.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: competition.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      competition.statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: competition.statusColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Ciudad con ícono
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        competition.venueCity,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Nombre del torneo
              Text(
                competition.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Descripción (limitada a 2 líneas)
              if (competition.description != null)
                Text(
                  competition.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Fechas
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateRange(competition.startDate, competition.endDate),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Lugar
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      competition.venueName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Progreso de inscripciones (solo si está en registro)
              if (competition.status == 'REGISTRATION' && competition.maxTeams != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cupos disponibles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '${competition.maxTeams! - competition.registeredTeams} / ${competition.maxTeams}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: competition.registeredTeams / competition.maxTeams!,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(Colors.green.shade500),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleName(String? role) {
    switch (role) {
      case 'admin':
        return 'Administrador';
      case 'coach':
        return 'Entrenador';
      case 'judge':
        return 'Juez';
      case 'student':
        return 'Estudiante';
      default:
        return 'Usuario';
    }
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${end.year}';
  }
}