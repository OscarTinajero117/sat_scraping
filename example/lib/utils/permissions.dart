import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Utilidades para el manejo de permisos del sistema.
///
/// Proporciona métodos para solicitar permisos de manera segura,
/// incluyendo manejo de permisos denegados permanentemente con
/// opción de abrir la configuración del dispositivo.
abstract final class PermissionUtils {
  /// Verifica si el permiso [permission] está concedido.
  ///
  /// Si el permiso está denegado, lo solicita automáticamente.
  /// Si el permiso está denegado permanentemente, muestra un diálogo
  /// al usuario para abrir la configuración del dispositivo.
  ///
  /// Retorna `true` si el permiso fue concedido, `false` en caso contrario.
  ///
  /// ```dart
  /// final granted = await PermissionUtils.request(
  ///   Permission.camera,
  ///   context: context,
  /// );
  /// if (granted) {
  ///   // Usar la cámara
  /// }
  /// ```
  static Future<bool> request(
    Permission permission, {
    BuildContext? context,
  }) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied && context != null && context.mounted) {
      return await _showSettingsDialog(context, permission);
    }

    final result = await permission.request();
    return result.isGranted;
  }

  /// Muestra un diálogo informando que el permiso fue denegado
  /// permanentemente y ofrece abrir la configuración.
  static Future<bool> _showSettingsDialog(
    BuildContext context,
    Permission permission,
  ) async {
    final permissionName = _getPermissionName(permission);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: Text(
          'El permiso de $permissionName fue denegado permanentemente. '
          '¿Deseas abrir la configuración para habilitarlo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              await openAppSettings();
              if (ctx.mounted) Navigator.of(ctx).pop(false);
            },
            child: const Text('Abrir Configuración'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Retorna un nombre legible para el tipo de permiso.
  static String _getPermissionName(Permission permission) {
    if (permission == Permission.camera) return 'cámara';
    if (permission == Permission.storage) return 'almacenamiento';
    if (permission == Permission.photos) return 'fotos';
    return 'sistema';
  }
}
