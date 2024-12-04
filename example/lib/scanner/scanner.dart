import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatelessWidget {
  const Scanner({
    super.key,
    this.scanBoxWidth,
    this.scanBoxHeight,
    this.backgroundColor = Colors.black,
    this.opacity = 0.4,
  });

  final double? scanBoxWidth;
  final double? scanBoxHeight;
  final Color backgroundColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = scanBoxWidth ?? size.width;
    final height = scanBoxHeight ?? size.height;
    bool hasScanned = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            scanWindow: Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: width,
              height: height,
            ),
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (!hasScanned) {
                  hasScanned = true;
                  Navigator.of(context).pop(barcode.rawValue);
                }
              }
            },
          ),
          Container(
            color: backgroundColor.withOpacity(opacity), // Capa de opacidad
          ),
          Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ), // Borde del recuadro
                color: Colors.transparent,
              ),
            ),
          ),
          Center(
            child: ClipPath(
              clipper: _ScannerOverlay(
                width: width,
                height: height,
              ),
              child: Container(
                // Opacidad alrededor del recuadro
                color: backgroundColor.withOpacity(opacity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> scanQR({
    required BuildContext context,
    double scanBoxSize = 320.0,
    Color backgroundColor = Colors.black,
    double opacity = 0.4,
  }) async =>
      await Navigator.of(context).push<String?>(
        MaterialPageRoute(
          builder: (_) => Scanner(
            scanBoxHeight: scanBoxSize,
            scanBoxWidth: scanBoxSize,
            backgroundColor: backgroundColor,
            opacity: opacity,
          ),
        ),
      );

  static Future<String?> scanBarcode({
    required BuildContext context,
    double scanBoxWidth = 400.0,
    double scanBoxHeight = 150.0,
    Color backgroundColor = Colors.black,
    double opacity = 0.4,
  }) async =>
      await Navigator.of(context).push<String?>(
        MaterialPageRoute(
          builder: (_) => Scanner(
            scanBoxHeight: scanBoxHeight,
            scanBoxWidth: scanBoxWidth,
            backgroundColor: backgroundColor,
            opacity: opacity,
          ),
        ),
      );
}

class _ScannerOverlay extends CustomClipper<Path> {
  final double width;
  final double height;

  _ScannerOverlay({
    required this.width,
    required this.height,
  });

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // área opaca
      ..addRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: width,
          height: height,
        ),
      ); // área del recuadro
    return path
      ..fillType = PathFillType.evenOdd; // hace transparente el recuadro
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
