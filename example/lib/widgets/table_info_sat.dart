import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Contenedor de tabla para información del SAT con diseño premium.
///
/// Presenta un header con gradiente institucional y un cuerpo con
/// filas de datos organizadas en una [Table]. Utiliza bordes redondeados
/// y sombras sutiles en lugar de bordes duros.
class TableInfoSat extends StatelessWidget {
  /// Título de la sección.
  final String tableTitle;

  /// Icono que acompaña al título.
  final IconData icon;

  /// Filas de la tabla.
  final List<TableRow> children;

  const TableInfoSat({
    super.key,
    required this.tableTitle,
    this.icon = Icons.info_outline,
    required this.children,
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
        children: [
          // ── Header con gradiente ──
          Container(
            width: double.infinity,
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
                    tableTitle,
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

          // ── Cuerpo de la tabla ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
