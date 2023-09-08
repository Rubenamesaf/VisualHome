import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/editHomeAdmin.dart';
import 'package:get/get.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

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
              top: 200, // Ajusta la posición según sea necesario
              child: Container(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 300, // Ajusta la altura según sea necesario
                child: ListView(
                  children: <Widget>[
                    _buildViviendaItem("Vivienda 1"),
                    _buildViviendaItem("Vivienda 2"),
                    _buildViviendaItem("Vivienda 3"),
                    _buildViviendaItem("Vivienda 4"),
                    _buildViviendaItem("Vivienda 5"),
                    _buildViviendaItem("Vivienda 6"),
                    _buildViviendaItem("Vivienda 7"),
                    _buildViviendaItem("Vivienda 8"),
                    _buildViviendaItem("Vivienda 9"),
                    _buildViviendaItem("Vivienda 10"),
                  ],
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
                  color: GlobalColors.logoazulColor,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: GlobalColors.naranjaClaritoColor, // Color de fondo azul
        borderRadius: BorderRadius.circular(30), // Esquinas redondeadas
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          viviendaName,
          style: const TextStyle(
            color: Color(0xFF0F1370), // Color del texto blanco
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
