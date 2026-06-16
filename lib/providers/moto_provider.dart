import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';

class MotoProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isIgnitionOn = false;
  bool get isIgnitionOn => _isIgnitionOn;

  LatLng _currentLocation = const LatLng(-5.1945, -80.6328); 
  LatLng get currentLocation => _currentLocation;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RealtimeChannel? _motoSubscription;

  void listenToMotoChanges(String motoId) {
    _isLoading = true;
    notifyListeners();

    _fetchInitialState(motoId);

    if (_motoSubscription != null) {
      _supabase.removeChannel(_motoSubscription!);
    }

    _motoSubscription = _supabase
        .channel('public:punto_telemetria')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'punto_telemetria',
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

    _motoSubscription?.subscribe();
  }

  Future<void> _fetchInitialState(String motoId) async {
    try {
      final data = await _supabase
          .from('vehiculo') 
          .select()
          .eq('id_vehiculo', motoId) 
          .single();

      _isIgnitionOn = data['is_ignited'] ?? false; 
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
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
    }
  }

  @override
  void dispose() {
    if (_motoSubscription != null) {
      _supabase.removeChannel(_motoSubscription!);
    }
    super.dispose();
  }
}