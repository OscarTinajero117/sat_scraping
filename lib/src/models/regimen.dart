class Regimen {
  Regimen(this.codigo, this.regimen);

  final int codigo;
  final String regimen;

  static String getRegimenByCode(int searchCode) {
    for (final row in regimenes) {
      if (row.codigo == searchCode) {
        return row.regimen;
      }
    }
    return '';
  }

  static int getCodeByRegimen(String searchRegimen) {
    for (final row in regimenes) {
      if (searchRegimen.toUpperCase().contains(row.regimen.toUpperCase())) {
        return row.codigo;
      }
    }
    return 0;
  }

  static List<Regimen> get regimenes => [
        Regimen(601, 'General de Ley Personas Morales'),
        Regimen(603, 'Personas Morales con Fines no Lucrativos'),
        Regimen(605, 'Sueldos y Salarios e Ingresos Asimilados a Salarios'),
        Regimen(606, 'Arrendamiento'),
        Regimen(607, 'Régimen de Enajenación o Adquisición de Bienes'),
        Regimen(608, 'Demás ingresos'),
        Regimen(609, 'Consolidación'),
        Regimen(610,
            'Residentes en el Extranjero sin Establecimiento Permanente en México'),
        Regimen(611, 'Ingresos por Dividendos (socios y accionistas)'),
        Regimen(612,
            'Personas Físicas con Actividades Empresariales y Profesionales'),
        Regimen(614, 'Ingresos por intereses'),
        Regimen(615, 'Régimen de los ingresos por obtención de premios'),
        Regimen(616, 'Sin obligaciones fiscales'),
        Regimen(620,
            'Sociedades Cooperativas de Producción que optan por Diferir sus Ingresos'),
        Regimen(621, 'Incorporación Fiscal'),
        Regimen(
            622, 'Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras'),
        Regimen(623, 'Opcional para Grupos de Sociedades'),
        Regimen(624, 'Coordinados'),
        Regimen(625,
            'Régimen de las Actividades Empresariales con ingresos a través de Plataformas Tecnológicas'),
        Regimen(626, 'Régimen Simplificado de Confianza'),
        Regimen(628, 'Hidrocarburos'),
        Regimen(629,
            'De los Regímenes Fiscales Preferentes y de las Empresas Multinacionales'),
        Regimen(630, 'Enajenación de acciones en bolsa de valores'),
      ];
}
