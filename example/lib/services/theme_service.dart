import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar y persistir el estado del tema de la aplicación.
class ThemeService {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  static const String _themeKey = 'preferred_theme_mode';
  
  /// Notificador del estado del tema actual.
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

  /// Inicializa el servicio cargando la preferencia guardada, si existe.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      themeModeNotifier.value = ThemeMode.values[themeIndex];
    }
  }

  /// Alterna entre temas Claro, Oscuro y Sistema y guarda la preferencia.
  Future<void> toggleTheme(BuildContext context) async {
    final current = themeModeNotifier.value;
    ThemeMode nextMode;
    
    if (current == ThemeMode.system) {
      final isPlatformDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      nextMode = isPlatformDark ? ThemeMode.light : ThemeMode.dark;
    } else if (current == ThemeMode.dark) {
      nextMode = ThemeMode.light;
    } else {
      nextMode = ThemeMode.dark;
    }
    
    themeModeNotifier.value = nextMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, nextMode.index);
  }
}
