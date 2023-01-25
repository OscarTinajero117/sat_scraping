import 'package:flutter/material.dart';
import 'package:sat_scraping/sat_scraping.dart';

import 'table_info_sat.dart';

class InfoSat extends StatelessWidget {
  final InfoFiscal infoFiscal;

  const InfoSat({
    super.key,
    required this.infoFiscal,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final personaFisica = infoFiscal.rfc.length == 13;
    final rows = <TableRow>[];
    int tmpIdx = 1;
    for (final row in infoFiscal.caracteristicasFiscales) {
      rows.addAll([
        _tableRowInformation(
          width: width,
          index: tmpIdx++,
          title: "Régimen:",
          information: row.regimenFiscal,
        ),
        _tableRowInformation(
          width: width,
          index: tmpIdx++,
          title: "Código del Régimen:",
          information: row.codigoRegimen.toString(),
        ),
        _tableRowInformation(
          width: width,
          index: tmpIdx++,
          title: "Fecha de alta:",
          information: row.fechaAltaRegimen,
        ),
      ]);
    }
    return Column(
      children: [
        TableInfoSat(
          tableTitle: 'Datos de Identificación',
          children: [
            _tableRowInformation(
              index: 1,
              title: personaFisica ? "Nombre:" : "Denominación o Razón Social:",
              information: infoFiscal.razonSocial,
              width: width,
            ),
            _tableRowInformation(
              width: width,
              index: 2,
              title: "RFC:",
              information: infoFiscal.rfc,
            ),
            _tableRowInformation(
              width: width,
              index: 3,
              title: "ID CIF:",
              information: infoFiscal.idCif,
            ),
            _tableRowInformation(
              width: width,
              index: 4,
              title: personaFisica ? "CURP:" : "Régimen de capital:",
              information: infoFiscal.curpRegimen ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 5,
              title: personaFisica
                  ? "Fecha Nacimiento:"
                  : "Fecha de constitución:",
              information: infoFiscal.fechaNacimientoConstitucion ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 6,
              title: "Fecha de Inicio de operaciones:",
              information: infoFiscal.fechaInicioOperacions ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 7,
              title: "Situación del contribuyente:",
              information: infoFiscal.situacionContribuyente ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 8,
              title: "Fecha del último cambio de situación:",
              information: infoFiscal.fechaUltimoCambio ?? '',
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        //ubicacion
        TableInfoSat(
          tableTitle: 'Datos de Ubicación (domicilio fiscal, vigente)',
          children: [
            _tableRowInformation(
              width: width,
              index: 1,
              title: "Entidad Federativa:",
              information: infoFiscal.entidadFederativa ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 2,
              title: "Municipio o delegación:",
              information: infoFiscal.municipioDelegacion ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 3,
              title: "Colonia:",
              information: infoFiscal.colonia ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 4,
              title: "Tipo de vialidad:",
              information: infoFiscal.tipoVialidad ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 5,
              title: "Nombre de la vialidad:",
              information: infoFiscal.nombreVialidad ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 6,
              title: "Número exterior:",
              information: infoFiscal.numeroExterior ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 7,
              title: "Número interior:",
              information: infoFiscal.numeroInterior ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 8,
              title: "Código Postal:",
              information: infoFiscal.cp,
            ),
            _tableRowInformation(
              width: width,
              index: 9,
              title: "Correo electrónico:",
              information: infoFiscal.correoElectronico ?? '',
            ),
            _tableRowInformation(
              width: width,
              index: 10,
              title: "AL:",
              information: infoFiscal.al ?? '',
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        //Caracteristicas
        TableInfoSat(
          tableTitle: 'Características fiscales (vigente)',
          children: rows,
        ),
      ],
    );
  }

  TableRow _tableRowInformation({
    required int index,
    required String title,
    required String information,
    required double width,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.blue.shade50 : Colors.transparent,
      ),
      children: [
        _containerTextInformation(
          text: title,
          fontWeight: FontWeight.bold,
          width: width,
        ),
        _containerTextInformation(
          text: information,
          width: width,
        ),
      ],
    );
  }

  Container _containerTextInformation({
    required String text,
    FontWeight fontWeight = FontWeight.normal,
    required double width,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: width < 360
              ? 13
              : width < 720
                  ? 16
                  : 20,
          fontWeight: fontWeight,
          color: Colors.black,
        ),
      ),
    );
  }
}
