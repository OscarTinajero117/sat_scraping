import 'package:flutter/material.dart';



/// Widget de estado vacío que se muestra cuando no hay información fiscal
/// cargada.
///
/// Presenta un icono grande, un título, un subtítulo con instrucciones
/// y botones de acción para escanear QR o ingresar datos manualmente.
class EmptyState extends StatelessWidget {
  /// Callback al presionar el botón de escanear QR.
  final VoidCallback? onScanQR;

  /// Callback al presionar el botón de ingresar datos manualmente.
  final VoidCallback? onManualInput;

  /// Callback al presionar el botón de ver historial.
  final VoidCallback? onViewHistory;

  /// Cantidad de registros en el historial.
  final int historyCount;

  const EmptyState({
    super.key,
    this.onScanQR,
    this.onManualInput,
    this.onViewHistory,
    this.historyCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icono principal ──
            Container(
              width: size.width * 0.35,
              height: size.width * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Icon(
                Icons.account_balance_outlined,
                size: size.width * 0.15,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 32),

            // ── Título ──
            Text(
              'Consulta tu situación fiscal',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // ── Subtítulo ──
            Text(
              'Escanea el código QR de tu constancia\nde situación fiscal o ingresa tus datos\nmanualmente para obtener tu información.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // ── Botón escanear QR ──
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onScanQR,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear código QR'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Botón ingreso manual ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onManualInput,
                icon: const Icon(Icons.edit_note),
                label: const Text('Ingresar datos manualmente'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ── Botón historial (solo si hay registros) ──
            if (historyCount > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onViewHistory,
                  icon: const Icon(Icons.history),
                  label: Text('Ver historial ($historyCount)'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    textStyle: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
