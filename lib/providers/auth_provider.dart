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

      final userData = await _supabase
          .from('usuario')
          .select('rol')
          .eq('correo_electronico', response.user!.email!)
          .maybeSingle();

      if (userData != null) {
        _userRole = userData['rol'].toString();
      } else {
        _userRole = 'usuario';
      }

      _isLoading = false;
      notifyListeners();
      return _userRole;
      
    } catch (e) {
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