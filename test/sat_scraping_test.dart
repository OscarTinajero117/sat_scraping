import 'package:sat_scraping/sat_scraping.dart';
import 'package:test/test.dart';

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
      isA<InfoFiscal>(),
    );
  });
  test('Check manual data', () async {
    const rfc = 'PUT_RFC'; // (RFC)
    const idCif = 'PUT_IDCIF'; // (ID CIF)
    expect(
      await SatScraping.getInfoFiscalManual(rfc: rfc, idCif: idCif),
      isA<InfoFiscal>(),
    );
  });
}
