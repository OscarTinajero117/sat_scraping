# Info SAT — Escáner de Constancia de Situación Fiscal

Aplicación de ejemplo que demuestra el uso del paquete [sat_scraping](https://pub.dev/packages/sat_scraping) para obtener y visualizar la información fiscal del contribuyente directamente desde el SAT.

## Características

- **Escáner QR** — Escanea el código QR de tu constancia de situación fiscal con la cámara del dispositivo
- **Ingreso manual** — Ingresa tu RFC e ID CIF manualmente si no tienes la constancia a la mano
- **Visualización completa** — Muestra datos de identificación, domicilio fiscal y regímenes fiscales en tarjetas organizadas
- **Compartir** — Comparte un resumen de tu información fiscal con otras aplicaciones
- **Historial** — Almacena localmente tus consultas previas para acceder sin conexión a Internet
- **Modo claro/oscuro** — Se adapta automáticamente a la configuración del sistema
- **Diseño premium** — Interfaz con colores institucionales del SAT (guinda y dorado), tipografía Inter y componentes Material 3

## Requisitos

- Flutter SDK `^3.12.0`
- Android SDK 21+ (Android 5.0 Lollipop)
- Permisos de cámara (para el escáner QR)

## Instalación y Ejecución

```bash
# Clonar el repositorio
git clone https://github.com/OscarTinajero117/sat_scraping.git

# Navegar al ejemplo
cd sat_scraping/example

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run
```

## Arquitectura del Proyecto

```ini
lib/
├── main.dart                         # Widget raíz y pantalla principal
├── theme/
│   ├── app_colors.dart               # Paleta de colores institucionales
│   └── app_theme.dart                # Temas claro y oscuro con Material 3
├── utils/
│   └── permissions.dart              # Utilidades de permisos del sistema
├── services/
│   └── history_service.dart          # Servicio de historial local (SharedPreferences)
├── scanner/
│   └── scanner.dart                  # Escáner QR con overlay y animaciones
└── widgets/
    ├── empty_state.dart              # Estado vacío con instrucciones
    ├── error_banner.dart             # Banner de error con botón de reintentar
    ├── info_sat.dart                 # Widget principal de información fiscal
    ├── info_sat_dialog.dart          # Diálogo de ingreso manual con validación
    ├── info_fiscal_detail_card.dart  # Tarjeta de detalle con header gradiente
    ├── history_list.dart             # Lista de historial de consultas
    └── table_info_sat.dart           # Tabla rediseñada con Card y gradiente
```

## Tests

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Análisis estático
flutter analyze
```

Los tests cubren:

- Widget raíz y configuración de tema
- Sistema de diseño (AppTheme)
- Pantalla principal (estados vacío, cargando, con datos)
- Widget de información fiscal (persona física y moral)
- Tarjeta de detalle fiscal
- Tabla de información rediseñada
- Estado vacío con callbacks
- Banner de error con reintentar/cerrar
- Diálogo de ingreso manual con validaciones

## Dependencias

| Paquete              | Uso                                |
|----------------------|------------------------------------|
| `sat_scraping`       | Obtener información fiscal del SAT |
| `mobile_scanner`     | Escáner de código QR               |
| `permission_handler` | Manejo de permisos del sistema     |
| `share_plus`         | Compartir información fiscal       |
| `google_fonts`       | Tipografía Inter premium           |
| `shared_preferences` | Almacenamiento local del historial |

## Privacidad

Los datos fiscales se procesan únicamente en el dispositivo del usuario. El historial se almacena localmente usando SharedPreferences y no se envía a servidores externos. Consulta la [Política de Privacidad](politica_de_privacidad.md) para más información.

## Contribuciones

Se aceptan contribuciones. Si deseas mejorar esta aplicación de ejemplo:

1. Haz un fork del repositorio
2. Crea una rama con tu feature (`git checkout -b feature/mi-mejora`)
3. Haz commit de tus cambios (`git commit -m 'Agrega mi mejora'`)
4. Push a la rama (`git push origin feature/mi-mejora`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](../LICENSE) para más detalles.
