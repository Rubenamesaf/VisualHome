import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';
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
    return GestureDetector(
      child: Scaffold(
        backgroundColor: GlobalColors.narajanOscuroColor,
        body: SafeArea(
          top: true,
          child: Center(
            child: Container(
              width: 439,
              height: 851,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalColors.grayColor,
                    GlobalColors.naranjaClaritoColor,
                    GlobalColors.narajanOscuroColor,
                    //Color(0xFFF29757),
                    GlobalColors.amarilloColor
                  ],
                  stops: const [0, 0, 1, 1],
                  begin: const AlignmentDirectional(-0.34, 1),
                  end: const AlignmentDirectional(0.34, -1),
                ),
                borderRadius: BorderRadius.circular(0),
                shape: BoxShape.rectangle,
              ),
              alignment: const AlignmentDirectional(1, -1),
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0.6),
                    child: ElevatedButton(
                      onPressed: () {
                        // ignore: avoid_print
                        print('Button pressed ...');
                        Get.to(LoginView());
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(325, 72)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                        backgroundColor: MaterialStateProperty.all(
                            GlobalColors.naranjaFUERTE),
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
                        'Iniciar Sección',
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
                  const Align(
                    alignment: AlignmentDirectional(0, 0.3),
                    child: Text(
                      'VisualHome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF163371),
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0.38),
                    child: Text(
                      'Look, feel and read your home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inria Sans',
                          color: GlobalColors.blancoColor,
                          fontWeight: FontWeight.w400,
                          height: 0.95),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
