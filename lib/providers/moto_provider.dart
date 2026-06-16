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

  Future<void> loadVehiculoData(dynamic idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      final intIdUsuario = int.tryParse(idUsuario.toString());

      if (intIdUsuario != null) {
        final response = await _supabase
            .from('vehiculo')
            .select()
            .eq('id_usuario', intIdUsuario)
            .maybeSingle();

        if (response != null) {
          _vehiculo = VehiculoModel.fromMap(response);
          _isIgnitionOn = response['is_ignited'] ?? false;
        }
      } else {
        final userResponse = await _supabase
            .from('usuario')
            .select('id_usuario')
            .eq('correo_electronico', idUsuario.toString())
            .maybeSingle();

        if (userResponse != null) {
          final dbId = int.parse(userResponse['id_usuario'].toString());
          final response = await _supabase
              .from('vehiculo')
              .select()
              .eq('id_usuario', dbId)
              .maybeSingle();

          if (response != null) {
            _vehiculo = VehiculoModel.fromMap(response);
            _isIgnitionOn = response['is_ignited'] ?? false;
          }
        }
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
      final intIdVehiculo = int.tryParse(motoId) ?? 1;
      await _supabase
          .from('vehiculo') 
          .update({'is_ignited': newState}) 
          .eq('id_vehiculo', intIdVehiculo);
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