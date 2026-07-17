import 'package:flutter/material.dart';
import 'package:sat_scraping/sat_scraping.dart';

import '../services/history_service.dart';
import '../theme/app_colors.dart';

/// Widget que muestra el historial de consultas fiscales.
///
/// Presenta una lista de registros previos con la información básica
/// (RFC, razón social, fecha de consulta) y permite seleccionar uno
/// para visualizar los detalles completos, o eliminarlo del historial.
class HistoryList extends StatefulWidget {
  /// Callback al seleccionar un registro del historial.
  final ValueChanged<InfoFiscal> onSelect;

  const HistoryList({super.key, required this.onSelect});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final _historyService = HistoryService.instance;
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _historyService.getAll();
    if (mounted) {
      setState(() {
        _history = history;
        _loading = false;
      });
    }
  }

  Future<void> _deleteItem(String rfc) async {
    await _historyService.removeByRfc(rfc);
    await _loadHistory();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado del historial')),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpiar historial'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todo el historial de consultas? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _historyService.clearAll();
      await _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Limpiar historial',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay consultas previas',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Las consultas que realices se guardarán aquí',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final rfc = item['rfc'] as String? ?? '';
                    final razonSocial =
                        item['razon_social'] as String? ?? 'Sin nombre';
                    final savedAt = _historyService.getSavedAt(item);
                    final isPersonaFisica = rfc.length == 13;

                    return Card(
                      elevation: 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(
                            isPersonaFisica
                                ? Icons.person_outline
                                : Icons.business_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          razonSocial,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'RFC: $rfc',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontFamily: 'monospace',
                              ),
                            ),
                            if (savedAt != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(savedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteItem(rfc),
                          icon: Icon(
                            Icons.delete_outline,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            size: 20,
                          ),
                          tooltip: 'Eliminar',
                        ),
                        onTap: () {
                          final cleanJson = Map<String, dynamic>.from(item)
                            ..remove('_saved_at');
                          final info = InfoFiscal.fromJson(cleanJson);
                          widget.onSelect(info);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Hace un momento';
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
