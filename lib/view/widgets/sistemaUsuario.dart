import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SistemaUsuario extends StatelessWidget {
  final String nombreSistema;
  final bool activo;
  const SistemaUsuario(
      {required this.nombreSistema, required this.activo, super.key});

  Widget mostrarStatus() {
    return activo
        ? Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.green,
            child: const Text(
              "Activo",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.red,
            child: const Text(
              "Inactivo",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            nombreSistema,
            style: const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
          ),
          trailing: mostrarStatus(),
        ),
        Divider(
          color: HexColor('#ED9A5E'),
          height: 3,
          thickness: 2,
        ),
      ],
    );
    // return Card(
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //     color: const Color(0xe5adbace),
    //     height: 60,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Flexible(
    //           child: Text(
    //             nombreSistema,
    //             style: const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
    //           ),
    //         ),
    //         mostrarStatus(),
    //       ],
    //     ),
    //   ),
    // );
  }
}
