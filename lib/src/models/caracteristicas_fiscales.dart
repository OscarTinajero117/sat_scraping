/// La clase [CaracteristicasFiscales] es una clase que representa las
/// características fiscales de un contribuyente.
///
/// Esta clase tiene 3 atributos:
/// [regimenFiscal], [fechaAltaRegimen] y [codigoRegimen].
///
/// Estos atributos son inicializados en el constructor de la clase y se
/// utilizan para almacenar información específica sobre un contribuyente.
///
/// También tiene un método [toJson] que devuelve un mapa con las claves
/// [regimen_fiscal], [fecha_alta_regimen] y [codigo_regimen] y sus respectivos
/// valores. Este método se utiliza para convertir la instancia de la clase a
/// un formato compatible con JSON.
class CaracteristicasFiscales {
  CaracteristicasFiscales({
    required this.regimenFiscal,
    required this.fechaAltaRegimen,
    required this.codigoRegimen,
  });

  /// Es el nombre del Régimen Fiscal
  final String regimenFiscal;

  /// Es la Fecha en que se dio de alta el Régimen Fiscal de la persona física
  /// o moral
  final String fechaAltaRegimen;

  ///Es el Código del Régimen Fiscal
  final int codigoRegimen;

  /// El Método [toJson] devuelve un mapa compatible con JSON
  Map<String, dynamic> get toJson => {
        'regimen_fiscal': regimenFiscal,
        'fecha_alta_regimen': fechaAltaRegimen,
        'codigo_regimen': codigoRegimen,
      };

  CaracteristicasFiscales copyWith({
    String? regimenFiscal,
    String? fechaAltaRegimen,
    int? codigoRegimen,
  }) =>
      CaracteristicasFiscales(
        regimenFiscal: regimenFiscal ?? this.regimenFiscal,
        fechaAltaRegimen: fechaAltaRegimen ?? this.fechaAltaRegimen,
        codigoRegimen: codigoRegimen ?? this.codigoRegimen,
      );

  factory CaracteristicasFiscales.fromJson(Map<String, dynamic> json) =>
      CaracteristicasFiscales(
        regimenFiscal: json['regimen_fiscal'],
        fechaAltaRegimen: json['fecha_alta_regimen'],
        codigoRegimen: json['codigo_regimen'],
      );
}
