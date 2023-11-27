import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/usuario/homeUser.view.dart';

import '../utils/global.colors.dart';
import 'agregarVivienda.dart';
import 'viviendaEsecificaAdmin.dart';
import 'widgets/admin_principal.dart';

class HomeAdminPage extends StatefulWidget {
  final String userEmail;
  HomeAdminPage({required this.userEmail, Key? key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  List<String> viviendas = [];
  dynamic databasejson;
  String adminName = "";

  @override
  void initState() {
    super.initState();
    viviendas.clear();
    _leerViviendas();
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _leerViviendas() async {
    _dbref.child("").once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        final dynamic data = dataSnapshot.value;
        if (data is Map<Object?, Object?>) {
          viviendas.clear();
          data.forEach((key, value) {
            if (key is String && key != "Administradores") {
              if (value is Map<Object?, Object?> &&
                  value.containsKey("Estatus") &&
                  value["Estatus"] == 1) {
                viviendas.add(key);
              }
            }
            if (key == "Administradores") {}
          });
          setState(() {});
        }
      }
    });
  }

  void _setupDatabaseListener() {
    _dbref.child("").onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null && mounted) {
        setState(() {
          Map<Object?, Object?> values =
              dataSnapshot.value as Map<Object?, Object?>;
          viviendas.clear();

          values.forEach((key, value) {
            if (key != "Administradores") {
              viviendas.add(key.toString());
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_home_work),
            label: 'Agregar Vivienda',
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
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AgregarVivienda(userEmail: widget.userEmail),
              ),
            );
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
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(
                administratorName: widget.userEmail, pageName: 'home'),
            const Positioned(
              left: 134,
              top: 135,
              child: SizedBox(
                width: 132,
                height: 38,
                child: Text(
                  'VIVIENDAS',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    height: 0.76,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: 180,
              child: Container(
                width: 285,
                height: deviceheight * 0.7,
                child: ListView.builder(
                  itemCount: viviendas.length,
                  itemBuilder: (context, index) {
                    return _buildViviendaItem(viviendas[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViviendaItem(String viviendaName) {
    return InkWell(
      onTap: () {
        if (viviendaName != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViviendaEspecificaAdmin(
                userEmail: widget.userEmail,
              ),
              settings: RouteSettings(
                arguments: viviendaName,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xbaf19756),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            viviendaName,
            style: const TextStyle(
              color: Color(0xFF0F1370),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class GlobalColors {
  static const azulColor = Color(0xFF0000FF);
  static const naranjaClaritoColor = Color(0xFFFFD700);
}
