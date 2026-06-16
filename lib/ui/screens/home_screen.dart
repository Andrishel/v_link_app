import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/moto_provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final motoProv = Provider.of<MotoProvider>(context, listen: false);
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        motoProv.loadVehiculoData(user.id);
      } else {
        motoProv.loadVehiculoData("3");
      }

      motoProv.listenToTelemetria(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final motoProvider = Provider.of<MotoProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('V-LINK Monitor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2E),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: motoProvider.currentLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.v_link_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: motoProvider.currentLocation,
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 45,
                      color: motoProvider.isIgnitionOn ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Card(
              color: const Color(0xFF1E1E2E).withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          motoProvider.vehiculo != null 
                              ? '${motoProvider.vehiculo!.marca} ${motoProvider.vehiculo!.modelo}'
                              : 'Cargando vehículo...',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Placa: ${motoProvider.vehiculo?.placa ?? '---'}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          motoProvider.isIgnitionOn ? 'Estado: Encendido' : 'Estado: Apagado',
                          style: TextStyle(
                            color: motoProvider.isIgnitionOn ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: motoProvider.isIgnitionOn,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      onChanged: motoProvider.isLoading
                          ? null
                          : (value) async {
                              final motoId = motoProvider.vehiculo?.idVehiculo.toString() ?? '1';
                              await motoProvider.toggleIgnition(motoId, value);
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (motoProvider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}