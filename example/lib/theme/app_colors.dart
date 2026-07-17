import 'package:flutter/material.dart';

/// Paleta de colores institucionales inspirada en el SAT.
///
/// Utiliza tonos guinda, dorado y grises profesionales que transmiten
/// confianza y seriedad fiscal.
abstract final class AppColors {
  // ── Primarios (guinda institucional) ──
  static const Color guinda = Color(0xFF6D1A36);
  static const Color guindaLight = Color(0xFFD94C74);
  static const Color guindaDark = Color(0xFF4E0E25);

  // ── Acento (dorado institucional) ──
  static const Color dorado = Color(0xFFBF9B30);
  static const Color doradoLight = Color(0xFFEBC656);
  static const Color doradoDark = Color(0xFF9A7B1F);

  // ── Superficies ──
  static const Color surfaceLight = Color(0xFFF8F5F0);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A3C);

  // ── Semánticos ──
  static const Color success = Color(0xFF2E7D4F);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFEF6C00);
  static const Color info = Color(0xFF1565C0);
}
