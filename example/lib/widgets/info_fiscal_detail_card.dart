import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Tarjeta premium para mostrar una sección de información fiscal.
///
/// Presenta un header con gradiente institucional, un icono representativo
/// y filas de información con alternancia de colores para facilitar la
/// lectura.
///
/// ```dart
/// InfoFiscalDetailCard(
///   title: 'Datos de Identificación',
///   icon: Icons.badge_outlined,
///   rows: [
///     InfoRow(label: 'RFC:', value: 'XXXX000000XX0'),
///     InfoRow(label: 'Nombre:', value: 'Juan Pérez'),
///   ],
/// )
/// ```
class InfoFiscalDetailCard extends StatelessWidget {
  /// Título de la sección.
  final String title;

  /// Icono que acompaña al título.
  final IconData icon;

  /// Lista de filas de información a mostrar.
  final List<InfoRow> rows;

  const InfoFiscalDetailCard({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header con gradiente ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.guindaDark.withValues(alpha: 0.8),
                        AppColors.guinda.withValues(alpha: 0.6),
                      ]
                    : [
                        AppColors.guinda,
                        AppColors.guindaLight,
                      ],
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Filas de datos ──
          ...List.generate(rows.length, (index) {
            final row = rows[index];
            final isEven = index % 2 == 0;

            return Container(
              color: isEven
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : AppColors.guinda.withValues(alpha: 0.03)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      row.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Value
                  Expanded(
                    child: SelectableText(
                      row.value.isEmpty ? '—' : row.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: row.value.isEmpty
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                            : theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Modelo de datos para una fila de información fiscal.
class InfoRow {
  /// Etiqueta descriptiva del dato.
  final String label;

  /// Valor del dato.
  final String value;

  const InfoRow({required this.label, required this.value});
}
