import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/editAdminInfo.dart';
import 'package:login_v1/view/usuario/alarmaUser.view.dart';
import 'package:login_v1/view/usuario/monitoreoSistemaUser.view.dart';
import 'package:login_v1/view/usuario/userPerfil.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/notificacionSensor.dart';
//import 'package:url_launcher/url_launcher.dart';

Map<String, String> notificacionSistemas = {
  'Timbre': 'Tocaron el timbre',
  'RuidoAlto': 'Hubo un ruido alto',
  'Incendio': 'Se esta quemando algo',
  'DisparoAlarma': 'Se disparo la alarma',
  'BotonPanico': 'Presionaste el boton de panico',
  'TelefonoFijo': 'Esta sonando el telefono',
  'Despertador': 'Sono el despertador',
  'Perimetro': 'Hubo movimiento en el perimetro',
  'Acceso': 'Alguien accedio a una habitacion',
  'ActivacionAlarma': 'Se activo una alarma',
  'PresenciaPuerta': 'Hay alguien en la puerta'
};

class HomeUserPage extends StatefulWidget {
  final String userEmail;
  const HomeUserPage({required this.userEmail, super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  bool switchAlarm = false;
  List<String> notificaciones = [];
  String vivienda = "";
  String databasejson = "";
  late DatabaseReference _dbref;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    _getVivienda();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getVivienda() async {
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
    _setupDatabaseListener();
  }

  // _makePhoneCall() async {
  //   const phoneNumber =
  //       'tel:+1234567890'; // Replace with the phone number you want to call.
  //   if (await canLaunch(phoneNumber)) {
  //     await launch(phoneNumber);
  //   } else {
  //     throw 'Could not launch $phoneNumber';
  //   }
  // }

  void _setupDatabaseListener() {
    _dbref.child(vivienda).onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null && mounted) {
        print("Datos actualizados - " + dataSnapshot.value.toString());
        setState(() {
          databasejson = dataSnapshot.value.toString();

          databasejson = databasejson.substring(1, databasejson.length - 1);

          final keyValuePairs = databasejson.split(', ');

          keyValuePairs.sort();

          notificaciones.clear();

          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim();

            if (nombre != "Usuario") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null && estado == 1) {
                notificaciones.insert(0, notificacionSistemas[nombre]!);
              }
            }
          }
          print(notificaciones);
        });
      }
    });
  }

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
                builder: (context) => AlarmaUserPage(
                    userEmail: widget.userEmail, vivienda: vivienda),
              ),
            );
          }
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserPerfilPage(
                  userEmail: widget.userEmail,
                  vivienda: vivienda,
                ),
              ),
            );
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
                  onTap: (() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('ALERTA'),
                          content: Text('HUMO / GAS'),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Llamar Emergencias'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Detener'),
                            ),
                          ],
                        );
                      },
                    );
                  }),
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
                child: ListView.builder(
                  itemCount: notificaciones.length,
                  itemBuilder: (context, index) {
                    final sistema = notificaciones[index];
                    return NotificacionSensor(textoNotificacion: sistema);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
