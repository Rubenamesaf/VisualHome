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
            width: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(8.0),
          )
        : Container(
            width: 100,
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
        color: const Color(0xFF0F1370),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          Text(
            nombreSistema,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          mostrarStatus(),
        ],
      ),
    );
    // return Column(
    //   children: [
    //     ListTile(
    //       title: Text(
    //         nombreSistema,
    //         style: const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
    //       ),
    //       trailing: mostrarStatus(),
    //     ),
    //     Divider(
    //       color: HexColor('#ED9A5E'),
    //       height: 3,
    //       thickness: 2,
    //     ),
    //   ],
    // );
  }
}
