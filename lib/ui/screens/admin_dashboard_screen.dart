import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: const Text('Consola de Administración', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF252538),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminCard(Icons.people, 'Usuarios globales'),
          _buildAdminCard(Icons.motorcycle, 'Vehículos registrados'),
          _buildAdminCard(Icons.settings, 'Configuración Sistema'),
          _buildAdminCard(Icons.analytics, 'Auditoría de Alertas'),
        ],
      ),
    );
  }

  Widget _buildAdminCard(IconData icon, String title) {
    return Card(
      color: const Color(0xFF252538),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blueAccent),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}