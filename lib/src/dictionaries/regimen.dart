/// La constante [regimenes] es un mapa de enteros y cadenas. El mapa tiene
/// parejas clave-valor que representan códigos de régimen y sus nombres
/// respectivos.
const Map<int, String> regimenes = {
  601: 'General de Ley Personas Morales',
  603: 'Personas Morales con Fines no Lucrativos',
  605: 'Sueldos y Salarios e Ingresos Asimilados a Salarios',
  606: 'Arrendamiento',
  607: 'Régimen de Enajenación o Adquisición de Bienes',
  608: 'Demás ingresos',
  609: 'Consolidación',
  610: 'Residentes en el Extranjero sin Establecimiento Permanente en México',
  611: 'Ingresos por Dividendos (socios y accionistas)',
  612: 'Personas Físicas con Actividades Empresariales y Profesionales',
  614: 'Ingresos por intereses',
  615: 'Régimen de los ingresos por obtención de premios',
  616: 'Sin obligaciones fiscales',
  620:
      'Sociedades Cooperativas de Producción que optan por Diferir sus Ingresos',
  621: 'Incorporación Fiscal',
  622: 'Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras',
  623: 'Opcional para Grupos de Sociedades',
  624: 'Coordinados',
  625:
      'Régimen de las Actividades Empresariales con ingresos a través de Plataformas Tecnológicas',
  626: 'Régimen Simplificado de Confianza',
  628: 'Hidrocarburos',
  629:
      'De los Regímenes Fiscales Preferentes y de las Empresas Multinacionales',
  630: 'Enajenación de acciones en bolsa de valores',
};

/// La función [getRegimenByCode], recibe un código de búsqueda como parámetro
/// y devuelve el nombre del régimen correspondiente utilizando el operador "??",
/// que devuelve el valor a la derecha si el valor a la izquierda es nulo o
/// vacío.
String getRegimenByCode(int searchCode) => regimenes[searchCode] ?? '';

/// La función [getCodeByRegimen], recibe un nombre de régimen de búsqueda como
/// parámetro y devuelve el código correspondiente utilizando el método
/// [keys.firstWhere] para encontrar la primera clave que cumpla con la
/// condición de contener el nombre de búsqueda en mayúsculas. Si no se
/// encuentra una clave que cumpla con la condición, devuelve 0.
int getCodeByRegimen(String searchRegimen) => regimenes.keys.firstWhere(
      (k) => searchRegimen.toUpperCase().contains(
            regimenes[k]!.toUpperCase(),
          ),
      orElse: () => 0,
    );

/// La función [getCodesByRegimen] recibe como parámetro una cadena de texto
/// [searchRegimen] y busca en el mapa regimenes todas las claves (códigos)
/// cuyo valor (nombre del régimen) contenga esa cadena de texto. El valor de la
/// cadena de búsqueda se limpia primero quitando los espacios en blanco al
/// principio y al final y convirtiéndolo a minúsculas. Luego, se utiliza el
/// método [where] de la clase [Iterable] para filtrar las claves del mapa que
/// cumplen con la condición de contener la cadena de búsqueda. Por último, se
/// convierte el resultado en una lista y se devuelve como resultado de la
/// función.
List<int> getCodesByRegimen(String searchRegimen) {
  searchRegimen = searchRegimen.trim().toLowerCase();
  return regimenes.keys
      .where((k) => searchRegimen.contains(regimenes[k]!.trim().toLowerCase()))
      .toList();
}
