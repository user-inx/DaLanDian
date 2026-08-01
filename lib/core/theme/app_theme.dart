import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF1565C0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: Colors.white,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: primaryColor.withAlpha(38),
      ),
    );
  }
}