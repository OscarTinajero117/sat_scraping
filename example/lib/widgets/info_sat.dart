import 'package:flutter/material.dart';
import 'package:sat_scraping/sat_scraping.dart';

import '../theme/app_theme.dart';
import 'info_fiscal_detail_card.dart';

/// Widget principal que muestra toda la información fiscal del contribuyente.
///
/// Organiza los datos en tres secciones con tarjetas premium:
/// 1. **Datos de Identificación** — RFC, nombre, CURP, fechas
/// 2. **Datos de Ubicación** — Domicilio fiscal vigente
/// 3. **Características Fiscales** — Regímenes fiscales vigentes
///
/// Detecta automáticamente si es persona física (RFC 13 caracteres) o
/// persona moral (RFC 12 caracteres) para adaptar las etiquetas.
class InfoSat extends StatelessWidget {
  /// La información fiscal del contribuyente a mostrar.
  final InfoFiscal infoFiscal;

  const InfoSat({
    super.key,
    required this.infoFiscal,
  });

  @override
  Widget build(BuildContext context) {
    final personaFisica = infoFiscal.rfc.length == 13;

    // Construir filas de regímenes fiscales
    final regimenRows = <InfoRow>[];
    for (final row in infoFiscal.caracteristicasFiscales) {
      regimenRows.addAll([
        InfoRow(label: 'Régimen:', value: row.regimenFiscal),
        InfoRow(label: 'Código:', value: row.codigoRegimen.toString()),
        InfoRow(label: 'Fecha de alta:', value: row.fechaAltaRegimen),
      ]);
    }

    return Column(
      children: [
        // ── Sección 1: Datos de Identificación ──
        InfoFiscalDetailCard(
          title: 'Datos de Identificación',
          icon: Icons.badge_outlined,
          rows: [
            InfoRow(
              label: personaFisica
                  ? 'Nombre:'
                  : 'Denominación o Razón Social:',
              value: infoFiscal.razonSocial,
            ),
            InfoRow(label: 'RFC:', value: infoFiscal.rfc),
            InfoRow(label: 'ID CIF:', value: infoFiscal.idCif),
            InfoRow(
              label: personaFisica ? 'CURP:' : 'Régimen de capital:',
              value: infoFiscal.curpRegimen,
            ),
            InfoRow(
              label: personaFisica
                  ? 'Fecha Nacimiento:'
                  : 'Fecha de constitución:',
              value: infoFiscal.fechaNacimientoConstitucion,
            ),
            InfoRow(
              label: 'Inicio de operaciones:',
              value: infoFiscal.fechaInicioOperacions,
            ),
            InfoRow(
              label: 'Situación:',
              value: infoFiscal.situacionContribuyente,
            ),
            InfoRow(
              label: 'Último cambio:',
              value: infoFiscal.fechaUltimoCambio,
            ),
          ],
        ),

        const SizedBox(height: AppTheme.sectionSpacing),

        // ── Sección 2: Datos de Ubicación ──
        InfoFiscalDetailCard(
          title: 'Domicilio Fiscal (vigente)',
          icon: Icons.location_on_outlined,
          rows: [
            InfoRow(
              label: 'Entidad Federativa:',
              value: infoFiscal.entidadFederativa,
            ),
            InfoRow(
              label: 'Municipio:',
              value: infoFiscal.municipioDelegacion,
            ),
            InfoRow(label: 'Colonia:', value: infoFiscal.colonia),
            InfoRow(label: 'Tipo vialidad:', value: infoFiscal.tipoVialidad),
            InfoRow(label: 'Vialidad:', value: infoFiscal.nombreVialidad),
            InfoRow(label: 'Núm. exterior:', value: infoFiscal.numeroExterior),
            InfoRow(label: 'Núm. interior:', value: infoFiscal.numeroInterior),
            InfoRow(label: 'Código Postal:', value: infoFiscal.cp),
            InfoRow(
              label: 'Correo electrónico:',
              value: infoFiscal.correoElectronico,
            ),
            InfoRow(label: 'AL:', value: infoFiscal.al),
          ],
        ),

        const SizedBox(height: AppTheme.sectionSpacing),

        // ── Sección 3: Características Fiscales ──
        if (regimenRows.isNotEmpty)
          InfoFiscalDetailCard(
            title: 'Características Fiscales (vigente)',
            icon: Icons.account_balance_outlined,
            rows: regimenRows,
          ),
      ],
    );
  }
}
