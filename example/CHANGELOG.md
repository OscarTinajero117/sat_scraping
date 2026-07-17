# CHANGELOG

## 2.0.0

### Rediseño de UI/UX

* Nueva paleta de colores institucionales del SAT (guinda y dorado).
* Tema premium con Material 3 y tipografía Inter (Google Fonts).
* Soporte de modo claro y oscuro automático (`ThemeMode.system`).
* Tarjetas de información fiscal con header gradiente e iconos representativos.
* Estado vacío con icono, instrucciones claras y botones de acción prominentes.
* Banner de error amigable con botón de reintentar y opción de cerrar.
* FABs extendidos con labels visibles (`Escanear`, `Manual`).
* Transiciones animadas entre estados (`AnimatedSwitcher`).

### Mejoras al Escáner QR

* Esquinas redondeadas decorativas en el recuadro de escaneo.
* Línea de escaneo animada con efecto de barrido dorado.
* Botón de linterna (flash toggle) en la barra de acciones.
* Texto de instrucción flotante: "Coloca el código QR dentro del recuadro".
* Haptic feedback al detectar un código.
* Overlay con recorte redondeado (en lugar de rectángulo plano).

### Mejoras al Diálogo de Ingreso Manual

* Validación en tiempo real del RFC (12-13 caracteres alfanuméricos).
* Validación de ID CIF (solo numérico).
* Auto-mayúsculas en el campo RFC con `TextInputFormatter`.
* Ayuda contextual que explica dónde encontrar el RFC y el ID CIF.
* Botones diferenciados: `TextButton` para cancelar, `FilledButton` para consultar.
* Hints de ejemplo en los campos.

### Historial de Consultas

* Almacenamiento local de consultas previas con `SharedPreferences`.
* Pantalla de historial con lista de registros (RFC, razón social, fecha).
* Eliminación individual de registros o limpieza total del historial.
* Acceso rápido desde el estado vacío y desde el AppBar.
* Límite máximo de 50 registros con deduplicación por RFC.
* Fechas relativas ("Hace 5 min", "Ayer", "Hace 3 días").
* Diferenciación visual entre persona física y moral en el historial.

### Arquitectura

* Nuevo sistema de diseño centralizado (`theme/app_colors.dart`, `theme/app_theme.dart`).
* Servicio de historial extraído a `services/history_service.dart`.
* Utilidades de permisos extraídas a `utils/permissions.dart` con manejo de `permanentlyDenied`.
* Widget `InfoFiscalDetailCard` reutilizable para secciones de datos.
* Widget `EmptyState` para estado vacío.
* Widget `ErrorBanner` para errores.
* Widget `HistoryList` para el historial.

### Tests

* Tests ampliados de ~3 a ~40 tests de aceptación.
* Cobertura de todos los widgets nuevos y rediseñados.
* Tests de tema y sistema de diseño.
* Tests de validación del diálogo de ingreso manual.
* Tests de estados (vacío, cargando, con datos, error).
* Tests de callbacks e interacciones de usuario.
* Datos de prueba para persona física y persona moral.

### Documentación

* README completamente reescrito con características, arquitectura, instalación y contribución.
* Política de privacidad actualizada para incluir almacenamiento local.
* Doc comments (`///`) en todas las clases y métodos públicos.

### Dependencias

* Se agrega `google_fonts: ^8.2.0` para tipografía premium.
* Se agrega `shared_preferences: ^2.5.5` para historial local.
