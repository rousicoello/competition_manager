import 'package:flutter/material.dart';

class CompetitionsListScreen extends StatelessWidget {
  const CompetitionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navegar a perfil
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Temporal
        itemBuilder: (context, index) {
          final competitions = [
            {
              'name': 'Torneo Nacional de Robótica 2024',
              'date': '15-20 Junio 2024',
              'location': 'Guayaquil',
              'status': 'Inscripciones abiertas',
              'color': Colors.green,
            },
            {
              'name': 'VEX IQ Championship',
              'date': '5-7 Julio 2024',
              'location': 'Quito',
              'status': 'Próximamente',
              'color': Colors.orange,
            },
            {
              'name': 'Sumo Robot League',
              'date': '22-24 Agosto 2024',
              'location': 'Cuenca',
              'status': 'En planificación',
              'color': Colors.blue,
            },
            {
              'name': 'RoboCup Junior',
              'date': '10-12 Septiembre 2024',
              'location': 'Guayaquil',
              'status': 'Inscripciones cerradas',
              'color': Colors.red,
            },
            {
              'name': 'First Lego League',
              'date': '5-7 Octubre 2024',
              'location': 'Loja',
              'status': 'Confirmado',
              'color': Colors.purple,
            },
          ];
          final comp = competitions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: comp['color'] as Color? ?? Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                ),
              ),
              title: Text(comp['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        comp['date'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        comp['location'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Chip(
                label: Text(
                  comp['status'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: comp['color'] as Color? ?? Colors.blue,
              ),
              onTap: () {
                // TODO: Navegar a detalle de competencia
              },
            ),
          );
        },
      ),
            floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Crear nueva competencia (solo admins)
        },
        label: const Text('Nueva Competencia'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}