import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/main.dart';
//import 'package:get/get_core/src/get_main.dart';
//import 'dart:ui';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:login_v1/historial_model%20copy.dart';
//import 'package:login_v1/models/vivienda_model.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/agregarVivienda.dart';
//import 'package:login_v1/utils/botongenerico.dart';
import 'package:login_v1/view/editarVivienda.dart';
//import 'package:login_v1/view/editHomeAdmin.dart';
import 'package:login_v1/view/sistemaEspecificoAdmin.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
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
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
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
        print(sistemasList);
      }
    });
  }

  RichText buildRichText(bool isActive) {
    const TextStyle defaultStyle = TextStyle(
      color: Color.fromARGB(
          255, 255, 0, 0), // Color por defecto para sistemas inactivos
      fontWeight:
          FontWeight.normal, // Estilo por defecto para sistemas inactivos
    );

    const TextStyle activeStyle = TextStyle(
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

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 2,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_home_work),
            label: 'Agregar Vivienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AgregarVivienda(userEmail: widget.userEmail),
              ),
            );
          }
          if (index == 1) {
            Navigator.pop(context);
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AdminPerfilView(userEmail: widget.userEmail),
              ),
            );
          }
        },
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: const Color.fromARGB(219, 233, 100, 6),
      //   color: const Color.fromARGB(255, 252, 176, 122),
      //   animationDuration: const Duration(milliseconds: 300),
      //   index: 1,
      //   items: const <Widget>[
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.add_home_work, color: Color(0xFF0F1370)),
      //         Text(
      //           'Agregar Vivienda',
      //           style: customTextStyle,
      //           textAlign: TextAlign.center,
      //         ),
      //       ],
      //     ),
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.account_circle_sharp, color: Color(0xFF0F1370)),
      //         Text(
      //           'Perfil',
      //           style: customTextStyle,
      //         ),
      //       ],
      //     ),
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.logout, color: Color(0xFF0F1370)),
      //         Text(
      //           'Cerrar Sesión',
      //           style: customTextStyle,
      //         ),
      //       ],
      //     ),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {
      //       final arguments = {
      //         'viviendaName': viviendaName,
      //         'sistemasList': sistemasList,
      //       };
      //       print('Botón presionado ...');
      //       Get.to(() => EditarVivienda(userEmail: widget.userEmail),
      //           arguments: arguments);
      //     }
      //     if (index == 2) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => const SplashView(),
      //         ),
      //       );
      //     }
      //   },
      // ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: Center(
        child: Column(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 200,
              height: 38,
              child: Text(
                '$viviendaName',
                style: const TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 25,
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.76,
                ),
              ),
            ),
            // Positioned(
            //   left: 110,
            //   top: 135,
            //   child: SizedBox(
            //     width: 200,
            //     height: 38,
            //     child: Text(
            //       '$viviendaName',
            //       style: TextStyle(
            //         color: Color(0xFF0F1370),
            //         fontSize: 25,
            //         fontFamily: 'Inria Sans',
            //         fontWeight: FontWeight.w700,
            //         height: 0.76,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
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
            // Positioned(
            //   left: 110,
            //   top: 160,
            //   child: Container(
            //     width: 170,
            //     decoration: const ShapeDecoration(
            //       color: GlobalColors.azulColor,
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(
            //           width: 1.50,
            //           strokeAlign: BorderSide.strokeAlignCenter,
            //           color: Color(0xFF678ACF),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              width: 285,
              height: 470,
              child: ListView.builder(
                itemCount: sistemasList.length,
                itemBuilder: (context, index) {
                  final sistema = sistemasList[index];
                  // Define un mapa con los argumentos que deseas pasar
                  final arguments = {
                    'viviendaName': viviendaName,
                    'sistemaName': sistema.nombre,
                    'estado':
                        sistema.estado // Agrega más argumentos si es necesario
                  };
                  return ListTile(
                    title: Text(sistema.nombre),
                    subtitle: buildRichText(sistema.estado),
                    trailing: ElevatedButton(
                      onPressed: () {
                        /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SistemaEspecificoAdmin(
                                userEmail: widget.userEmail,
                                sistema: sistema.nombre)
                          ),
                        );*/
                        Get.to(
                            () => SistemaEspecificoAdmin(
                                sistema: sistema.nombre,
                                userEmail: widget.userEmail),
                            arguments: arguments);
                      },
                      child: Text('Editar'),
                    ),
                  );
                },
              ),
            ),
            // Positioned(
            //   left: 50,
            //   top: 180,
            //   child: Container(
            //     width: 285,
            //     height: 400,
            //     child: ListView.builder(
            //       itemCount: sistemasList.length,
            //       itemBuilder: (context, index) {
            //         final sistema = sistemasList[index];
            //         // Define un mapa con los argumentos que deseas pasar
            //         final arguments = {
            //           'viviendaName': viviendaName,
            //           'sistemaName': sistema.nombre,
            //           'estado': sistema.estado // Agrega más argumentos si es necesario
            //         };
            //         return ListTile(
            //           title: Text(sistema.nombre),
            //           subtitle: buildRichText(sistema.estado),
            //           trailing: ElevatedButton(
            //             onPressed: () {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(
            //                   builder: (context) => SistemaEspecificoAdmin(userEmail: widget.userEmail),
            //                 ),
            //               );
            //               // Get.to(
            //               //     () => SistemaEspecificoAdmin(
            //               //         userEmail: widget.userEmail),
            //               //     arguments: arguments);
            //             },
            //             child: Text('Editar'),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            ElevatedButton.icon(
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
            // Positioned(
            //   left: 90,
            //   top: 585,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       final arguments = {
            //         'viviendaName': viviendaName,
            //         'sistemasList': sistemasList,
            //       };
            //       print('Botón presionado ...');
            //       Get.to(() => EditarVivienda(userEmail: widget.userEmail), arguments: arguments);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       primary: Color.fromARGB(255, 18, 145, 24), // Fondo azul
            //       onPrimary: Colors.white, // Texto en blanco
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //     icon: Icon(
            //       Icons.add_circle_outline,
            //       color: Colors.white, // Icono en blanco
            //     ),
            //     label: Text(
            //       'EDITAR VIVIENDA',
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontFamily: 'Inria Sans',
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
