import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/viviendaEsecificaAdmin.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/editHomeAdmin.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  List<String> viviendas = [];

  @override
  void initState() {
    super.initState();
    _leerViviendas();
  }

  void _leerViviendas() {
    _dbref.child("").once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        final dynamic data = dataSnapshot.value;
        if (data is Map<Object?, Object?>) {
          viviendas.clear();
          data.forEach((key, value) {
            if (key is String) {
              viviendas.add(key);
            }
          });
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.azulColor,
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(),
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
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.76,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 128,
              top: 160,
              child: Container(
                width: 134,
                decoration: const ShapeDecoration(
                  color: GlobalColors.azulColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: GlobalColors.azulColor,
                    ),
                  ),
                ),
              ),
            ),

            // Lista de Viviendas
            Positioned(
              left: 50,
              top: 180, // Ajusta la posición según sea necesario
              child: Container(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 350, // Ajusta la altura según sea necesario
                child: ListView.builder(
                  itemCount: viviendas.length,
                  itemBuilder: (context, index) {
                    return _buildViviendaItem(viviendas[index]);
                  },
                ),
              ),
            ),
            // TEXTO AGREGAR VIVIENDA
            const Positioned(
              left: 50,
              top: 600,
              child: Text(
                'AGREGAR VIVIENDA',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 22,
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.86,
                ),
              ),
            ),
            Positioned(
              left: 274,
              top: 570,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF0F1370),
                ),
                iconSize: 50,
                onPressed: () {
                  print('IconButton pressed ...');
                  Get.to(editHomeAdmin());
                },
              ),
            ),
            // FIN TEXTO AGREGAR VIVIENDA
          ],
        ),
      ),
    );
  }

  Widget _buildViviendaItem(String viviendaName) {
    return InkWell(
      onTap: () {
        // Navegar a la página deseada cuando se presione una vivienda
        Get.to(() => ViviendaEspecificaAdmin(), arguments: viviendaName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xbaf19756), // Color de fondo azul
          borderRadius: BorderRadius.circular(30), // Esquinas redondeadas
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            viviendaName,
            style: const TextStyle(
              color: Color(0xFF0F1370), // Color del texto blanco
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
  static const azulColor =
      Color(0xFF0000FF); // Cambia este color según tus preferencias
  static const naranjaClaritoColor =
      Color(0xFFFFD700); // Cambia este color según tus preferencias
}
