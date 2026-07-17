import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Diálogo para ingresar manualmente los datos del contribuyente.
///
/// Solicita RFC e ID CIF con validación en tiempo real:
/// - **RFC**: 12-13 caracteres alfanuméricos, auto-mayúsculas
/// - **ID CIF**: Solo numérico
///
/// Retorna un `Map<String, String>` con las claves `'rfc'` e `'idcif'`,
/// o `null` si el usuario cancela.
class InfoSatDialog extends StatefulWidget {
  const InfoSatDialog({super.key});

  @override
  State<InfoSatDialog> createState() => _InfoSatDialogState();
}

class _InfoSatDialogState extends State<InfoSatDialog> {
  final _formKey = GlobalKey<FormState>();
  final _rfcController = TextEditingController();
  final _idcifController = TextEditingController();
  bool _showHelp = false;

  @override
  void dispose() {
    _rfcController.dispose();
    _idcifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit_note, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(child: Text('Ingresa los datos')),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Ayuda contextual ──
              GestureDetector(
                onTap: () => setState(() => _showHelp = !_showHelp),
                child: Row(
                  children: [
                    Icon(
                      _showHelp ? Icons.help : Icons.help_outline,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '¿Dónde encuentro estos datos?',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),

              if (_showHelp) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'El RFC y el ID CIF se encuentran en tu Constancia de '
                    'Situación Fiscal, ambos en el costado derecho del código QR. '
                    'El RFC está en la parte superior y el ID CIF está justo '
                    'debajo de la razón social.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ── Campo RFC ──
              TextFormField(
                controller: _rfcController,
                decoration: const InputDecoration(
                  labelText: 'RFC',
                  hintText: 'Ej: XXXX000000XX0',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9&Ññ]')),
                  LengthLimitingTextInputFormatter(13),
                  UpperCaseTextFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu RFC';
                  }
                  if (value.length < 12) {
                    return 'El RFC debe tener 12 o 13 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Campo ID CIF ──
              TextFormField(
                controller: _idcifController,
                decoration: const InputDecoration(
                  labelText: 'ID CIF',
                  hintText: 'Ej: 12345678',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu ID CIF';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.search, size: 18),
          label: const Text('Consultar'),
          style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.primary),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState == null) return;
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'rfc': _rfcController.text.toUpperCase(),
        'idcif': _idcifController.text,
      });
    }
  }
}

/// Formateador de texto que convierte todo a mayúsculas automáticamente.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
