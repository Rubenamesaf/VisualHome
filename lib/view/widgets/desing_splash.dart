import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:provider/provider.dart';
//import 'dart:async';
import 'package:get/get.dart';
import 'package:login_v1/view/login.view.dart';
//import 'package:login_v1/view/widgets/button.global.dart';

class DesingSplashContainer extends StatelessWidget {
  const DesingSplashContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.narajanOscuroColor,
      body: Container(
        width: 439,
        height: 851,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(160, 103, 138, 207),
              HexColor('#ee8133'),
              const Color.fromARGB(240, 230, 154, 100),
              const Color(0xD1FBE288),
            ],
            stops: const [0.19, 0.25, 0.8, 0.9],
            begin: const AlignmentDirectional(-1.0, 1.0),
            end: const AlignmentDirectional(1.0, -1.0),
          ),
          borderRadius: BorderRadius.circular(0),
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          children: [
            Align(
              child: SvgPicture.asset('assets/images/VisualHome.svg'),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.2),
              child: Text(
                'Un sentido más...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Inria Sans',
                    color: GlobalColors.blancoColor,
                    fontWeight: FontWeight.w400,
                    height: 0.95),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.5),
              child: ElevatedButton(
                onPressed: () {
                  // ignore: avoid_print
                  print('Button pressed ...');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(240, 230, 154, 100)),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 20,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.95,
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
