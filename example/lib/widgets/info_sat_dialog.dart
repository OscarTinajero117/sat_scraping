// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class InfoSatDialog extends StatefulWidget {
  const InfoSatDialog({super.key});

  @override
  _InfoSatDialogState createState() => _InfoSatDialogState();
}

class _InfoSatDialogState extends State<InfoSatDialog> {
  final _formKey = GlobalKey<FormState>();
  String rfc = "";
  String idcif = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ingrese los datos"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "RFC"),
              validator: (value) {
                if (value == null) return null;
                if (value.isEmpty) {
                  return "Por favor ingrese un RFC";
                }
                return null;
              },
              onSaved: (value) {
                if (value == null) return;
                rfc = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "IDCIF"),
              validator: (value) {
                if (value == null) return null;
                if (value.isEmpty) {
                  return "Por favor ingrese un IDCIF";
                }
                return null;
              },
              onSaved: (value) {
                if (value == null) return;
                idcif = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState == null) return;
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // print("RFC: $rfc, IDCIF: $idcif");
              Navigator.of(context).pop({
                "rfc": rfc,
                "idcif": idcif,
              });
            }
          },
          child: const Text("Enviar"),
        ),
      ],
    );
  }
}
