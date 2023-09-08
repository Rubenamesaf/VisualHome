import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login_v1/historial_model.dart';

class SistemaEspecificoAdmin extends StatefulWidget {
  const SistemaEspecificoAdmin({Key? key}) : super(key: key);
  @override
  _SistemaEspecificoAdminState createState() => _SistemaEspecificoAdminState();
}

class _SistemaEspecificoAdminState extends State<SistemaEspecificoAdmin> {
  List<HistorialModel> registros = <HistorialModel>[];
  bool activacionTimbre = false;
  double baseWidth = 393;
  double fem = 1.0;
  double ffem = 1.0;
  bool isSwitched = false;

  getHistorialFromSheet() async {
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzVU6b_xI8GbFVsdIFoZzGgnVm5_7ifI6jl3RFnOEtMVQew-MEuj-1gLsv7K-VzSZhg/exec");

    var raw = await http.get(url);

    var jsonRegistro = convert.jsonDecode(raw.body);

    jsonRegistro.forEach((elemento) {
      // Verificar si el sistema es "Timbre"
      if (elemento['sistema'] == "Timbre") {
        HistorialModel historialModel = HistorialModel(
          accion: elemento['accion'],
          marcaTemporal: elemento['marca_temporal'],
          sistema: elemento['sistema'],
        );

        setState(() {
          registros.add(historialModel);
        });
      }
    });
  }

  void toggleSwitch(bool value) {
    // Implementa la funcionalidad del botón switch aquí
    setState(() {
      activacionTimbre = value;
    });
  }

  @override
  void initState() {
    getHistorialFromSheet();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
  }

  @override
  Widget build(BuildContext context) {
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
                    imageFilter: ImageFilter.blur(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 13.5 * fem, 38.88 * fem, 0 * fem),
                          width: 26.85 * fem,
                          height: 22.48 * fem,
                          /*child: Image.asset(
                            'assets/page-1/images/bx-arrow-back-1-1vf.png',
                            width: 26.85 * fem,
                            height: 22.48 * fem,
                          ),*/
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
                                /*child: Image.asset(
                                  'assets/images/undraw_profile_pic.svg',
                                  width: 50 * fem,
                                  height: 50 * fem,
                                ),*/
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Timbre",
                                      style: TextStyle(
                                        fontFamily: 'Inria Sans',
                                        fontSize: 22 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 0.8636363636 * ffem / fem,
                                        color: Color(0xff0f1370),
                                      ),
                                    ),
                                    Switch(
                                      value: activacionTimbre,
                                      onChanged: toggleSwitch,
                                    ),
                                  ],
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
                                  /*child: Image.asset(
                                    'assets/page-1/images/image-12.png',
                                    fit: BoxFit.cover,
                                  ),*/
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            4 * fem, 0 * fem, 0 * fem, 20 * fem),
                        padding: EdgeInsets.fromLTRB(
                            60 * fem, 0 * fem, 0 * fem, 0 * fem),
                        width: 329 * fem,
                        height: 330 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xf2fec49a),
                          borderRadius: BorderRadius.circular(75 * fem),
                        ),
                        child: ListView.builder(
                          itemCount: registros.length,
                          itemBuilder: (context, index) {
                            return Registro(
                              marcaTemporal: registros[index].marcaTemporal,
                              sistema: registros[index].sistema,
                              accion: registros[index].accion,
                            );
                          },
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
                  // autogroupxqawTdR (WdexbrtJVE15SBV4C3xqaw)
                  width: 393 * fem,
                  height: 121 * fem,
                  /*child: Image.asset(
                    'assets/page-1/images/auto-group-xqaw.png',
                    width: 393 * fem,
                    height: 121 * fem,
                  ),*/
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*void main() {
  runApp(MaterialApp(
    home: SistemaEspecificoAdmin(),
  ));
}*/

class Registro extends StatelessWidget {
  final String marcaTemporal, sistema, accion;
  Registro(
      {required this.marcaTemporal,
      required this.sistema,
      required this.accion});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(accion),
      subtitle: Text("($marcaTemporal)"),
    );
  }
}
