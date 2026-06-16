import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:v_link_app/data/models/alerta_model.dart';
import 'package:v_link_app/core/theme/vlink_theme.dart';

class AlertsProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<AlertaModel> _alertsList = [];
  List<AlertaModel> get alertsList => _alertsList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RealtimeChannel? _alertsSubscription;

  Future<void> fetchAlertsHistory(int idVehiculo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('alerta')
          .select()
          .eq('id_vehiculo', idVehiculo)
          .order('fecha_hora', ascending: false);

      _alertsList = (response as List).map((json) => AlertaModel.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void listenToRealtimeAlerts(int idVehiculo, BuildContext context) {
    if (_alertsSubscription != null) {
      _supabase.removeChannel(_alertsSubscription!);
    }

    _alertsSubscription = _supabase
        .channel('public:alerta:id_vehiculo=eq.$idVehiculo')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'alerta',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_vehiculo',
            value: idVehiculo,
          ),
          callback: (payload) {
            final data = payload.newRecord;
            if (data.isNotEmpty) {
              final nuevaAlerta = AlertaModel.fromMap(data);
              _alertsList.insert(0, nuevaAlerta);
              notifyListeners();
              _showEmergencyDialog(context, nuevaAlerta);
            }
          },
        )
        .subscribe();
  }

  void _showEmergencyDialog(BuildContext context, AlertaModel alerta) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: VLinkTheme.darkCard,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: VLinkTheme.alertRed, size: 30),
              const SizedBox(width: 10),
              Text(alerta.tipoAlerta, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(alerta.descripcion, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('ENTENDIDO', style: TextStyle(color: VLinkTheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_alertsSubscription != null) {
      _supabase.removeChannel(_alertsSubscription!);
    }
    super.dispose();
  }
}