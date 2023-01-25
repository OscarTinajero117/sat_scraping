import 'dart:developer';

import 'package:example/widgets/info_sat.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:sat_scraping/sat_scraping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAT Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Obtener QR'),
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
        }
      }
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
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Escanea el código QR\nque viene en la constancia\nde situación fiscal',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (loading)
            const Center(child: CircularProgressIndicator.adaptive()),
          if (!loading && infoFiscal.rfc.isNotEmpty)
            InfoSat(infoFiscal: infoFiscal),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loading ? null : _scanQR,
        tooltip: 'Escanear QR',
        child: const Icon(Icons.qr_code_scanner),
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
