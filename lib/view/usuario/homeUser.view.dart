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

  void _detenerAlarmas() {
    // Actualizar el valor en la base de datos
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
        setState(() {
          databasejson = dataSnapshot.value.toString();
          databasejson = databasejson.substring(1, databasejson.length - 1);
          final keyValuePairs = databasejson.split(', ');
          oldSistemasList.clear();
          oldSistemasList.addAll(sistemasListParaMostrar);
          sistemasList.clear();

          // Flag to check if any of the specified systems is active
          bool isEmergencyActive = false;
          bool isAlarmaAlert = false;

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
                if (nombre != "CodigoPIN") {
                  sistemasList.add(Sistema(nombre, estado == 1));

                  // Check if the current system is one of the specified systems
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

          // Show the emergency dialog if any of the specified systems is active
          if (isEmergencyActive) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ALERTA'),
                  content: Text('Detector de $activeSystemName disparado.'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding:
                                  EdgeInsets.all(16.0), // Ajusta el padding
                            ),
                            onPressed: () {
                              // Llamar al número de emergencia (911)
                              launch('tel:911');
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Llamar Emergencias',
                              style: TextStyle(
                                  fontSize: 16.0), // Ajusta el tamaño del texto
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 16.0), // Ajusta el espacio entre los botones
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding:
                                  EdgeInsets.all(16.0), // Ajusta el padding
                            ),
                            onPressed: () {
                              _detenerBotonPanico();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Detener',
                              style: TextStyle(
                                  fontSize: 16.0), // Ajusta el tamaño del texto
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
          if (isAlarmaAlert) {
            DateTime horaActual = DateTime.now(); // Obtén la hora actual

            showDialog(
              context: context,
              barrierDismissible: false, // Evita que se cierre al tocar fuera
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ALARMA'),
                  content: Text('${horaActual.hour}:${horaActual.minute}'),
                  actions: [
                    Container(
                      width: double
                          .infinity, // Hace que el botón ocupe todo el ancho
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 129, 28, 1),
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0), // Ajusta el padding vertical
                        ),
                        onPressed: () {
                          _detenerAlarmas();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'DETENER',
                          style: TextStyle(
                              fontSize: 18.0), // Ajusta el tamaño del texto
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          // Limpiar la lista antes de agregar los nuevos sistemas
          sistemasListParaMostrar.clear();

          // Filtrar sistemas y agregarlos a sistemasListParaMostrar
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
    // Verificar si el nombre del sistema requiere botones adicionales
    List<AndroidNotificationAction>? actions;
    /*if (nombreSistema == "Pánico" ||
        nombreSistema == "Movimiento" ||
        nombreSistema == "Incendio" ||
        nombreSistema == "Perímetro") {
      // Agregar botones si es uno de los sistemas especificados
      actions = [
        AndroidNotificationAction(
          'action_emergency',
          'Llamar Emergencias',
        ),
        AndroidNotificationAction(
          'action_stop',
          'Detener',
        ),
      ];
    }*/

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
      payload: nombreSistema, // Agregar el nombre del sistema como carga útil
    );
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
              padding: EdgeInsets.only(top: 105.0, left: 139),
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
              left: 45,
              top: 110,
              child: SizedBox(
                width: 300,
                height: 430,
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
              left: 10,
              top: 560,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _activarBotonPanico();
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
