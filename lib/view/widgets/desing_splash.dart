import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DesingSplashContainer extends StatelessWidget {
  const DesingSplashContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: GlobalColors.moradoColor,
        body: SafeArea(
          top: true,
          child: Center(
            child: Container(
              width: 439,
              height: 851,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalColors.moradoColor,
                    GlobalColors.azulColor,
                    GlobalColors.narajanOscuroColor,
                    //Color(0xFFF29757),
                    GlobalColors.amarilloColor
                  ],
                  stops: [0, 0, 1, 1],
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
                        print('Button pressed ...');
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 40)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                        backgroundColor: MaterialStateProperty.all(
                            GlobalColors.naranjaColor),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                        elevation: MaterialStateProperty.all(3),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      child: const Text('Welcome'),
                    ),
                  ),
                  const Align(
                    alignment: AlignmentDirectional(0, 0.4),
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
                    alignment: const AlignmentDirectional(0, 0.45),
                    child: Text(
                      'Look, feel and read your home',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: GlobalColors.moradoColor,
                        fontWeight: FontWeight.w500,
                      ),
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
