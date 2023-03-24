import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:sat_scraping/sat_scraping.dart';

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
      title: 'Información Fiscal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

  void _scanQR() async {
    setState(() {
      loading = true;
    });
    if (await getPermission(Permission.camera)) {
      final cameraResult = await scanner.scan();

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
      builder: (BuildContext context) {
        return const InfoSatDialog();
      },
    );
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
        title: Text(widget.title),
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
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Escanea el código QR'
                '\no ingresa los datos manualmente'
                '\nque viene en la constancia'
                '\nde situación fiscal',
                textAlign: TextAlign.center,
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
          FloatingActionButton(
            heroTag: 'write',
            onPressed: loading ? null : _writeData,
            tooltip: 'Escribir Datos',
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: loading ? null : _scanQR,
            tooltip: 'Escanear QR',
            child: const Icon(Icons.qr_code_scanner),
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
