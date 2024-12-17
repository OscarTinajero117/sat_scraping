import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sat_scraping/sat_scraping.dart';
import 'package:share_plus/share_plus.dart';

import 'scanner/scanner.dart';
import 'widgets/info_sat.dart';
import 'widgets/info_sat_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escáner de constancia de situación fiscal',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Información Fiscal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  bool error = false;
  String errorMessage = '';

  InfoFiscal infoFiscal = InfoFiscal.getDefault();

  void _shared() {
    setState(() {
      loading = true;
    });
    String regimenesComplete = '';
    for (final row in infoFiscal.caracteristicasFiscales) {
      regimenesComplete +=
          'Régimen Fiscal: \t\t${row.codigoRegimen} - ${row.regimenFiscal}\n\n';
    }
    Share.share(''
        'RFC: \t\t ${infoFiscal.rfc}\n\n'
        'ID CIF: \t\t ${infoFiscal.idCif}\n\n'
        'Razón Social: \t\t${infoFiscal.razonSocial}\n\n'
        'Código Postal: \t\t${infoFiscal.cp}\n\n'
        '$regimenesComplete'
        '');
    setState(() {
      loading = false;
    });
  }

  Future<void> _scanQR(BuildContext ctx) async {
    setState(() {
      loading = true;
    });
    if (await getPermission(Permission.camera) && ctx.mounted) {
      final cameraResult = await Scanner.scanQR(context: ctx);

      if (cameraResult != null) {
        try {
          infoFiscal = await SatScraping.getInfoFiscal(cameraResult);
        } catch (e) {
          log('Error: $e');
          error = true;
          errorMessage = e.toString();
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  void _writeData() async {
    setState(() {
      loading = true;
    });
    final tmpMap = await showDialog(
      context: context,
      builder: (BuildContext context) => const InfoSatDialog(),
    );
    if (tmpMap == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    try {
      infoFiscal = await SatScraping.getInfoFiscalManual(
        rfc: tmpMap['rfc'] as String,
        idCif: tmpMap['idcif'] as String,
      );
    } catch (e) {
      log('Error: $e');
      error = true;
      errorMessage = e.toString();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              error = false;
              setState(() {
                infoFiscal = InfoFiscal.getDefault();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          if (infoFiscal.rfc.isEmpty)
            Center(
              child: Text(
                'Escanea el código QR'
                '\no ingresa los datos manualmente'
                '\nque viene en la constancia'
                '\nde situación fiscal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          if (error)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('Error al obtener la información\n$errorMessage'),
              ),
            ),
          if (loading)
            const Center(child: CircularProgressIndicator.adaptive()),
          if (!loading && infoFiscal.rfc.isNotEmpty)
            InfoSat(infoFiscal: infoFiscal),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (infoFiscal.rfc.isEmpty)
            FloatingActionButton(
              heroTag: 'write',
              onPressed: loading ? null : _writeData,
              tooltip: 'Escribir Datos',
              child: const Icon(Icons.edit),
            ),
          const SizedBox(height: 10),
          if (infoFiscal.rfc.isEmpty)
            FloatingActionButton(
              heroTag: 'scan',
              onPressed: loading ? null : () async => await _scanQR(context),
              tooltip: 'Escanear QR',
              child: const Icon(Icons.qr_code_scanner),
            ),
          const SizedBox(height: 10),
          if (infoFiscal.rfc.isNotEmpty)
            FloatingActionButton(
              heroTag: 'shared',
              onPressed: loading ? null : _shared,
              tooltip: 'Compartir Breve Información',
              child: const Icon(Icons.share),
            ),
        ],
      ),
    );
  }
}

///Función para verificar el permiso deseado, si no lo tiene, lo solicita y
///regresa ese resultado
///```
/// final PermissionStatus status = await permission.status;
/// if (status.isDenied) {
///   final result = await permission.request().isGranted;
///   return result;
/// }
/// return true;
///```
Future<bool> getPermission(Permission permission) async {
  final PermissionStatus status = await permission.status;
  if (status.isDenied) {
    final result = await permission.request().isGranted;
    return result;
  }
  return true;
}
