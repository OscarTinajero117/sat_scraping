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
/// La función se asegura de que la url sea válida, comparando si empieza con
/// [https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?]. Si no
/// es así, lanza una excepción "Error: Url invalida".
///
/// Luego, la función divide la url en una lista [splitList] usando el caracter
/// "_" como separador. El último elemento de esta lista es asignado a la
/// variable [rfc] y el valor de [idCif] se obtiene dividiendo el primer
/// elemento de la lista con el caracter "=" y tomando el último elemento.
///
/// Finalmente, se utiliza un método de la clase [SatHttpScraping] para obtener
/// la información fiscal, pasando las variables [satUrl], [rfc] e [idCif] como
/// parámetros. El resultado se asigna a la variable [infoFiscal] y se retorna.
///
/// La clase [SatScraping] también exporta dos paquetes
/// *package: sat_scraping/src/models/info_fiscal.dart* y
/// *package: sat_scraping/src/dictionaries/regimen.dart*, lo que permite el
/// acceso a estos desde el código que importa esta biblioteca.
///
/// En caso de que ocurra algún error, se registra en el registro de
/// desarrollador utilizando la función log y se reenvía la excepción.
class SatScraping {
  static Future<InfoFiscal> getInfoFiscal(String satUrl) async {
    try {
      if (!satUrl.startsWith(
          'https://siat.sat.gob.mx/app/qr/faces/pages/mobile/validadorqr.jsf?')) {
        throw Exception('Error: Url invalida');
      }

      final splitList = satUrl.split('_');

      final rfc = splitList.last;
      final idCif = splitList.first.split('=').last;

      final infoFiscal = await SatHttpScraping.getInfoFiscal(
        satUrl: satUrl,
        rfc: rfc,
        idCif: idCif,
      );

      return infoFiscal;
    } catch (e) {
      log('--> $e');
      rethrow;
    }
  }
}
