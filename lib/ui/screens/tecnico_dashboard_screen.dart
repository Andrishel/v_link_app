import 'package:flutter/material.dart';

class TecnicoDashboardScreen extends StatelessWidget {
  const TecnicoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: const Text('Panel Técnico V-LINK', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF252538),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Dispositivos IoT Pendientes de Activación', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Card(
                  color: const Color(0xFF252538),
                  child: ListTile(
                    leading: const Icon(Icons.developer_board, color: Colors.orangeAccent),
                    title: Text('ESP32 - ID: 000${index + 1}', style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Estado: No vinculado', style: TextStyle(color: Colors.grey)),
                    trailing: ElevatedButton(onPressed: () {}, child: const Text('Configurar')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}