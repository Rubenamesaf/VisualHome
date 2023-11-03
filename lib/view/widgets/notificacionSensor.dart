import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificacionSensor extends StatelessWidget {
  final String textoNotificacion;
  const NotificacionSensor({required this.textoNotificacion, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xe5adbace),
              borderRadius: BorderRadius.circular(36.0)),
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
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xFF0F1370)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
