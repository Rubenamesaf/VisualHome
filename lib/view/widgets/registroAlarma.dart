import 'package:flutter/material.dart';

class RegistroAlarma extends StatefulWidget {
  final String textoHora;
  final Widget switchAlarma;
  final Widget botonEliminar;
  const RegistroAlarma(
      {required this.textoHora,
      required this.switchAlarma,
      required this.botonEliminar,
      super.key});

  @override
  State<RegistroAlarma> createState() => _RegistroAlarmaState();
}

class _RegistroAlarmaState extends State<RegistroAlarma> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: const Color.fromARGB(240, 252, 227, 210),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.textoHora,
                style: const TextStyle(fontSize: 36, color: Color(0xFF0F1370)),
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Row(
                children: [
                  widget.switchAlarma,
                  widget.botonEliminar,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
