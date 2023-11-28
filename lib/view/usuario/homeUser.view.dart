import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/view/editAdminInfo.dart';
import 'package:login_v1/view/usuario/alarmaUser.view.dart';
import 'package:login_v1/view/usuario/userPerfil.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/sistemaUsuario.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

Map<String, IconData> sistemasIcons = {
  'Timbre': Icons.doorbell,
  'Ruido': Icons.speaker,
  'Incendio': Icons.local_fire_department,
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
  List<Sistema> oldSistemasList = [];
  int iterator = 0;
  String vivienda = "";
  String databasejson = "";
  late DatabaseReference _dbref;
  List<Sistema> sistemasListParaMostrar = [];
  final _localNotifications = FlutterLocalNotificationsPlugin();
  Color _botonColor = const Color.fromARGB(255, 110, 112, 114);
  String _estadoAlarma = "           ARMAR\nSistema de seguridad";
  String activeSystemName = "";
  bool llamadaEmergenciaEnCurso = false;

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
        if (key is String &&
            key != "Administradores" &&
            key != "AlarmasDespertador") {
          if (value["Usuario"]["Email"] == widget.userEmail) {
            vivienda = key;
          }
        }
      });
    }
    _setupDatabaseListener();
  }

  void _activarBotonPanico() {
    _dbref.child(vivienda).update({"Pánico": 1});
  }

  void _detenerBotonPanico() {
    _dbref.child(vivienda).update({"Pánico": 0});
    _dbref.child(vivienda).update({"Movimiento": 0});
    _dbref.child(vivienda).update({"Perímetro": 0});
    _dbref.child(vivienda).update({"Incendio": 0});
  }

  void _detenerAlarmas() {
    _dbref.child(vivienda).update({"Alarmas": 0});
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

        setState(() {
          _botonColor = (activacionAlarma == 0)
              ? Colors.green
              : const Color.fromARGB(255, 110, 112, 114);

          _estadoAlarma = (activacionAlarma == 0)
              ? "        DESARMAR\nSistema de seguridad"
              : "           ARMAR\nSistema de seguridad";
        });

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
        setState(() {
          databasejson = dataSnapshot.value.toString();
          databasejson = databasejson.substring(1, databasejson.length - 1);
          final keyValuePairs = databasejson.split(', ');
          oldSistemasList.clear();
          oldSistemasList.addAll(sistemasListParaMostrar);
          sistemasList.clear();

          bool isEmergencyActive = false;
          bool isAlarmaAlert = false;

          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim();

            if (nombre == "Estatus") {
              continue;
            }
            if (nombre == "CodigoPIN") {
              continue;
            }
            if (nombre == "CodigoVerificador") {
              continue;
            }

            if (nombre != "Usuario" &&
                nombre != "AlarmasDespertador" &&
                nombre != "Hours") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null) {
                if (nombre != "CodigoPIN") {
                  sistemasList.add(Sistema(nombre, estado == 1));

                  if (nombre == 'Pánico' ||
                      nombre == 'Movimiento' ||
                      nombre == 'Perímetro' ||
                      nombre == 'Incendio') {
                    if (estado == 1) {
                      activeSystemName = nombre;
                      isEmergencyActive = true;
                    }
                  }
                  if (nombre == 'Alarmas') {
                    if (estado == 1) {
                      activeSystemName = nombre;
                      isAlarmaAlert = true;
                    }
                  }
                }
              }
            }
          }

          if (isEmergencyActive) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ALERTA'),
                  content: Text('Detector de $activeSystemName disparado.'),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        launch('tel:911');
                        llamadaEmergenciaEnCurso = true;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ALERTA'),
                              content: Text(
                                  'Detector de $activeSystemName disparado.'),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
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
                                    llamadaEmergenciaEnCurso = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Detener'),
                                ),
                              ],
                            );
                          },
                        );
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
          }

          if (isAlarmaAlert) {
            DateTime horaActual = DateTime.now();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ALARMA'),
                  content: Text(
                      'Disparo de alarma programada a la(s) ${horaActual.hour}:${horaActual.minute}'),
                  actions: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 129, 28, 1),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          _detenerAlarmas();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'DETENER',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          sistemasListParaMostrar.clear();

          sistemasListParaMostrar.addAll(
            sistemasList,
          );

          if (oldSistemasList.isNotEmpty) {
            for (int i = 0; i < sistemasListParaMostrar.length; i++) {
              if (oldSistemasList[i].estado !=
                      sistemasListParaMostrar[i].estado &&
                  oldSistemasList[i].estado == false) {
                _showNotification(sistemasListParaMostrar[i].nombre);
              }
            }
          }
        });
      }
    });
  }

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );

  void _showNotification(String nombreSistema) async {
    List<AndroidNotificationAction>? actions;

    await _localNotifications.show(
      10,
      "Módulo de $nombreSistema",
      "Disparado",
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: 'ic_launcher',
          actions: actions,
        ),
      ),
      payload: nombreSistema,
    );
    llamadaEmergenciaEnCurso = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // La aplicación se reanuda, verifica si hay una llamada de emergencia en curso
      if (!llamadaEmergenciaEnCurso) {
        // No hay llamada de emergencia en curso, muestra la alerta
        _setupDatabaseListener();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;

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
            label: 'Inicio',
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
              padding: EdgeInsets.only(top: 105.0, left: 139),
              child: Text(
                'Monitoreo',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 110,
              child: SizedBox(
                width: 300,
                height: deviceheight * 0.7,
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
                        size: 40,
                        color: const Color(0xFF0F1370),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 560,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _activarBotonPanico();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "EMERGENCIA",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _toggleActivacionAlarma();
                    },
                    child: Container(
                      width: 160,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _botonColor,
                      ),
                      child: Center(
                        child: Text(
                          _estadoAlarma,
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
