import 'package:flutter/material.dart';

class VLinkTheme {
  // Paleta de Colores Oficial de V-LINK
  static const Color darkBg = Color(0xFF1E1E2E);    // Fondo tecnológico oscuro
  static const Color darkCard = Color(0xFF252538);  // Tarjetas oscuras
  static const Color lightBg = Color(0xFFF5F5FA);   // Fondo claro
  static const Color lightCard = Color(0xFFFFFFFF); // Tarjetas claras
  
  static const Color primary = Colors.blueAccent;   // Azul V-LINK
  static const Color alertRed = Color(0xFFFF4D4D);  // Rojo de alerta crítica

  // Configuración del tema para la App
  static ThemeData getTheme(bool isDarkMode) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isDarkMode ? darkBg : lightBg,
      cardColor: isDarkMode ? darkCard : lightCard,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? darkCard : primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        bodyMedium: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
    );
  }
}