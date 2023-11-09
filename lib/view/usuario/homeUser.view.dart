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
import 'package:login_v1/view/widgets/sistemaUsuario.dart';
//import 'package:url_launcher/url_launcher.dart';

Map<String, IconData> sistemasIcons = {
  'Timbre': Icons.doorbell,
  'RuidoAlto': Icons.speaker,
  'Incendio': Icons.fire_truck,
  'DisparoAlarma': Icons.alarm,
  'BotonPanico': Icons.emergency,
  'TelefonoFijo': Icons.phone_sharp,
  'Despertador': Icons.lock_clock,
  'Perimetro': Icons.square,
  'Acceso': Icons.door_back_door,
  'ActivacionAlarma': Icons.alarm_off,
  'PresenciaPuerta': Icons.door_front_door,
};

class HomeUserPage extends StatefulWidget {
  final String userEmail;
  const HomeUserPage({required this.userEmail, super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  bool switchAlarm = false;
  List<Sistema> sistemasList = [];
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

          // Eliminar los corchetes iniciales y finales
          databasejson = databasejson.substring(1, databasejson.length - 1);

          // Dividir la cadena en pares clave-valor
          final keyValuePairs = databasejson.split(', ');

          // Limpiar la lista actual antes de agregar los nuevos sistemas
          sistemasList.clear();

          // Recorrer los pares clave-valor y agregarlos a sistemasList
          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim(); // Eliminar espacios en blanco

            if (nombre != "Usuario" &&
                nombre != "Alarmas" &&
                nombre != "Hours") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null) {
                sistemasList.add(Sistema(nombre, estado == 1));
              }
            }
          }
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
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
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserPerfilPage(
                  userEmail: widget.userEmail,
                  vivienda: vivienda,
                ),
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
              left: 55,
              top: 100, // Ajusta la posición según sea necesario
              child: SizedBox(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 470, // Ajusta la altura según sea necesario
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: sistemasList.length,
                  itemBuilder: (context, index) {
                    final sistema = sistemasList[index];
                    return SistemaUsuario(
                      nombreSistema: sistema.nombre,
                      activo: sistema.estado,
                      icon: Icon(
                        sistemasIcons[sistema.nombre],
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 47,
              top: 590,
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
                child: Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: const Center(
                    child: Text(
                      "EMERGENCIA",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
