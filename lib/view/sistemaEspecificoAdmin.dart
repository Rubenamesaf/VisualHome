import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:login_v1/historial_model.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import '../realtime_db.dart';

class SistemaEspecificoAdmin extends StatefulWidget {
  final String userEmail;
  SistemaEspecificoAdmin({required this.userEmail, Key? key}) : super(key: key);

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
  DateTime? fechaInicio;
  DateTime? fechaFin;

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
        "https://script.google.com/macros/s/AKfycbxQtdC-1mo9kgNQcQrzVHeCkz5y9ar1CrUUTo7alEMVASVzGKhgqPIkEm8kB5ExQBmJ0w/exec");

    var raw = await http.get(url);

    var jsonRegistro = convert.jsonDecode(raw.body);

    jsonRegistro.forEach((elemento) {
      if (elemento['vivienda'] == viviendaName) {
        if (elemento['sistema'] == sistema) {
          HistorialModel historialModel = HistorialModel(
              accion: elemento['accion'],
              marcaTemporal: elemento['marca_temporal'],
              sistema: elemento['sistema'],
              vivienda: elemento['vivienda']);

          setState(() {
            registros.add(historialModel);
          });
        }
      }
    });
  }

  void toggleSwitch(bool value) {
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

  List<HistorialModel> filtrarRegistrosPorFecha() {
    if (fechaInicio == null || fechaFin == null) {
      return registros;
    }

    return registros.where((registro) {
      // Formatea la cadena de fecha al formato esperado (ejemplo: "September 8, 2023 at 08:03PM")
      String formattedDate =
          registro.marcaTemporal.replaceAll(" at ", " "); // Elimina "at"
      DateTime marcaTemporal =
          DateFormat("MMMM d, yyyy h:mma").parse(formattedDate);

      return marcaTemporal.isAfter(fechaInicio!) &&
          marcaTemporal.isBefore(fechaFin!);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            Positioned(
              left: 110,
              top: 135,
              child: SizedBox(
                width: 200,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        4 * fem, 0 * fem, 0 * fem, 20 * fem),
                    padding:
                        EdgeInsets.fromLTRB(0 * fem, 5 * fem, 0 * fem, 0 * fem),
                    width: 329 * fem,
                    height: 330 * fem,
                    decoration: BoxDecoration(
                      color: Color(0xf2fec49a),
                      borderRadius: BorderRadius.circular(0 * fem),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // Espacio entre los botones
                          children: [
                            Text(
                              'Filtrar',
                              style: TextStyle(
                                fontFamily: 'Inria Sans',
                                fontSize: 22 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 0.8636363636 * ffem / fem,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: fechaInicio ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    fechaInicio = selectedDate;
                                  });
                                }
                              },
                              child: Text('Desde'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: fechaFin ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    fechaFin = selectedDate;
                                  });
                                }
                              },
                              child: Text('Hasta'),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceAround, // Espacio entre los botones
                            children: [
                              Text(
                                fechaInicio != null
                                    ? 'Desde: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}'
                                    : 'Desde: N/S',
                                style: TextStyle(
                                  fontFamily: 'Inria Sans',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                fechaFin != null
                                    ? 'Hasta: ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'
                                    : 'Hasta: N/S',
                                style: TextStyle(
                                  fontFamily: 'Inria Sans',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                        Positioned(
                          left: 110,
                          top: 200,
                          child: Container(
                            width: 325,
                            decoration: const ShapeDecoration(
                              color: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filtrarRegistrosPorFecha().length,
                            itemBuilder: (context, index) {
                              final registrosFiltrados =
                                  filtrarRegistrosPorFecha();
                              return Registro(
                                marcaTemporal:
                                    registrosFiltrados[index].marcaTemporal,
                                sistema: registrosFiltrados[index].sistema,
                                accion: registrosFiltrados[index].accion,
                                vivienda: registrosFiltrados[index].vivienda,
                              );
                            },
                          ),
                        ),
                      ],
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
              width: 393 * fem,
              height: 121 * fem,
            ),
          ],
        ),
      ),
    );
  }
}

class Registro extends StatelessWidget {
  final String marcaTemporal, sistema, accion, vivienda;
  Registro(
      {required this.marcaTemporal,
      required this.sistema,
      required this.accion,
      required this.vivienda});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(accion), subtitle: Text("($marcaTemporal)"));
  }
}
