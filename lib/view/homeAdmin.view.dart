import 'package:flutter/material.dart';
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

          Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Vivienda 1"),
                ),
              ],
            ),
          ),
          // BOTON AGREGAR
          Positioned(
            left: 50,
            top: 500,
            child: ElevatedButton(
              onPressed: () {
                // ignore: avoid_print
                print('Button pressed ...');
                Get.to(editHomeAdmin());
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 60)),
                padding: MaterialStateProperty.all(
                    const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                backgroundColor:
                    MaterialStateProperty.all(GlobalColors.naranjaFUERTE),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  fontWeight: FontWeight.w600,
                )),
                elevation: MaterialStateProperty.all(10),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'AGREGAR VIVIENDA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 22,
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.86,
                ),
              ),
            ),
          ),
          // FIN BOTON AGREGAR
        ],
      )),
    );
  }
}
