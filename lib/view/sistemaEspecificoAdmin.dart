import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_v1/utils/global.colors.dart';

class sistemaEspecificoAdmin extends StatelessWidget {
  const sistemaEspecificoAdmin({Key? key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x35f4934e),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      37.77 * fem, 8 * fem, 13 * fem, 9.68 * fem),
                  width: double.infinity,
                  height: 89.18 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xbaf19756),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 2 * fem,
                      sigmaY: 2 * fem,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 13.5 * fem, 38.88 * fem, 0 * fem),
                          width: 26.85 * fem,
                          height: 22.48 * fem,
                          child: Image.asset(
                            'assets/page-1/images/bx-arrow-back-1-1vf.png',
                            width: 26.85 * fem,
                            height: 22.48 * fem,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 13.5 * fem, 40.5 * fem, 0 * fem),
                            child: Text(
                              'VisualHome',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inria Sans',
                                fontSize: 35 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 0.5428571429 * ffem / fem,
                                color: Color(0xff0f1370),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 50 * fem,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 2.5 * fem),
                                width: 50 * fem,
                                height: 50 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/undrawprofilepicreiwgo-2.png',
                                  width: 50 * fem,
                                  height: 50 * fem,
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Karla',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Inria Sans',
                                      fontSize: 20 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 0.95 * ffem / fem,
                                      color: Color(0xff0f1370),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      29 * fem, 43.82 * fem, 31 * fem, 104 * fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 19 * fem),
                        width: double.infinity,
                        height: 61 * fem,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0 * fem,
                              top: 0 * fem,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(29.71 * fem,
                                    20.71 * fem, 29.71 * fem, 18.29 * fem),
                                width: 333 * fem,
                                height: 58 * fem,
                                decoration: BoxDecoration(
                                  color: Color(0xe5adbace),
                                  borderRadius:
                                      BorderRadius.circular(100 * fem),
                                ),
                                child: Text(
                                  'Timbre',
                                  style: TextStyle(
                                    fontFamily: 'Inria Sans',
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 0.8636363636 * ffem / fem,
                                    color: Color(0xff0f1370),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 248 * fem,
                              top: 2 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 71 * fem,
                                  height: 59 * fem,
                                  child: Image.asset(
                                    'assets/page-1/images/image-12.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            4 * fem, 0 * fem, 0 * fem, 65 * fem),
                        padding: EdgeInsets.fromLTRB(
                            115.5 * fem, 42.5 * fem, 109.5 * fem, 21.5 * fem),
                        width: 329 * fem,
                        height: 330 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xf2fec49a),
                          borderRadius: BorderRadius.circular(100 * fem),
                        ),
                        child: Center(
                          child: SizedBox(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 104 * fem,
                              ),
                              child: Text(
                                'HISTORIAL',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inria Sans',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 0.8636363636 * ffem / fem,
                                  color: Color(0xff0f1370),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 34 * fem, 0 * fem),
                        child: Text(
                          'DESCARGAR REPORTE',
                          style: TextStyle(
                            fontFamily: 'Inria Sans',
                            fontSize: 22 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 0.8636363636 * ffem / fem,
                            color: Color(0xff0f1370),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 393 * fem,
                  height: 121 * fem,
                  child: Image.asset(
                    'assets/page-1/images/auto-group-xqaw.png',
                    width: 393 * fem,
                    height: 121 * fem,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
