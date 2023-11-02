import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificacionSensor extends StatelessWidget {
  final String textoNotificacion;
  const NotificacionSensor({required this.textoNotificacion, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: const Color(0xe5adbace),
        height: 60,
        child: Row(
          children: [
            const Icon(Icons.notifications, size: 30),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                textoNotificacion,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
