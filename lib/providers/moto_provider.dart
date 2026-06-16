import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../data/models/vehiculo_model.dart';

class MotoProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  VehiculoModel? _vehiculo;
  VehiculoModel? get vehiculo => _vehiculo;

  bool _isIgnitionOn = false;
  bool get isIgnitionOn => _isIgnitionOn;

  LatLng _currentLocation = const LatLng(-5.1945, -80.6328); 
  LatLng get currentLocation => _currentLocation;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RealtimeChannel? _telemetriaSubscription;

  Future<void> loadVehiculoData(String idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('vehiculo')
          .select()
          .eq('id_usuario', idUsuario)
          .maybeSingle();

      if (response != null) {
        _vehiculo = VehiculoModel.fromMap(response);
        _isIgnitionOn = response['is_ignited'] ?? false;
      }
    } catch (e) {
      debugPrint('Error cargando vehículo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void listenToTelemetria(int idRutaActiva) {
    if (_telemetriaSubscription != null) {
      _supabase.removeChannel(_telemetriaSubscription!);
    }

    _telemetriaSubscription = _supabase
        .channel('public:punto_telemetria:id_ruta=eq.$idRutaActiva')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'punto_telemetria',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_ruta',
            value: idRutaActiva,
          ),
          callback: (payload) {
            final data = payload.newRecord;
            if (data['latitud'] != null && data['longitud'] != null) {
              _currentLocation = LatLng(
                double.parse(data['latitud'].toString()),
                double.parse(data['longitud'].toString()),
              );
              notifyListeners();
            }
          },
        );

    _telemetriaSubscription?.subscribe();
  }

  Future<void> toggleIgnition(String motoId, bool newState) async {
    _isIgnitionOn = newState;
    notifyListeners(); 
    try {
      await _supabase
          .from('vehiculo') 
          .update({'is_ignited': newState}) 
          .eq('id_vehiculo', motoId);
    } catch (e) {
      _isIgnitionOn = !newState;
      notifyListeners();
      debugPrint('Error al cambiar encendido: $e');
    }
  }

  @override
  void dispose() {
    if (_telemetriaSubscription != null) {
      _supabase.removeChannel(_telemetriaSubscription!);
    }
    super.dispose();
  }
}