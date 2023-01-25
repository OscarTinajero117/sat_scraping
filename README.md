<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Sat Scraping

Este paquete sirve para extraer la información fiscal que viene en la página: 

https://siat.sat.gob.mx

Este paquete es útil para obtener dicha información de manera más simple. Solo es necesario lo siguiente:

```dart
///“TU_URL” está contenido en el código QR que viene en la constancia de situación fiscal. 
final infoFiscal = await SatScraping.getInfoFiscal(“TU_URL”);
```

Y listo, ya tienes los datos fiscales.
