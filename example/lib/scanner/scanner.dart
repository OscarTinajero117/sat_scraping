import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../theme/app_colors.dart';

/// Pantalla de escáner QR con diseño premium.
///
/// Presenta un visor de cámara con overlay oscuro, un recuadro de escaneo
/// con esquinas redondeadas decorativas, una línea de escaneo animada,
/// texto de instrucción y un botón de linterna (flash).
class Scanner extends StatefulWidget {
  const Scanner({
    super.key,
    this.scanBoxWidth,
    this.scanBoxHeight,
    this.backgroundColor = Colors.black,
    this.opacity = 0.5,
  });

  final double? scanBoxWidth;
  final double? scanBoxHeight;
  final Color backgroundColor;
  final double opacity;

  @override
  State<Scanner> createState() => _ScannerState();

  /// Abre el escáner QR y retorna el valor escaneado o `null`.
  static Future<String?> scanQR({
    required BuildContext context,
    double scanBoxSize = 280.0,
    Color backgroundColor = Colors.black,
    double opacity = 0.5,
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

  /// Abre el escáner de código de barras y retorna el valor escaneado.
  static Future<String?> scanBarcode({
    required BuildContext context,
    double scanBoxWidth = 400.0,
    double scanBoxHeight = 150.0,
    Color backgroundColor = Colors.black,
    double opacity = 0.5,
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

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scanLineAnimation;
  final MobileScannerController _cameraController = MobileScannerController();
  bool _hasScanned = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    _cameraController.toggleTorch();
    setState(() => _flashOn = !_flashOn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boxWidth = widget.scanBoxWidth ?? size.width * 0.75;
    final boxHeight = widget.scanBoxHeight ?? size.width * 0.75;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ── Botón de flash ──
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: _flashOn ? AppColors.dorado : Colors.white,
            ),
            tooltip: _flashOn ? 'Apagar flash' : 'Encender flash',
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Cámara ──
          MobileScanner(
            controller: _cameraController,
            scanWindow: Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: boxWidth,
              height: boxHeight,
            ),
            onDetect: (capture) {
              if (_hasScanned) return;
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _hasScanned = true;
                  // Haptic feedback al detectar
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop(barcode.rawValue);
                  return;
                }
              }
            },
          ),

          // ── Overlay oscuro con recorte transparente ──
          ClipPath(
            clipper: _ScannerOverlay(width: boxWidth, height: boxHeight),
            child: Container(
              color: widget.backgroundColor.withValues(alpha: widget.opacity),
            ),
          ),

          // ── Esquinas decorativas ──
          _ScannerCorners(width: boxWidth, height: boxHeight),

          // ── Línea de escaneo animada ──
          AnimatedBuilder(
            animation: _scanLineAnimation,
            builder: (context, _) {
              final top = (size.height / 2) -
                  (boxHeight / 2) +
                  (_scanLineAnimation.value * boxHeight);
              return Positioned(
                top: top,
                child: Container(
                  width: boxWidth - 16,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.dorado.withValues(alpha: 0.8),
                        AppColors.dorado,
                        AppColors.dorado.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dorado.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Texto de instrucción ──
          Positioned(
            bottom: size.height * 0.15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Coloca el código QR dentro del recuadro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clipper que crea una ventana transparente en el centro del overlay.
class _ScannerOverlay extends CustomClipper<Path> {
  final double width;
  final double height;

  _ScannerOverlay({required this.width, required this.height});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: width,
            height: height,
          ),
          const Radius.circular(16),
        ),
      );
    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Widget que dibuja esquinas decorativas en las 4 esquinas del recuadro
/// de escaneo.
class _ScannerCorners extends StatelessWidget {
  final double width;
  final double height;

  const _ScannerCorners({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CornersPainter(),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.dorado
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    const radius = 16.0;

    // Esquina superior izquierda
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, radius)
        ..arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius))
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Esquina superior derecha
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius))
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Esquina inferior izquierda
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - radius)
        ..arcToPoint(Offset(radius, size.height),
            radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Esquina inferior derecha
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(Offset(size.width, size.height - radius),
            radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
