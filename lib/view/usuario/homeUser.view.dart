import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/editAdminInfo.dart';
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
  String vivienda = "";
  late DatabaseReference _dbref;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    _getViviendas();
  }

  Future<void> _getViviendas() async {
    final userSnapshot = await _dbref.child("").once();

    if (userSnapshot.snapshot.value != null) {
      final dynamic data = userSnapshot.snapshot.value;
      data.forEach((key, value) {
        if (key is String && key != "Administradores") {
          if (value["Usuario"]["Email"] == widget.userEmail) {
            vivienda = key;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getViviendas(),
      ),
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
                builder: (context) => MonitoreoSistemaUser(
                    userEmail: widget.userEmail, vivienda: vivienda),
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
                  color: Colors.red,
                ),
                child: GestureDetector(
                  onTap: (() {}),
                  child: const Center(
                    child: Text(
                      "EMERGENCIA",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
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
