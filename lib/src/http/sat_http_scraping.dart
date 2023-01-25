import 'dart:developer';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

import 'package:sat_scraping/src/models/caracteristicas_fiscales.dart';
import 'package:sat_scraping/src/models/info_fiscal.dart';
import 'package:sat_scraping/src/models/regimen.dart';

class SatHttpScraping {
  static Future<String> _getHttpData(String satUrl) async {
    try {
      final response = await http.get(Uri.parse(satUrl));
      if (response.statusCode == 200) return response.body;
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<List<String>>> _getListScraping(String satUrl) async {
    try {
      final html = await _getHttpData(satUrl);
      final soup = BeautifulSoup(html);
      final tables = soup.findAll('table', class_: 'ui-panelgrid');
      List<List<String>> elementsTable = [];
      for (final row in tables) {
        final elements = row
            .findAll('td', attrs: {'style': "text-align:left;"})
            .map((e) => e.text)
            .toList();
        elementsTable.add(elements);
      }
      return elementsTable;
    } catch (e) {
      log('Error --> $e');
    }
    return [];
  }

  static Future<InfoFiscal> getInfoFiscal({
    required String satUrl,
    required String rfc,
    required String idCif,
  }) async {
    final elements = await _getListScraping(satUrl);
    if (elements.isEmpty) {
      throw Exception('Error: No se pudo obtener la información');
    }
    final personaFisica = rfc.length == 13;

    InfoFiscal infoFiscal = InfoFiscal.getDefault();

    int idxCase2 = 0;

    // for (final table in elements) {
    for (int i = 0; i < elements.length; i++) {
      final table = elements[i];
      for (int j = 0; j < table.length; j++) {
        switch (i) {
          case 0:
            personaFisica
                ? infoFiscal = infoFiscal.copyWith(
                    curpRegimen: table[0],
                    razonSocial: '${table[1]} ${table[2]} ${table[3]}',
                    fechaNacimientoConstitucion: table[4],
                    fechaInicioOperacions: table[5],
                    situacionContribuyente: table[6],
                    fechaUltimoCambio: table[7],
                  )
                : infoFiscal = infoFiscal.copyWith(
                    razonSocial: table[0],
                    curpRegimen: table[1],
                    fechaNacimientoConstitucion: table[2],
                    fechaInicioOperacions: table[3],
                    situacionContribuyente: table[4],
                    fechaUltimoCambio: table[5],
                  );
            break;
          case 1:
            infoFiscal = infoFiscal.copyWith(
              rfc: rfc,
              idCif: idCif,
              entidadFederativa: table[0],
              municipioDelegacion: table[1],
              colonia: table[2],
              tipoVialidad: table[3],
              nombreVialidad: table[4],
              numeroExterior: table[5],
              numeroInterior: table[6],
              cp: table[7],
              correoElectronico: table[8],
              al: table[9],
            );
            break;
          case 2:
            while (idxCase2 < table.length) {
              final code = Regimen.getCodeByRegimen(table[idxCase2]);
              infoFiscal.caracteristicasFiscales.add(CaracteristicasFiscales(
                regimenFiscal: table[idxCase2],
                fechaAltaRegimen: table[idxCase2 + 1],
                codigoRegimen: code,
              ));
              idxCase2 += 2;
            }
            break;
        }
      }
    }

    return infoFiscal;
  }
}
