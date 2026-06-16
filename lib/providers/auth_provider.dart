import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _userRole;
  String? get userRole => _userRole;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) throw Exception("Usuario no encontrado");
      print("DEBUG: Autenticación exitosa. Email en Auth: ${response.user!.email}");

      final userData = await _supabase
          .from('usuario')
          .select('rol')
          .eq('correo_electronico', response.user!.email!)
          .maybeSingle();

      print("DEBUG: Resultado de la consulta en tabla pública: $userData");

      if (userData != null) {
        _userRole = userData['rol'].toString();
      } else {
        print("DEBUG: No se encontró registro o RLS bloqueó la fila. Asignando rol por defecto.");
        _userRole = 'usuario';
      }

      _isLoading = false;
      notifyListeners();
      print("DEBUG: Rol final retornado: $_userRole");
      return _userRole;
      
    } catch (e) {
      print("DEBUG: Cayó en el bloque CATCH. Error real: $e");
      _isLoading = false;
      _userRole = null;
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    _userRole = null;
    await _supabase.auth.signOut();
    notifyListeners();
  }
}