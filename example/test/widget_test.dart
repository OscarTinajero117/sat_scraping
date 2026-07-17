import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:info_sat/main.dart';
import 'package:info_sat/theme/app_theme.dart';
import 'package:info_sat/widgets/empty_state.dart';
import 'package:info_sat/widgets/error_banner.dart';
import 'package:info_sat/widgets/info_fiscal_detail_card.dart';
import 'package:info_sat/widgets/info_sat.dart';
import 'package:info_sat/widgets/info_sat_dialog.dart';
import 'package:info_sat/widgets/table_info_sat.dart';
import 'package:sat_scraping/sat_scraping.dart';

void main() {
  // ╔════════════════════════════════════════════════════════════════╗
  // ║  MyApp — Tests de Widget Raíz                                 ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('MyApp', () {
    testWidgets('Se renderiza sin errores', (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Aplica MaterialApp con tema correcto', (tester) async {
      await tester.pumpWidget(const MyApp());
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.themeMode, ThemeMode.system);
    });

    testWidgets('El título de la app es correcto', (tester) async {
      await tester.pumpWidget(const MyApp());
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Escáner de constancia de situación fiscal');
    });

    testWidgets('El tema usa colores del sistema de diseño', (tester) async {
      await tester.pumpWidget(const MyApp());
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme!.useMaterial3, isTrue);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  AppTheme — Tests del Sistema de Diseño                       ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('AppTheme', () {
    test('El tema claro tiene brightness light', () {
      expect(AppTheme.light.brightness, Brightness.light);
    });

    test('El tema oscuro tiene brightness dark', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('Ambos temas usan Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('Los temas tienen colorScheme definido', () {
      expect(AppTheme.light.colorScheme, isNotNull);
      expect(AppTheme.dark.colorScheme, isNotNull);
    });

    test('Las constantes de diseño tienen valores positivos', () {
      expect(AppTheme.cardRadius, greaterThan(0));
      expect(AppTheme.buttonRadius, greaterThan(0));
      expect(AppTheme.cardPadding, greaterThan(0));
      expect(AppTheme.sectionSpacing, greaterThan(0));
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  MyHomePage — Tests de Pantalla Principal                     ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('MyHomePage', () {
    testWidgets('Se renderiza sin errores', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Test Title')),
      );
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('Muestra el título correctamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Información Fiscal')),
      );
      expect(find.text('Información Fiscal'), findsOneWidget);
    });

    testWidgets('Muestra estado vacío al inicio', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Test')),
      );
      await tester.pumpAndSettle();
      // Debe mostrar el widget EmptyState
      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('El estado vacío tiene los botones de acción', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Test')),
      );
      await tester.pumpAndSettle();
      // Debe tener FABs para escanear y escribir
      expect(find.byType(FloatingActionButton), findsWidgets);
    });

    testWidgets('Muestra los FABs con labels extendidos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Test')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Escanear'), findsOneWidget);
      expect(find.text('Manual'), findsOneWidget);
    });

    testWidgets('El botón refresh no aparece sin datos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Test')),
      );
      await tester.pumpAndSettle();
      // No debe haber botón de compartir sin datos
      expect(find.byIcon(Icons.share_outlined), findsNothing);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  InfoSat — Tests del Widget de Información Fiscal             ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('InfoSat', () {
    testWidgets('Se renderiza sin errores con datos vacíos', (tester) async {
      final info = InfoFiscal.getDefault();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );
      expect(find.byType(InfoSat), findsOneWidget);
    });

    testWidgets('Muestra las tres secciones de tarjetas', (tester) async {
      final info = _createSampleInfoFiscal(personaFisica: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.byType(InfoFiscalDetailCard), findsNWidgets(3));
    });

    testWidgets('Muestra label "Nombre:" para persona física', (tester) async {
      final info = _createSampleInfoFiscal(personaFisica: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('Nombre:'), findsOneWidget);
    });

    testWidgets('Muestra label "Denominación" para persona moral', (
      tester,
    ) async {
      final info = _createSampleInfoFiscal(personaFisica: false);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('Denominación o Razón Social:'), findsOneWidget);
    });

    testWidgets('Muestra el RFC correctamente', (tester) async {
      final info = _createSampleInfoFiscal(personaFisica: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('XAXX010101000'), findsOneWidget);
    });

    testWidgets('Muestra CURP para persona física', (tester) async {
      final info = _createSampleInfoFiscal(personaFisica: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('CURP:'), findsOneWidget);
    });

    testWidgets('Muestra Régimen de capital para persona moral', (
      tester,
    ) async {
      final info = _createSampleInfoFiscal(personaFisica: false);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('Régimen de capital:'), findsOneWidget);
    });

    testWidgets('Muestra múltiples regímenes fiscales', (tester) async {
      final info = _createSampleInfoFiscal(
        personaFisica: true,
        multipleRegimenes: true,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      // Dos regímenes = dos veces "Régimen:"
      expect(find.text('Régimen:'), findsNWidgets(2));
    });

    testWidgets('Secciones muestran títulos correctos', (tester) async {
      final info = _createSampleInfoFiscal(personaFisica: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: InfoSat(infoFiscal: info)),
          ),
        ),
      );

      expect(find.text('Datos de Identificación'), findsOneWidget);
      expect(find.text('Domicilio Fiscal (vigente)'), findsOneWidget);
      expect(find.text('Características Fiscales (vigente)'), findsOneWidget);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  InfoFiscalDetailCard — Tests del Widget de Tarjeta           ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('InfoFiscalDetailCard', () {
    testWidgets('Se renderiza con título e icono', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoFiscalDetailCard(
              title: 'Test Section',
              icon: Icons.info,
              rows: [InfoRow(label: 'Key:', value: 'Value')],
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('Muestra todas las filas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: InfoFiscalDetailCard(
                title: 'Test',
                icon: Icons.info,
                rows: [
                  InfoRow(label: 'RFC:', value: 'ABC123'),
                  InfoRow(label: 'Nombre:', value: 'Juan'),
                  InfoRow(label: 'CP:', value: '12345'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('ABC123'), findsOneWidget);
      expect(find.text('Juan'), findsOneWidget);
      expect(find.text('12345'), findsOneWidget);
    });

    testWidgets('Muestra "—" para valores vacíos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoFiscalDetailCard(
              title: 'Test',
              icon: Icons.info,
              rows: [InfoRow(label: 'Vacío:', value: '')],
            ),
          ),
        ),
      );

      expect(find.text('—'), findsOneWidget);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  TableInfoSat — Tests del Widget de Tabla                     ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('TableInfoSat', () {
    testWidgets('Se renderiza con título', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TableInfoSat(
              tableTitle: 'Título de Prueba',
              icon: Icons.info,
              children: [],
            ),
          ),
        ),
      );

      expect(find.text('Título de Prueba'), findsOneWidget);
    });

    testWidgets('Muestra el icono proporcionado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TableInfoSat(
              tableTitle: 'Test',
              icon: Icons.badge,
              children: [],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.badge), findsOneWidget);
    });

    testWidgets('Se renderiza como Card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TableInfoSat(tableTitle: 'Test', children: []),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  EmptyState — Tests del Estado Vacío                          ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('EmptyState', () {
    testWidgets('Se renderiza sin errores', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyState())),
      );

      expect(find.byType(EmptyState), findsOneWidget);
    });

    testWidgets('Muestra título de consulta', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyState())),
      );

      expect(find.text('Consulta tu situación fiscal'), findsOneWidget);
    });

    testWidgets('Muestra botón de escanear QR', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EmptyState(onScanQR: () {})),
        ),
      );

      expect(find.text('Escanear código QR'), findsOneWidget);
    });

    testWidgets('Muestra botón de ingreso manual', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EmptyState(onManualInput: () {})),
        ),
      );

      expect(find.text('Ingresar datos manualmente'), findsOneWidget);
    });

    testWidgets('No muestra historial cuando count es 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyState(historyCount: 0))),
      );

      expect(find.byIcon(Icons.history), findsNothing);
    });

    testWidgets('Muestra historial cuando count > 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(historyCount: 5, onViewHistory: () {}),
          ),
        ),
      );

      expect(find.text('Ver historial (5)'), findsOneWidget);
    });

    testWidgets('Los callbacks se invocan al presionar', (tester) async {
      bool scanPressed = false;
      bool manualPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              onScanQR: () => scanPressed = true,
              onManualInput: () => manualPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Escanear código QR'));
      expect(scanPressed, isTrue);

      await tester.tap(find.text('Ingresar datos manualmente'));
      expect(manualPressed, isTrue);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  ErrorBanner — Tests del Banner de Error                      ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('ErrorBanner', () {
    testWidgets('Se renderiza con mensaje de error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorBanner(message: 'Algo salió mal')),
        ),
      );

      expect(find.text('Algo salió mal'), findsOneWidget);
    });

    testWidgets('Muestra título de error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorBanner(message: 'Test')),
        ),
      );

      expect(find.text('Error al obtener la información'), findsOneWidget);
    });

    testWidgets('Muestra icono de error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorBanner(message: 'Test')),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Muestra botón de reintentar cuando se proporciona callback', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(message: 'Test', onRetry: () {}),
          ),
        ),
      );

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('No muestra reintentar sin callback', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorBanner(message: 'Test')),
        ),
      );

      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('El botón de cerrar funciona', (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(
              message: 'Test',
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(dismissed, isTrue);
    });

    testWidgets('El botón de reintentar funciona', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorBanner(message: 'Test', onRetry: () => retried = true),
          ),
        ),
      );

      await tester.tap(find.text('Reintentar'));
      expect(retried, isTrue);
    });
  });

  // ╔════════════════════════════════════════════════════════════════╗
  // ║  InfoSatDialog — Tests del Diálogo                            ║
  // ╚════════════════════════════════════════════════════════════════╝
  group('InfoSatDialog', () {
    testWidgets('Se renderiza sin errores', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      expect(find.byType(InfoSatDialog), findsOneWidget);
    });

    testWidgets('Muestra los campos RFC e ID CIF', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      expect(find.text('RFC'), findsOneWidget);
      expect(find.text('ID CIF'), findsOneWidget);
    });

    testWidgets('Muestra botones de cancelar y consultar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Consultar'), findsOneWidget);
    });

    testWidgets('Muestra enlace de ayuda', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      expect(find.text('¿Dónde encuentro estos datos?'), findsOneWidget);
    });

    testWidgets('Valida campos vacíos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      // Presionar Consultar sin llenar campos
      await tester.tap(find.text('Consultar'));
      await tester.pumpAndSettle();

      expect(find.text('Ingresa tu RFC'), findsOneWidget);
      expect(find.text('Ingresa tu ID CIF'), findsOneWidget);
    });

    testWidgets('Valida longitud mínima del RFC', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      // Ingresar RFC corto
      await tester.enterText(find.byType(TextFormField).first, 'ABC');
      await tester.tap(find.text('Consultar'));
      await tester.pumpAndSettle();

      expect(find.text('El RFC debe tener 12 o 13 caracteres'), findsOneWidget);
    });

    testWidgets('Convierte RFC a mayúsculas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      await tester.enterText(find.byType(TextFormField).first, 'xaxx010101000');
      await tester.pump();

      // El texto debe haberse convertido a mayúsculas
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect((textField.controller)?.text, 'XAXX010101000');
    });

    testWidgets('Tiene hints de ejemplo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InfoSatDialog())),
      );

      expect(find.text('Ej: XXXX000000XX0'), findsOneWidget);
      expect(find.text('Ej: 12345678'), findsOneWidget);
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════
//  Helpers para crear datos de prueba
// ═══════════════════════════════════════════════════════════════════════

/// Crea una instancia de [InfoFiscal] con datos de ejemplo para tests.
InfoFiscal _createSampleInfoFiscal({
  required bool personaFisica,
  bool multipleRegimenes = false,
}) {
  final regimenes = [
    CaracteristicasFiscales(
      regimenFiscal: 'Régimen Simplificado de Confianza',
      codigoRegimen: 626,
      fechaAltaRegimen: '01/01/2022',
    ),
    if (multipleRegimenes)
      CaracteristicasFiscales(
        regimenFiscal: 'Sueldos y Salarios',
        codigoRegimen: 605,
        fechaAltaRegimen: '15/03/2020',
      ),
  ];

  return InfoFiscal(
    rfc: personaFisica ? 'XAXX010101000' : 'XXX010101000',
    idCif: '12345678',
    curpRegimen: personaFisica ? 'XAXX010101HDFRNN09' : 'Sociedad Anónima',
    razonSocial: personaFisica ? 'JUAN PÉREZ LÓPEZ' : 'EMPRESA SA DE CV',
    fechaNacimientoConstitucion: '01/01/2000',
    fechaInicioOperacions: '15/06/2020',
    situacionContribuyente: 'ACTIVO',
    fechaUltimoCambio: '01/01/2024',
    entidadFederativa: 'CIUDAD DE MÉXICO',
    municipioDelegacion: 'BENITO JUÁREZ',
    colonia: 'DEL VALLE CENTRO',
    tipoVialidad: 'CALLE',
    nombreVialidad: 'INSURGENTES SUR',
    numeroExterior: '100',
    numeroInterior: 'A',
    cp: '03100',
    correoElectronico: 'ejemplo@correo.com',
    al: 'SAT-01',
    caracteristicasFiscales: regimenes,
  );
}
