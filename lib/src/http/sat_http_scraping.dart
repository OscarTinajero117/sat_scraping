import 'dart:developer';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

import 'package:sat_scraping/src/models/caracteristicas_fiscales.dart';
import 'package:sat_scraping/src/models/info_fiscal.dart';
import 'package:sat_scraping/src/dictionaries/regimen.dart';

/// SatHttpScraping tiene varios métodos estáticos que se utilizan para obtener
/// información fiscal de un sitio web específico utilizando el paquete de
/// scraping de BeautifulSoup. El método principal es getInfoFiscal(), que
/// toma una URL del sitio web del Servicio de Administración Tributaria (SAT),
/// el RFC y el IDCIF del contribuyente como parámetros. Utiliza el método
/// _getListScraping() para obtener una lista de elementos de tabla y luego
/// utiliza un ciclo for para recorrer cada elemento de la tabla y asignar
/// los valores correspondientes a una instancia de la clase InfoFiscal.
class SatHttpScraping {
  /// Esta función es un método asíncrono que se encarga de hacer una petición
  /// HTTP GET a la URL especificada en el parámetro "satUrl". Utiliza la
  /// biblioteca http para realizar la petición.
  ///
  /// La respuesta de la petición se almacena en la variable "response". Luego,
  /// se comprueba si el código de estado de la respuesta es igual a 200 (OK),
  /// si es así, se retorna el cuerpo de la respuesta en forma de una cadena
  /// de texto.
  ///
  /// Si el código de estado es diferente a 200 se lanza una excepción con un
  /// mensaje personalizado incluyendo el código de estado y el cuerpo de la
  /// respuesta. Esta excepción puede ser manejada por el código que llama a
  /// esta función.
  static Future<String> _getHttpData(String satUrl) async {
    final response = await http.get(Uri.parse(satUrl));
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
    return response.body;
  }

  /// _getListScraping que toma una URL como parámetro. La función intenta
  /// obtener el contenido HTML de la URL utilizando otra función [_getHttpData].
  /// Luego utiliza la biblioteca BeautifulSoup para buscar todas las tablas
  /// con la clase "ui-panelgrid" en el HTML y almacena estas tablas en una
  /// variable. Por cada tabla encontrada, busca todos los elementos "td" con
  /// el atributo de estilo "text-align: left" y los almacena en una lista de
  /// elementos. Estas listas se almacenan en una variable "elementsTable" y
  /// finalmente se devuelve. Si ocurre un error en cualquier paso, se registra
  /// un mensaje de error y se relanza la excepción.
  static Future<List<List<String>>> _getListScraping(String satUrl) async {
    try {
      final html = await _getHttpData(satUrl);
      final soup = BeautifulSoup(html);
      final tables = soup.findAll('table', class_: 'ui-panelgrid');
      final elementsTable = <List<String>>[];
      for (final table in tables) {
        elementsTable.add(table
            .findAll('td', attrs: {'style': "text-align:left;"})
            .map((e) => e.text)
            .toList());
      }
      return elementsTable;
    } catch (e) {
      log('Error --> $e');
      rethrow;
    }
  }

  /// La función [getInfoFiscal] tiene como entrada tres parámetros requeridos,
  /// [satUrl], [rfc] y [idCif]. Utiliza una llamada a una función
  /// [_getListScraping] para obtener una lista de elementos, y luego verifica
  /// si la lista está vacía. Si está vacía, lanza una excepción.
  ///
  /// La función determina si el rfc es de una persona física o no, y crea una
  /// instancia de InfoFiscal con valores predeterminados.
  ///
  /// A continuación, recorre la lista de elementos y utiliza un switch para
  /// asignar los valores de la lista a los campos correspondientes en la
  /// instancia de InfoFiscal.
  ///
  /// Finalmente, la función devuelve la instancia de InfoFiscal rellena con
  /// los valores obtenidos.
  static Future<InfoFiscal> getInfoFiscal({
    required String satUrl,
    required String rfc,
    required String idCif,
  }) async {
    final elements = await _getListScraping(satUrl);
    if (elements.isEmpty) {
      throw Exception('Error: No se pudo obtener la información');
    }
    final isPersonaFisica = rfc.length == 13;

    InfoFiscal infoFiscal = InfoFiscal.getDefault();

    for (int i = 0; i < elements.length; i++) {
      final table = elements[i];

      switch (i) {
        case 0:
          isPersonaFisica
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
          for (int j = 0; j < table.length; j += 2) {
            final code = getCodeByRegimen(table[j]);
            infoFiscal.caracteristicasFiscales.add(CaracteristicasFiscales(
              regimenFiscal: table[j],
              fechaAltaRegimen: table[j + 1],
              codigoRegimen: code,
            ));
          }
          break;
      }
    }

    return infoFiscal;
  }
}
