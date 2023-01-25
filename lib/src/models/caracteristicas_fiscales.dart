class CaracteristicasFiscales {
  CaracteristicasFiscales({
    required this.regimenFiscal,
    required this.fechaAltaRegimen,
    required this.codigoRegimen,
  });

  final String regimenFiscal;
  final String fechaAltaRegimen;
  final int codigoRegimen;

  Map<String, dynamic> get toJson => {
        'regimen_fiscal': regimenFiscal,
        'fecha_alta_regimen': fechaAltaRegimen,
        'codigo_regimen': codigoRegimen,
      };
}
