import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/models/alarma_model.dart';
import 'package:login_v1/view/usuario/userPerfil.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/registroAlarma.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlarmaUserPage extends StatefulWidget {
  final String userEmail;
  final String vivienda;
  const AlarmaUserPage(
      {required this.userEmail, required this.vivienda, super.key});

  @override
  State<AlarmaUserPage> createState() => _AlarmaUserPageState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void showAlarmMessage() async {
  print('Alarma de 10 segundos.');
  //await FirebaseMessaging.instance.
}

class _AlarmaUserPageState extends State<AlarmaUserPage> {
  TextEditingController _timeController = TextEditingController();
  DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  final _localNotifications = FlutterLocalNotificationsPlugin();
  List<AlarmaModel> alarmas = [];
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _setupDatabaseListener();
  }

  void _setAlarm(Duration duration) {
    Timer(duration, () {
      try {
        _dbref.child(widget.vivienda).update({"Alarmas": 1});
      } catch (e) {
        print("Error al actualizar el valor en Firebase: $e");
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );

        DateTime endTime = DateTime.now();

        // Calcula el tiempo hasta disparar la alarma
        Duration duration = _selectedTime.difference(endTime);

        // Funcion que pone la alarma
        _setAlarm(duration);

        _timeController.text = picked.format(context);

        print(_selectedTime);
        print(_timeController.text);
      });

      final alarmaData = <String, dynamic>{
        'Time': _timeController.text,
        'Hours': _selectedTime.hour,
        'Minutes': _selectedTime.minute,
        'Active': true,
        // Agrega más campos de usuario si es necesario
      };

      try {
        await _dbref
            .child(widget.vivienda)
            .child("AlarmasDespertador")
            .push()
            .set(alarmaData);
      } catch (e) {
        print(e);
      }
    }
  }

  void _setupDatabaseListener() {
    _dbref.child(widget.vivienda).child("AlarmasDespertador").onValue.listen(
      (event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null && mounted) {
          setState(
            () {
              Map<Object?, Object?> values =
                  dataSnapshot.value as Map<Object?, Object?>;
              alarmas.clear();

              values.forEach(
                (key, value) {
                  if (key != "Administradores") {
                    Map<Object?, dynamic> nestedValues =
                        value as Map<Object?, dynamic>;

                    alarmas.add(AlarmaModel(
                        id: key.toString(),
                        active: nestedValues['Active'],
                        hours: nestedValues['Hours'],
                        minutes: nestedValues['Minutes'],
                        time: nestedValues['Time']));
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  void toggleSwitch(bool value, String id) {
    try {
      _dbref
          .child(widget.vivienda)
          .child("AlarmasDespertador")
          .child(id)
          .update({"Active": value});
    } catch (e) {
      print("Error al actualizar el valor en Firebase: $e");
    }
  }

  void borrarAlarma(String id) {
    try {
      if (alarmas.length == 1) {
        alarmas.clear();
      }
      _dbref
          .child(widget.vivienda)
          .child("AlarmasDespertador")
          .child(id)
          .remove();
    } catch (e) {
      print("Error al actualizar el valor en Firebase: $e");
    }
  }

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );

  void _showNotification() async {
    await _localNotifications.show(
      1,
      "Test notification",
      'Hello world',
      NotificationDetails(
        android: AndroidNotificationDetails(
            _androidChannel.id, _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: 'ic_launcher'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectTime(context);
          //_setAlarm();
          // _showNotification();
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 0,
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
          if (index == 1) {
            Navigator.pop(context);
          }
          if (index == 2) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserPerfilPage(
                  userEmail: widget.userEmail,
                  vivienda: widget.vivienda,
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
                administratorName: widget.userEmail, pageName: 'alarma'),
            const Positioned(
              left: 150,
              top: 135,
              child: SizedBox(
                width: 132,
                height: 38,
                child: Text(
                  'Alarmas',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.76,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 25,
              top: 170, // Ajusta la posición según sea necesario
              child: SizedBox(
                width: 340, // Ajusta el ancho de acuerdo a tu diseño
                height: 480, // Ajusta la altura según sea necesario
                child: ListView.builder(
                  itemCount: alarmas.length,
                  itemBuilder: (context, index) {
                    return RegistroAlarma(
                      textoHora: alarmas[index].time,
                      switchAlarma: Switch(
                        value: alarmas[index].active,
                        onChanged: (_) {
                          setState(() {
                            print(_);
                            alarmas[index].active = _;
                          });
                          toggleSwitch(_, alarmas[index].id);
                        },
                      ),
                      botonEliminar: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (() {
                          setState(() {
                            borrarAlarma(alarmas[index].id);
                          });
                        }),
                      ),
                    );
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
