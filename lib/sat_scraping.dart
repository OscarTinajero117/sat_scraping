library sat_scraping;

import 'dart:developer';

import 'package:sat_scraping/src/http/sat_http_scraping.dart';
import 'package:sat_scraping/src/models/info_fiscal.dart';

export 'package:sat_scraping/src/models/info_fiscal.dart';
export 'package:sat_scraping/src/dictionaries/regimen.dart';

/// La clase [SatScraping] tiene un método estático llamado [getInfoFiscal].
/// El método recibe una cadena [satUrl] como parámetro y trata de obtener
/// información fiscal de esa url.
///
/// Luego, la función divide la url en una lista [splitList] usando el caracter
/// "_" como separador. El último elemento de esta lista es asignado a la
/// variable [rfc] y el valor de [idCif] se obtiene dividiendo el primer
/// elemento de la lista con el caracter "=" y tomando el último elemento.
///
/// Finalmente, se utiliza un método de la clase [SatHttpScraping] para obtener
/// la información fiscal, pasando las variables [satUrl], [rfc] e [idCif] como
/// parámetros. El resultado se retorna.
///
/// La clase [SatScraping] también exporta dos paquetes
///
/// *package: sat_scraping/src/models/info_fiscal.dart*
///
/// *package: sat_scraping/src/dictionaries/regimen.dart*
///
/// lo que permite el acceso a estos desde el código que importa esta biblioteca.
class SatScraping {
  /// [getInfoFiscal].
  /// El método recibe una cadena [satUrl] como parámetro y trata de obtener
  /// información fiscal de esa url.
  static Future<InfoFiscal> getInfoFiscal(String satUrl) async {
    try {
      /// La función se asegura de que la url sea válida, comparando si
      /// empieza con:
      /// [https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?].
      if (!satUrl.startsWith(
          'https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?')) {
        /// Si no es así, lanza una excepción "Error: Url invalida".
        throw Exception('Error: Url invalida');
      }

      /// Se divide la url en una lista [splitList] usando el caracter
      /// "_" como separador.
      final splitList = satUrl.split('_');

      /// El último elemento de esta lista es asignado a la variable [rfc]
      final rfc = splitList.last;

      /// El valor de [idCif] se obtiene dividiendo el primer elemento de la
      /// lista con el caracter "=" y tomando el último elemento.
      final idCif = splitList.first.split('=').last;

      /// Se utiliza un método de la clase [SatHttpScraping] para obtener la
      /// información fiscal, pasando las variables [satUrl], [rfc] e [idCif] como
      /// parámetros. El resultado  se retorna.
      return await SatHttpScraping.getInfoFiscal(
        satUrl: satUrl,
        rfc: rfc,
        idCif: idCif,
      );
    } catch (e) {
      /// En caso de que ocurra algún error, se registra en el registro de
      /// desarrollador utilizando la función log y se reenvía la excepción.
      log('--> $e');
      rethrow;
    }
  }

  /// Este método es similar al anterior, pero recibe como parámetros
  /// [rfc] y [idCif] en lugar de [satUrl].
  ///
  /// El método se asegura de que [rfc] y [idCif] no estén vacíos y que [rfc]
  /// tenga una longitud de 12 o 13 caracteres.
  ///
  /// Luego, se construye la url a partir de [rfc] e [idCif] y se utiliza el
  /// método [getInfoFiscal] para obtener la información fiscal.
  ///
  /// El resultado se retorna.
  ///
  /// Este método es útil cuando no se tiene el QR de la constancia de
  /// situación fiscal
  static Future<InfoFiscal> getInfoFiscalManual({
    required String rfc,
    required String idCif,
  }) async {
    try {
      /// Se asegura de que [rfc] y [idCif] no estén vacíos
      if (rfc == '' || idCif == '') {
        throw Exception('Error: No se puede dejar vacio el rfc o el idCif');
      }

      /// y que [rfc] tenga una longitud de 12 o 13 caracteres.
      if (rfc.length > 13 || rfc.length < 12) {
        throw Exception('Error: RFC invalido');
      }

      /// Se construye la url a partir de [rfc] e [idCif]
      /// y se utiliza el método [getInfoFiscal] para obtener la información
      /// fiscal.
      return await SatHttpScraping.getInfoFiscal(
        satUrl:
            'https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?D1=10&D2=1&D3='
            '${idCif}_$rfc',
        rfc: rfc,
        idCif: idCif,
      );
    } catch (e) {
      /// En caso de que ocurra algún error, se registra en el registro de
      /// desarrollador utilizando la función log y se reenvía la excepción.
      log('--> $e');
      rethrow;
    }
  }
}
