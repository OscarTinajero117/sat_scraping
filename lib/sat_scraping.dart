library sat_scraping;

import 'dart:developer';

import 'package:sat_scraping/src/http/sat_http_scraping.dart';
import 'package:sat_scraping/src/models/info_fiscal.dart';

export 'package:sat_scraping/src/models/info_fiscal.dart';

class SatScraping {
  static Future<InfoFiscal> getInfoFiscal(String satUrl) async {
    try {
      if (!satUrl.startsWith('https://siat.sat.gob.mx')) {
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
