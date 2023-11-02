import 'package:flutter/material.dart';

class SistemaUsuario extends StatelessWidget {
  final String nombreSistema;
  final bool activo;
  const SistemaUsuario(
      {required this.nombreSistema, required this.activo, super.key});

  Widget mostrarStatus() {
    return activo
        ? const Text(
            "Activo",
            style: TextStyle(
                fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          )
        : const Text(
            "Inactivo",
            style: TextStyle(fontSize: 16, color: Colors.red),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        color: const Color(0xe5adbace),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                nombreSistema,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
              ),
            ),
            mostrarStatus(),
          ],
        ),
      ),
    );
  }
}
