import 'package:flutter/material.dart';
import '../../core/models/competition.dart';
import '../../core/models/user.dart';
import '../../core/api/api_service.dart';

class CompetitionDetailScreen extends StatefulWidget {
  final int competitionId;
  final User currentUser;  // Nuevo parámetro

  
  const CompetitionDetailScreen({
    super.key,
    required this.competitionId,
    required this.currentUser,  // Nuevo

  });

  @override
  State<CompetitionDetailScreen> createState() => _CompetitionDetailScreenState();
}

class _CompetitionDetailScreenState extends State<CompetitionDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<Competition> _competitionFuture;
  late Future<List<dynamic>> _categoriesFuture;
  late Future<List<dynamic>> _teamsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() {
    _competitionFuture = ApiService.getCompetition(widget.competitionId);
    _categoriesFuture = ApiService.getCategories(widget.competitionId);
    _teamsFuture = ApiService.getTeams(widget.competitionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Competition>(
        future: _competitionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }

          final competition = snapshot.data!;
          
          return Column(
            children: [
              // AppBar personalizada
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Barra superior con botón de volver
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      // Información del torneo
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              competition.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  competition.venueCity,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // TabBar
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: const [
                          Tab(icon: Icon(Icons.info), text: 'Info'),
                          Tab(icon: Icon(Icons.category), text: 'Categorías'),
                          Tab(icon: Icon(Icons.group), text: 'Equipos'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(competition),
                    _buildCategoriesTab(),
                    _buildTeamsTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  Widget _buildInfoTab(Competition competition) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: competition.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              competition.statusText,
              style: TextStyle(
                color: competition.statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Descripción
          if (competition.description != null) ...[
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              competition.description!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 24),
          ],
          
          // Fechas
          const Text(
            'Fechas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Inicio'),
              subtitle: Text(_formatDate(competition.startDate)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fin'),
              subtitle: Text(_formatDate(competition.endDate)),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Lugar
          const Text(
            'Lugar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(competition.venueName),
              subtitle: Text(competition.venueAddress),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Cupos
          if (competition.maxTeams != null) ...[
            const Text(
              'Cupos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Equipos registrados',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          '${competition.registeredTeams} / ${competition.maxTeams}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: competition.registeredTeams / competition.maxTeams!,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return FutureBuilder<List<dynamic>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final categories = snapshot.data!;
        
        if (categories.isEmpty) {
          return const Center(child: Text('No hay categorías disponibles'));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.category, color: Colors.blue.shade700),
                ),
                title: Text(category.name),
                subtitle: Text(category.description ?? 'Sin descripción'),
                trailing: Chip(
                  label: Text('${category.minTeamSize}-${category.maxTeamSize} integrantes'),
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTeamsTab() {
    return FutureBuilder<List<dynamic>>(
      future: _teamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final teams = snapshot.data!;
        
        if (teams.isEmpty) {
          return const Center(child: Text('No hay equipos registrados'));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: Text(
                    team.teamNumber?.substring(0, 1) ?? 'E',
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ),
                title: Text(team.name),
                subtitle: Text('N° ${team.teamNumber}'),
                trailing: Chip(
                  label: Text(team.registrationStatus),
                  backgroundColor: team.registrationStatus == 'APPROVED'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingButton() {
    return FutureBuilder<Competition>(
      future: _competitionFuture,
      builder: (context, snapshot) {
        // Mostrar botón solo si:
      // 1. El torneo está en fase de registro
      // 2. El usuario es coach
      if (snapshot.hasData && 
          snapshot.data!.status == 'REGISTRATION' &&
          widget.currentUser.role == 'coach' ||
          widget.currentUser.role == 'admin' ||
          widget.currentUser.role == 'super_admin') {
        return FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidad en desarrollo')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Inscribir Equipo'),
          backgroundColor: const Color(0xFF10B981),
        );
      }
      return const SizedBox.shrink();
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}