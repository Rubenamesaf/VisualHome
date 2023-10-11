import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
//import 'dart:ui';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:login_v1/historial_model%20copy.dart';
//import 'package:login_v1/models/vivienda_model.dart';
import 'package:login_v1/utils/global.colors.dart';
//import 'package:login_v1/utils/botongenerico.dart';
import 'package:login_v1/view/editarVivienda.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
//import 'package:login_v1/view/editHomeAdmin.dart';
import 'package:login_v1/view/sistemaEspecificoAdmin.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:login_v1/view/editHomeAdmin.dart';
//import 'package:login_v1/view/sistemaEspecificoAdmin.dart';
//import 'dart:convert'; // Importar la librería para decodificar JSON

class ViviendaEspecificaAdmin extends StatefulWidget {
  final String userEmail;
  ViviendaEspecificaAdmin({required this.userEmail, Key? key})
      : super(key: key);
  @override
  _ViviendaEspecificaAdminState createState() =>
      _ViviendaEspecificaAdminState();
}

class _ViviendaEspecificaAdminState extends State<ViviendaEspecificaAdmin> {
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  List<Sistema> sistemasList = [];
  String databasejson = "";
  String viviendaName = "";

  @override
  void initState() {
    super.initState();
    viviendaName = Get.arguments;
    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _dbref.child("$viviendaName").onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
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

            if (nombre != "Usuario") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null) {
                sistemasList.add(Sistema(nombre, estado == 1));
              }
            }
          }
        });
        print(sistemasList);
      }
    });
  }

  RichText buildRichText(bool isActive) {
    final TextStyle defaultStyle = TextStyle(
      color: Color.fromARGB(
          255, 255, 0, 0), // Color por defecto para sistemas inactivos
      fontWeight:
          FontWeight.normal, // Estilo por defecto para sistemas inactivos
    );

    final TextStyle activeStyle = TextStyle(
      color: Colors.green, // Color verde para sistemas activos
      fontWeight: FontWeight.bold, // Texto en negrita para sistemas activos
    );

    final text = isActive ? 'Activo' : 'Inactivo';

    return RichText(
      text: TextSpan(
        text: text,
        style: isActive ? activeStyle : defaultStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(219, 233, 100, 6),
        color: const Color.fromARGB(255, 252, 176, 122),
        animationDuration: const Duration(milliseconds: 300),
        index: 1,
        items: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_home_work, color: Color(0xFF0F1370)),
              Text(
                'Agregar Vivienda',
                style: customTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_sharp, color: Color(0xFF0F1370)),
              Text(
                'Perfil',
                style: customTextStyle,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Color(0xFF0F1370)),
              Text(
                'Cerrar Sesión',
                style: customTextStyle,
              ),
            ],
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            final arguments = {
              'viviendaName': viviendaName,
              'sistemasList': sistemasList,
            };
            print('Botón presionado ...');
            Get.to(() => EditarVivienda(userEmail: widget.userEmail),
                arguments: arguments);
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SplashView(),
              ),
            );
          }
        },
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            Positioned(
              left: 110,
              top: 135,
              child: SizedBox(
                width: 200,
                height: 38,
                child: Text(
                  '$viviendaName',
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
              left: 110,
              top: 160,
              child: Container(
                width: 170,
                decoration: const ShapeDecoration(
                  color: GlobalColors.azulColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFF678ACF),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: 180,
              child: Container(
                width: 285,
                height: 400,
                child: ListView.builder(
                  itemCount: sistemasList.length,
                  itemBuilder: (context, index) {
                    final sistema = sistemasList[index];
                    // Define un mapa con los argumentos que deseas pasar
                    final arguments = {
                      'viviendaName': viviendaName,
                      'sistemaName': sistema.nombre,
                      'estado': sistema
                          .estado // Agrega más argumentos si es necesario
                    };
                    return ListTile(
                      title: Text(sistema.nombre),
                      subtitle: buildRichText(sistema.estado),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Get.to(
                              () => SistemaEspecificoAdmin(
                                  userEmail: widget.userEmail),
                              arguments: arguments);
                        },
                        child: Text('Editar'),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 90,
              top: 585,
              child: ElevatedButton.icon(
                onPressed: () {
                  final arguments = {
                    'viviendaName': viviendaName,
                    'sistemasList': sistemasList,
                  };
                  print('Botón presionado ...');
                  Get.to(() => EditarVivienda(userEmail: widget.userEmail),
                      arguments: arguments);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 18, 145, 24), // Fondo azul
                  onPrimary: Colors.white, // Texto en blanco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white, // Icono en blanco
                ),
                label: Text(
                  'EDITAR VIVIENDA',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.bold,
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
