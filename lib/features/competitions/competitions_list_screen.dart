import 'package:flutter/material.dart';
import '../../core/data/mock_competitions.dart';
import '../../core/models/competition.dart';

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
    _allCompetitions = MockCompetitions.getCompetitions();
    _filteredCompetitions = List.from(_allCompetitions);
    
    // Extraer años únicos (orden descendente)
    _availableYears = _allCompetitions
        .map((c) => c.year.toString())
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Más reciente primero
    
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
      _filteredCompetitions = List.from(_allCompetitions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competencias'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        actions: [
          if (_selectedYear != null || _selectedCity != null)
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Limpiar filtros'),
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filtro por año
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: DropdownButton<String>(
                      hint: const Text('Año'),
                      value: _selectedYear,
                      underline: const SizedBox(),
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
                  
                  // Filtro por ciudad
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: DropdownButton<String>(
                      hint: const Text('Ciudad'),
                      value: _selectedCity,
                      underline: const SizedBox(),
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
                  
                  // Contador de resultados
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredCompetitions.length} torneos',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
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
          // TODO: Navegar a detalle
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
              
              const SizedBox(height: 12),
              
              // Progreso de inscripciones (si aplica)
              if (competition.status == 'REGISTRATION' && competition.maxTeams != null)
                Column(
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
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${end.year}';
  }
}