import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Función para iniciar sesión con Email y Contraseña
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notifica a la interfaz para que muestre un spinner de carga

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      
      // Si el usuario existe y se autenticó correctamente, retorna true
      return response.user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false; // Error en credenciales o conexión
    }
  }

  // Función para cerrar sesión
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}