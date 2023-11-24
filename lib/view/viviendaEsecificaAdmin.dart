import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/main.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/agregarVivienda.dart';
import 'package:login_v1/view/editarVivienda.dart';
import 'package:login_v1/view/sistemaEspecificoAdmin.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

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
        setState(() {
          databasejson = dataSnapshot.value.toString();

          databasejson = databasejson.substring(1, databasejson.length - 1);

          final keyValuePairs = databasejson.split(', ');

          sistemasList.clear();

          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim();

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
                }
              }
            }
          }
        });
      }
    });
  }

  RichText buildRichText(bool isActive) {
    const TextStyle defaultStyle = TextStyle(
      color: Color.fromARGB(255, 255, 0, 0),
      fontWeight: FontWeight.normal,
    );

    const TextStyle activeStyle = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
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
    double deviceheight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: viviendaName,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {}
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
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              AdminPrincipal(administratorName: widget.userEmail),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 200,
                height: 20,
                child: Text(
                  '$viviendaName',
                  style: const TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 0.76,
                  ),
                ),
              ),
              Container(
                width: 285,
                height: deviceheight * 0.6,
                child: ListView.builder(
                  itemCount: sistemasList.length,
                  itemBuilder: (context, index) {
                    final sistema = sistemasList[index];

                    final arguments = {
                      'viviendaName': viviendaName,
                      'sistemaName': sistema.nombre,
                      'estado': sistema.estado
                    };
                    return ListTile(
                      title: Text(sistema.nombre),
                      subtitle: buildRichText(sistema.estado),
                      trailing: ElevatedButton(
                        onPressed: () {
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
              ElevatedButton.icon(
                onPressed: () {
                  final arguments = {
                    'viviendaName': viviendaName,
                    'sistemasList': sistemasList,
                  };

                  Get.to(() => EditarVivienda(userEmail: widget.userEmail),
                      arguments: arguments);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 18, 145, 24),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                label: Text(
                  'EDITAR VIVIENDA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
