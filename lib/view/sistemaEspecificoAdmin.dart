import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:flutter/gestures.dart';
import 'dart:ui';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:login_v1/utils/global.colors.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login_v1/historial_model.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import '../realtime_db.dart';

class SistemaEspecificoAdmin extends StatefulWidget {
  const SistemaEspecificoAdmin({Key? key}) : super(key: key);
  @override
  _SistemaEspecificoAdminState createState() => _SistemaEspecificoAdminState();
}

class _SistemaEspecificoAdminState extends State<SistemaEspecificoAdmin> {
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  List<HistorialModel> registros = <HistorialModel>[];
  double baseWidth = 393;
  double fem = 1.0;
  double ffem = 1.0;
  bool isSwitched = false;
  String sistema = '';
  String viviendaName = '';
  bool estado = false;
  int estadoBinario = 0;

  @override
  void initState() {
    getHistorialFromSheet();
    super.initState();
    final Map<String, dynamic> arguments = Get.arguments;
    viviendaName = arguments['viviendaName'];
    sistema = arguments['sistemaName'];
    estado = arguments['estado'];
  }

  _updatevalue() {
    _dbref.child("$viviendaName").update({"$sistema": estadoBinario});
  }

  getHistorialFromSheet() async {
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzVU6b_xI8GbFVsdIFoZzGgnVm5_7ifI6jl3RFnOEtMVQew-MEuj-1gLsv7K-VzSZhg/exec");

    var raw = await http.get(url);

    var jsonRegistro = convert.jsonDecode(raw.body);

    jsonRegistro.forEach((elemento) {
      // Verificar si el sistema es "Timbre"
      if (elemento['sistema'] == sistema) {
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
      estado = value;
      if (estado == true) {
        estadoBinario = 1;
      } else {
        estadoBinario = 0;
      }
    });
    _updatevalue();
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
      backgroundColor: Color(0xFF678ACF),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(),
            Positioned(
              left: 134,
              top: 135,
              child: SizedBox(
                width: 132,
                height: 38,
                child: Text(
                  '$viviendaName',
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
                    height: 200 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0 * fem,
                          top: 135 * fem,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(29.71 * fem,
                                20.71 * fem, 29.71 * fem, 18.29 * fem),
                            width: 333 * fem,
                            height: 58 * fem,
                            decoration: BoxDecoration(
                              color: Color(0xe5adbace),
                              borderRadius: BorderRadius.circular(100 * fem),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$sistema',
                                  style: TextStyle(
                                    fontFamily: 'Inria Sans',
                                    fontSize: 22 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 0.8636363636 * ffem / fem,
                                    color: Color(0xff0f1370),
                                  ),
                                ),
                                Switch(
                                  value: estado,
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
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => realtime_db());
                      },
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
