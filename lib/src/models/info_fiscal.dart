import 'caracteristicas_fiscales.dart';

class InfoFiscal {
  InfoFiscal({
    required this.rfc,
    required this.idCif,
    this.curpRegimen,
    required this.razonSocial,
    this.fechaNacimientoConstitucion,
    this.fechaInicioOperacions,
    this.situacionContribuyente,
    this.fechaUltimoCambio,
    this.entidadFederativa,
    this.municipioDelegacion,
    this.colonia,
    this.tipoVialidad,
    this.nombreVialidad,
    this.numeroExterior,
    this.numeroInterior,
    required this.cp,
    this.correoElectronico,
    this.al,
    this.caracteristicasFiscales = const [],
  });

  final String rfc;
  final String idCif;
  final String? curpRegimen;
  final String razonSocial;
  final String? fechaNacimientoConstitucion;
  final String? fechaInicioOperacions;
  final String? situacionContribuyente;
  final String? fechaUltimoCambio;
  final String? entidadFederativa;
  final String? municipioDelegacion;
  final String? colonia;
  final String? tipoVialidad;
  final String? nombreVialidad;
  final String? numeroExterior;
  final String? numeroInterior;
  final String cp;
  final String? correoElectronico;
  final String? al;
  final List<CaracteristicasFiscales> caracteristicasFiscales;

  InfoFiscal copyWith({
    String? rfc,
    String? idCif,
    String? curpRegimen,
    String? razonSocial,
    String? fechaNacimientoConstitucion,
    String? fechaInicioOperacions,
    String? situacionContribuyente,
    String? fechaUltimoCambio,
    String? entidadFederativa,
    String? municipioDelegacion,
    String? colonia,
    String? tipoVialidad,
    String? nombreVialidad,
    String? numeroExterior,
    String? numeroInterior,
    String? cp,
    String? correoElectronico,
    String? al,
    List<CaracteristicasFiscales>? caracteristicasFiscales,
  }) =>
      InfoFiscal(
        rfc: rfc ?? this.rfc,
        idCif: idCif ?? this.idCif,
        curpRegimen: curpRegimen ?? this.curpRegimen,
        razonSocial: razonSocial ?? this.razonSocial,
        fechaNacimientoConstitucion:
            fechaNacimientoConstitucion ?? this.fechaNacimientoConstitucion,
        fechaInicioOperacions:
            fechaInicioOperacions ?? this.fechaInicioOperacions,
        situacionContribuyente:
            situacionContribuyente ?? this.situacionContribuyente,
        fechaUltimoCambio: fechaUltimoCambio ?? this.fechaUltimoCambio,
        entidadFederativa: entidadFederativa ?? this.entidadFederativa,
        municipioDelegacion: municipioDelegacion ?? this.municipioDelegacion,
        colonia: colonia ?? this.colonia,
        tipoVialidad: tipoVialidad ?? this.tipoVialidad,
        nombreVialidad: nombreVialidad ?? this.nombreVialidad,
        numeroExterior: numeroExterior ?? this.numeroExterior,
        numeroInterior: numeroInterior ?? this.numeroInterior,
        cp: cp ?? this.cp,
        correoElectronico: correoElectronico ?? this.correoElectronico,
        al: al ?? this.al,
        caracteristicasFiscales:
            caracteristicasFiscales ?? this.caracteristicasFiscales,
      );

  Map<String, dynamic> get toJson => {
        "rfc": rfc,
        "id_cif": idCif,
        "curp_regimen": curpRegimen,
        "razon_social": razonSocial,
        "fecha_nacimiento_constitucion": fechaNacimientoConstitucion,
        "fecha_inicio_operacions": fechaInicioOperacions,
        "situacion_contribuyente": situacionContribuyente,
        "fecha_ultimo_cambio": fechaUltimoCambio,
        "entidad_federativa": entidadFederativa,
        "municipio_delegacion": municipioDelegacion,
        "colonia": colonia,
        "tipo_vialidad": tipoVialidad,
        "nombre_vialidad": nombreVialidad,
        "numero_exterior": numeroExterior,
        "numero_interior": numeroInterior,
        "cp": cp,
        "correo_electronico": correoElectronico,
        "al": al,
        "caracteristicas_fiscales": List<dynamic>.from(
          caracteristicasFiscales.map((x) => x.toJson),
        ),
      };

  factory InfoFiscal.getDefault() => InfoFiscal(
        rfc: '',
        idCif: '',
        curpRegimen: '',
        razonSocial: '',
        fechaNacimientoConstitucion: '',
        fechaInicioOperacions: '',
        situacionContribuyente: '',
        fechaUltimoCambio: '',
        entidadFederativa: '',
        municipioDelegacion: '',
        colonia: '',
        tipoVialidad: '',
        nombreVialidad: '',
        numeroExterior: '',
        numeroInterior: '',
        cp: '',
        correoElectronico: '',
        al: '',
        caracteristicasFiscales: [],
      );
}
