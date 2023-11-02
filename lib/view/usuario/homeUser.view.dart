import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/usuario/alarmaUser.view.dart';
import 'package:login_v1/view/usuario/monitoreoSistemaUser.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/notificacionSensor.dart';

class HomeUserPage extends StatefulWidget {
  final String userEmail;
  const HomeUserPage({required this.userEmail, super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  bool switchAlarm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 1,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Monitoreo',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AlarmaUserPage(userEmail: widget.userEmail),
              ),
            );
          }
          if (index == 1) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         AdminPerfilView(userEmail: widget.userEmail),
            //   ),
            // );
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MonitoreoSistemaUser(userEmail: widget.userEmail),
              ),
            );
          }
        },
      ),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(
                administratorName: widget.userEmail, pageName: 'home'),
            Positioned(
              left: 47,
              top: 135,
              child: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 255, 238, 223),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Switch(
                              value: switchAlarm,
                              onChanged: (_) {
                                setState(() {
                                  switchAlarm = _;
                                });
                              }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Alarma",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          color: Colors.grey,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: ClipOval(
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Emergencia",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 55,
              top: 300, // Ajusta la posición según sea necesario
              child: SizedBox(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 410, // Ajusta la altura según sea necesario
                child: ListView(
                  children: [
                    NotificacionSensor(
                        textoNotificacion:
                            "Hay alguien en la puertaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                    NotificacionSensor(
                        textoNotificacion: "Hay alguien en la puerta"),
                  ],
                ),
              ),
            ),
            // TEXTO AGREGAR VIVIENDA
            /*Positioned(
              left: 80,
              top: 585,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('IconButton pressed ...');
                  Get.to(() => AgregarVivienda(userEmail: widget.userEmail),
                      arguments: cantidadViviendas);
                },
              ),
            ),*/
            // FIN TEXTO AGREGAR VIVIENDA
          ],
        ),
      ),
    );
  }
}
