import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SistemaUsuario extends StatelessWidget {
  final String nombreSistema;
  final bool activo;
  final Icon icon;
  const SistemaUsuario(
      {required this.nombreSistema,
      required this.activo,
      required this.icon,
      super.key});

  Widget mostrarStatus() {
    return activo
        ? Container(
            height: 10,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(8.0),
          )
        : Container(
            height: 10,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(8.0),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF0F1370),
          width: 3.5,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          Text(
            nombreSistema,
            style: const TextStyle(
              fontSize: 14,
              color: const Color(0xFF0F1370),
              fontWeight: FontWeight.bold,
            ),
          ),
          mostrarStatus(),
        ],
      ),
    );
  }
}
