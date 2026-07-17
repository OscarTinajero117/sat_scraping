import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sat_scraping/sat_scraping.dart';
import 'package:share_plus/share_plus.dart';

import 'scanner/scanner.dart';
import 'services/history_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';
import 'utils/permissions.dart';
import 'widgets/empty_state.dart';
import 'widgets/error_banner.dart';
import 'widgets/history_list.dart';
import 'widgets/info_sat.dart';
import 'widgets/info_sat_dialog.dart';

/// Punto de entrada de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.instance.init();
  runApp(const MyApp());
}

/// Widget raíz de la aplicación Info SAT.
///
/// Configura los temas claro y oscuro con [AppTheme] y establece
/// [ThemeMode.system] para adaptarse automáticamente a las preferencias
/// del usuario.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Escáner de constancia de situación fiscal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const MyHomePage(title: 'Información Fiscal'),
        );
      },
    );
  }
}

/// Pantalla principal de la aplicación.
///
/// Maneja tres estados principales:
/// - **Vacío**: Sin datos cargados, muestra instrucciones y acciones
/// - **Cargando**: Consultando la información al SAT
/// - **Con datos**: Muestra la información fiscal en tarjetas premium
///
/// También gestiona el historial de consultas previas y el compartir
/// información.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// Título mostrado en el AppBar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  bool _error = false;
  String _errorMessage = '';
  int _historyCount = 0;

  InfoFiscal _infoFiscal = InfoFiscal.getDefault();

  final _historyService = HistoryService.instance;

  @override
  void initState() {
    super.initState();
    _loadHistoryCount();
  }

  /// Carga el número de registros en el historial para mostrar en el
  /// estado vacío.
  Future<void> _loadHistoryCount() async {
    final count = await _historyService.count;
    if (mounted) {
      setState(() => _historyCount = count);
    }
  }

  /// Comparte un resumen breve de la información fiscal.
  void _shared() {
    String regimenesComplete = '';
    for (final row in _infoFiscal.caracteristicasFiscales) {
      regimenesComplete +=
          'Régimen Fiscal: \t\t${row.codigoRegimen} - ${row.regimenFiscal}\n\n';
    }
    SharePlus.instance.share(
      ShareParams(
        text: 'RFC: \t\t ${_infoFiscal.rfc}\n\n'
            'ID CIF: \t\t ${_infoFiscal.idCif}\n\n'
            'Razón Social: \t\t${_infoFiscal.razonSocial}\n\n'
            'Código Postal: \t\t${_infoFiscal.cp}\n\n'
            '$regimenesComplete',
      ),
    );
  }

  /// Abre el escáner QR y consulta la información fiscal.
  Future<void> _scanQR(BuildContext ctx) async {
    setState(() {
      _loading = true;
      _error = false;
    });

    if (await PermissionUtils.request(Permission.camera, context: ctx) &&
        ctx.mounted) {
      final cameraResult = await Scanner.scanQR(context: ctx);

      if (cameraResult != null) {
        try {
          _infoFiscal = await SatScraping.getInfoFiscal(cameraResult);
          await _historyService.save(_infoFiscal);
          await _loadHistoryCount();
        } catch (e) {
          log('Error: $e');
          _error = true;
          _errorMessage = e.toString();
        }
      }
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  /// Abre el diálogo de ingreso manual y consulta la información fiscal.
  Future<void> _writeData() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    final tmpMap = await showDialog(
      context: context,
      builder: (BuildContext context) => const InfoSatDialog(),
    );

    if (tmpMap == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      _infoFiscal = await SatScraping.getInfoFiscalManual(
        rfc: tmpMap['rfc'] as String,
        idCif: tmpMap['idcif'] as String,
      );
      await _historyService.save(_infoFiscal);
      await _loadHistoryCount();
    } catch (e) {
      log('Error: $e');
      _error = true;
      _errorMessage = e.toString();
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  /// Abre la pantalla de historial.
  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryList(
          onSelect: (info) {
            setState(() {
              _infoFiscal = info;
              _error = false;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  /// Limpia el estado actual y vuelve al estado vacío.
  void _reset() {
    setState(() {
      _error = false;
      _infoFiscal = InfoFiscal.getDefault();
    });
    _loadHistoryCount();
  }

  bool get _hasData => _infoFiscal.rfc.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // ── Botón de tema ──
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService.instance.themeModeNotifier,
            builder: (context, mode, _) {
              IconData icon;
              if (mode == ThemeMode.light) {
                icon = Icons.dark_mode_outlined;
              } else if (mode == ThemeMode.dark) {
                icon = Icons.light_mode_outlined;
              } else {
                icon = Icons.brightness_auto_outlined;
              }
              return IconButton(
                onPressed: () => ThemeService.instance.toggleTheme(context),
                icon: Icon(icon),
                tooltip: 'Cambiar tema',
              );
            },
          ),
          // ── Botón de historial ──
          if (_historyCount > 0)
            IconButton(
              onPressed: _openHistory,
              icon: const Icon(Icons.history),
              tooltip: 'Historial',
            ),
          // ── Botón de compartir (solo con datos) ──
          if (_hasData)
            IconButton(
              onPressed: _loading ? null : _shared,
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Compartir información',
            ),
          // ── Botón de limpiar (solo con datos) ──
          if (_hasData)
            IconButton(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              tooltip: 'Nueva consulta',
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _buildBody(),
      ),

      // ── FABs (solo en estado vacío) ──
      floatingActionButton: _hasData
          ? null
          : _loading
              ? null
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'write',
                      onPressed: _writeData,
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Manual'),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.extended(
                      heroTag: 'scan',
                      onPressed: () async => await _scanQR(context),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear'),
                    ),
                  ],
                ),
    );
  }

  /// Construye el cuerpo de la pantalla según el estado actual.
  Widget _buildBody() {
    // Estado de carga
    if (_loading) {
      return const Center(
        key: ValueKey('loading'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 20),
            Text(
              'Consultando información fiscal...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Estado con datos
    if (_hasData) {
      return ListView(
        key: const ValueKey('data'),
        padding: const EdgeInsets.all(16),
        children: [
          if (_error)
            ErrorBanner(
              message: _errorMessage,
              onDismiss: () => setState(() => _error = false),
            ),
          InfoSat(infoFiscal: _infoFiscal),
          const SizedBox(height: 80), // Espacio para el FAB
        ],
      );
    }

    // Estado vacío (con posible error)
    return Column(
      key: const ValueKey('empty'),
      children: [
        if (_error)
          ErrorBanner(
            message: _errorMessage,
            onRetry: () => _scanQR(context),
            onDismiss: () => setState(() => _error = false),
          ),
        Expanded(
          child: EmptyState(
            onScanQR: () => _scanQR(context),
            onManualInput: _writeData,
            onViewHistory: _historyCount > 0 ? _openHistory : null,
            historyCount: _historyCount,
          ),
        ),
      ],
    );
  }
}
