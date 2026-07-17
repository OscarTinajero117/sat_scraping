import 'dart:convert';

import 'package:sat_scraping/sat_scraping.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de historial de consultas fiscales con almacenamiento local.
///
/// Permite guardar, recuperar y eliminar consultas previas de información
/// fiscal usando [SharedPreferences]. Las consultas se almacenan como
/// JSON serializado y se ordenan por fecha de consulta (más reciente primero).
///
/// Límite máximo de historial: [maxHistorySize] registros.
class HistoryService {
  HistoryService._();

  static final HistoryService _instance = HistoryService._();

  /// Instancia singleton del servicio de historial.
  static HistoryService get instance => _instance;

  static const String _historyKey = 'fiscal_history';

  /// Número máximo de registros en el historial.
  static const int maxHistorySize = 50;

  /// Guarda una consulta de [InfoFiscal] en el historial local.
  ///
  /// Si ya existe un registro con el mismo RFC, lo actualiza en lugar de
  /// duplicarlo. Si el historial supera [maxHistorySize], elimina el más
  /// antiguo.
  Future<void> save(InfoFiscal info) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getAll();

    // Remover duplicado si existe (por RFC)
    history.removeWhere((item) => item['rfc'] == info.rfc);

    // Agregar al inicio con timestamp
    history.insert(0, {
      ...info.toJson,
      '_saved_at': DateTime.now().toIso8601String(),
    });

    // Limitar tamaño
    if (history.length > maxHistorySize) {
      history.removeRange(maxHistorySize, history.length);
    }

    await prefs.setString(_historyKey, jsonEncode(history));
  }

  /// Obtiene todas las consultas guardadas en el historial.
  ///
  /// Retorna una lista de mapas JSON ordenada por fecha de guardado
  /// (más reciente primero). Retorna lista vacía si no hay historial.
  Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Obtiene todas las consultas como objetos [InfoFiscal].
  Future<List<InfoFiscal>> getAllAsInfoFiscal() async {
    final history = await getAll();
    return history.map((json) {
      // Remover metadata interna antes de parsear
      final cleanJson = Map<String, dynamic>.from(json)..remove('_saved_at');
      return InfoFiscal.fromJson(cleanJson);
    }).toList();
  }

  /// Obtiene la fecha de guardado de un registro del historial.
  ///
  /// Retorna `null` si el registro no tiene fecha.
  DateTime? getSavedAt(Map<String, dynamic> historyItem) {
    final savedAt = historyItem['_saved_at'] as String?;
    if (savedAt == null) return null;
    return DateTime.tryParse(savedAt);
  }

  /// Elimina un registro específico del historial por su RFC.
  Future<void> removeByRfc(String rfc) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getAll();
    history.removeWhere((item) => item['rfc'] == rfc);
    await prefs.setString(_historyKey, jsonEncode(history));
  }

  /// Elimina todo el historial de consultas.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Retorna el número de registros en el historial.
  Future<int> get count async {
    final history = await getAll();
    return history.length;
  }
}
