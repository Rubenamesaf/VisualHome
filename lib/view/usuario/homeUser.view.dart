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
import 'package:url_launcher/url_launcher.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Map<String, IconData> sistemasIcons = {
  'Timbre': Icons.doorbell,
  'Ruido': Icons.speaker,
  'Incendio': Icons.fire_extinguisher,
  'Movimiento': Icons.warning,
  'Pánico': Icons.emergency,
  'Teléfono': Icons.phone_sharp,
  'Alarmas': Icons.alarm,
  'Perímetro': Icons.square_outlined,
  'Acceso': Icons.door_back_door,
  'Seguridad': Icons.security,
  'Visitantes': Icons.person,
};

class HomeUserPage extends StatefulWidget {
  final String userEmail;
  const HomeUserPage({required this.userEmail, super.key});
  static const route = '/userpage';

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  bool switchAlarm = false;
  List<Sistema> sistemasList = [];
  String vivienda = "";
  String databasejson = "";
  late DatabaseReference _dbref;
  List<Sistema> sistemasListParaMostrar = [];
  Color _botonColor = const Color.fromARGB(255, 110, 112, 114);
  String _estadoAlarma = "           ARMAR\nSistema de seguridad";

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

  void _activarBotonPanico() {
    // Actualizar el valor en la base de datos
    _dbref.child(vivienda).update({"Pánico": 1});
  }

  void _detenerBotonPanico() {
    // Actualizar el valor en la base de datos
    _dbref.child(vivienda).update({"Pánico": 0});
    _dbref.child(vivienda).update({"Movimiento": 0});
    _dbref.child(vivienda).update({"Perímetro": 0});
    _dbref.child(vivienda).update({"Incendio": 0});
  }

  void _toggleActivacionAlarma() {
    _dbref
        .child(vivienda)
        .child("Seguridad")
        .once()
        .then((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        int activacionAlarma = snapshot.value as int;

        // Cambiar el valor y el color del botón
        setState(() {
          _botonColor = (activacionAlarma == 0)
              ? Colors.green
              : const Color.fromARGB(255, 110, 112, 114);

          _estadoAlarma = (activacionAlarma == 0)
              ? "        DESARMAR\nSistema de seguridad"
              : "           ARMAR\nSistema de seguridad";
        });

        // Actualizar el valor en la base de datos
        _dbref
            .child(vivienda)
            .update({"Seguridad": (activacionAlarma == 0) ? 1 : 0});
      }
    });
  }

  void _setupDatabaseListener() {
    _dbref.child(vivienda).onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null && mounted) {
        print("Datos actualizados - " + dataSnapshot.value.toString());
        setState(() {
          databasejson = dataSnapshot.value.toString();
          databasejson = databasejson.substring(1, databasejson.length - 1);
          final keyValuePairs = databasejson.split(', ');
          sistemasList.clear();

          // Recorrer los pares clave-valor y agregarlos a sistemasList
          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim();

            // Evitar agregar la clave "Estatus" a sistemasList
            if (nombre == "Estatus") {
              continue;
            }

            if (nombre != "Usuario" &&
                nombre != "AlarmasDespertador" &&
                nombre != "Hours") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null) {
                sistemasList.add(Sistema(nombre, estado == 1));
              }
            }
          }

          // Limpiar la lista antes de agregar los nuevos sistemas
          sistemasListParaMostrar.clear();

          // Filtrar sistemas y agregarlos a sistemasListParaMostrar
          sistemasListParaMostrar.addAll(
              sistemasList /*.where((sistema) => sistema.nombre != "Armado"),*/
              );
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
            const Padding(
              padding: EdgeInsets.only(top: 110.0, left: 139),
              child: Text(
                'Monitoreo',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 24,
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                ),
              ),
            ),
            Positioned(
              left: 22,
              top: 125,
              child: SizedBox(
                width: 350,
                height: 510,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: sistemasListParaMostrar.length,
                  itemBuilder: (context, index) {
                    final sistema = sistemasListParaMostrar[index];

                    return SistemaUsuario(
                      nombreSistema: sistema.nombre,
                      activo: sistema.estado,
                      icon: Icon(
                        sistemasIcons[sistema.nombre],
                        size: 50,
                        color: const Color(0xFF0F1370),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 650,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _activarBotonPanico();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('ALERTA'),
                            content: Text('Botón de pánico accionado'),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  // Llamar al número de emergencia (911)
                                  launch('tel:911');
                                  Navigator.of(context).pop();
                                },
                                child: Text('Llamar Emergencias'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                onPressed: () {
                                  _detenerBotonPanico();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Detener'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "EMERGENCIA",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espaciador horizontal
                  GestureDetector(
                    onTap: () {
                      _toggleActivacionAlarma();
                    },
                    child: Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _botonColor,
                      ),
                      child: Center(
                        child: Text(
                          _estadoAlarma,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
