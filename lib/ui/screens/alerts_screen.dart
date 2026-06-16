import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alerts_provider.dart';
import '../../core/theme/vlink_theme.dart';

class AlertsScreen extends StatefulWidget {
  final int idVehiculo;
  const AlertsScreen({super.key, required this.idVehiculo});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alertsProv = Provider.of<AlertsProvider>(context, listen: false);
      alertsProv.fetchAlertsHistory(widget.idVehiculo);
      alertsProv.listenToRealtimeAlerts(widget.idVehiculo, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertsProvider = Provider.of<AlertsProvider>(context);
    final isDarkMode = Theme.of(context).scaffoldBackgroundColor == VLinkTheme.darkBg;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Alertas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: alertsProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: VLinkTheme.primary))
          : alertsProvider.alertsList.isEmpty
              ? const Center(child: Text('No hay alertas registradas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: alertsProvider.alertsList.length,
                  itemBuilder: (context, index) {
                    final alerta = alertsProvider.alertsList[index];
                    return Card(
                      color: isDarkMode ? VLinkTheme.darkCard : VLinkTheme.lightCard,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDarkMode ? const Color(0xFF2C1E21) : const Color(0xFFFFEDED),
                          child: const Icon(Icons.notifications_active, color: VLinkTheme.alertRed),
                        ),
                        title: Text(alerta.tipoAlerta, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alerta.descripcion),
                            Text(
                              '${alerta.fechaHora.day}/${alerta.fechaHora.month} - ${alerta.fechaHora.hour}:${alerta.fechaHora.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}