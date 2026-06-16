import 'package:flutter/material.dart';

class SupervisorDashboardScreen extends StatelessWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: const Text('Monitoreo (Supervisor)', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF252538),
      ),
      body: const Center(
        child: Text(
          'Vista global de rutas activas y tickets de soporte de Piura.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}