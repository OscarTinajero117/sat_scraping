import 'package:flutter_test/flutter_test.dart';

import 'package:sat_scraping/sat_scraping.dart';

void main() {
  test('Check bad url', () {
    expect(
      () async => await SatScraping.getInfoFiscal("www.google.com"),
      throwsA(isA<Exception>()),
    );
    expect(
      () async => await SatScraping.getInfoFiscal(
          "https://siat.sat.gob.mx/app/qr/faces/pages/mobile/"),
      throwsA(isA<Exception>()),
    );
  });
  test('Check incomplete url', () {
    expect(
      () async => await SatScraping.getInfoFiscal(
          "https://siat.sat.gob.mx/app/qr/faces/pages/mobile/"),
      throwsA(isA<Exception>()),
    );
  });
  test('Check correct url', () async {
    // TODO: COMPLETE THE URL WITH THE DATA OF YOUR QR
    /// (Completa la url con los datos de tu QR)
    const url =
        "https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?";
    expect(
      await SatScraping.getInfoFiscal(url),
      isInstanceOf<InfoFiscal>(),
    );
  });
}
