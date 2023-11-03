import 'dart:convert' as convert;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:login_v1/historial_model.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/agregarVivienda.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class SistemaEspecificoAdmin extends StatefulWidget {
  final String userEmail;
  final String sistema;
  SistemaEspecificoAdmin(
      {required this.userEmail, required this.sistema, Key? key})
      : super(key: key);

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
  String nombre = '';
  String viviendaName = '';
  bool estado = false;
  int estadoBinario = 0;
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    nombre = widget.sistema;
    final Map<String, dynamic>? arguments =
        Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      viviendaName = arguments['viviendaName'];
      estado = arguments['estado'];
    }

    getHistorialFromSheet();
  }

  getHistorialFromSheet() async {
    try {
      var url = Uri.parse(
          "https://script.google.com/macros/s/AKfycbxx7A2ALz1liRPDHG0EMtD5IAS7PROdURmW7hvRh8nRV-j3CLfBbKpoLVNNyX_qxjER/exec");

      var raw = await http.get(url);

      var jsonRegistro = convert.jsonDecode(raw.body);

      jsonRegistro.forEach((elemento) {
        var marcaTemporal = elemento['marca_temporal'];
        var proveedor = elemento['proveedor'];
        var vivienda = elemento['vivienda'];
        var sistema = elemento['sistema'];
        var accion = elemento['accion'];

        HistorialModel historialModel = HistorialModel(
            accion: accion,
            marcaTemporal: marcaTemporal,
            sistema: sistema,
            vivienda: vivienda,
            proveedor: proveedor);

        if (mounted) {
          setState(() {
            registros.add(historialModel);
          });
        }
      });
      print(registros);
    } catch (e) {
      print("Error al obtener historial: $e");
    }
  }

  void toggleSwitch(bool value) {
    // Actualiza el estado local antes de realizar operaciones asíncronas
    setState(() {
      estado = value;
      estadoBinario = estado ? 1 : 0;
    });

    // Actualiza el valor en Firebase
    _updateValue();
  }

  _updateValue() {
    try {
      var sistem = widget.sistema;
      _dbref.child("$viviendaName").update({"$sistem": estadoBinario});
    } catch (e) {
      print("Error al actualizar el valor en Firebase: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
  }

  List<HistorialModel> filtrarRegistrosPorFechaYSistema() {
    if (fechaInicio == null || fechaFin == null) {
      return registros
          .where((registro) =>
              registro.sistema == widget.sistema &&
              _quitarEspacios(registro.vivienda) ==
                  _quitarEspacios(viviendaName))
          .toList();
      print(registros);
    }

    return registros.where((registro) {
      // Formatea la cadena de fecha al formato esperado (ejemplo: "September 8, 2023 at 08:03PM")
      String formattedDate =
          registro.marcaTemporal.replaceAll(" at ", " "); // Elimina "at"
      DateTime marcaTemporal =
          DateFormat("MMMM d, yyyy h:mma").parse(formattedDate);

      return marcaTemporal.isAfter(fechaInicio!) &&
          marcaTemporal.isBefore(fechaFin!) &&
          registro.sistema == widget.sistema &&
          _quitarEspacios(registro.vivienda) == _quitarEspacios(viviendaName);
    }).toList();
  }

  String _quitarEspacios(String texto) {
    return texto.replaceAll(" ", "");
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _descargarReporte() async {
    try {
      // Filtra los registros que se están mostrando en pantalla
      List<HistorialModel> registrosFiltrados =
          filtrarRegistrosPorFechaYSistema();

      // Verifica si hay registros para descargar
      if (registrosFiltrados.isEmpty) {
        print("No hay registros para descargar");
        return;
      }

      // Crea el contenido del archivo CSV o TXT
      String contenido = "Marca Temporal,Proveedor,Vivienda,Sistema,Accion\n";
      for (var registro in registrosFiltrados) {
        contenido +=
            "${registro.marcaTemporal},${registro.proveedor},${registro.vivienda},${registro.sistema},${registro.accion}\n";
      }

      // Obtiene el directorio de documentos del dispositivo
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Crea el archivo con la fecha actual como nombre
      String fechaActual = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
      String filePath = '${documentsDirectory.path}/reporte_$fechaActual.csv';

      // Escribe el contenido en el archivo
      File file = File(filePath);
      await file.writeAsString(contenido);

      print("Reporte descargado en: $filePath");
    } catch (e) {
      print("Error al descargar el reporte: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 0,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AgregarVivienda(userEmail: widget.userEmail),
              ),
            );
          }
          if (index == 2) {
            await _signOut(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SplashView(),
              ),
            );
          }
        },
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: const Color.fromARGB(219, 233, 100, 6),
      //   color: const Color.fromARGB(255, 252, 176, 122),
      //   items: const <Widget>[
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.account_circle_sharp, color: Color(0xFF0F1370)),
      //         Text(
      //           'Perfil',
      //           style: customTextStyle,
      //         ),
      //       ],
      //     ),
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.logout, color: Color(0xFF0F1370)),
      //         Text(
      //           'Cerrar Sesión',
      //           style: customTextStyle,
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: Center(
        child: Column(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            // Positioned(
            //   left: 110,
            //   top: 135,
            //   child: SizedBox(
            //     width: 200,
            //     height: 38,
            //     child: Text(
            //       '$viviendaName',
            //       style: TextStyle(
            //         color: Color(0xFF0F1370),
            //         fontSize: 25,
            //         fontFamily: 'Inria Sans',
            //         fontWeight: FontWeight.w700,
            //         height: 0.76,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.only(top: 35),
              width: double.infinity,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100 * fem,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(29.71 * fem,
                                  20.71 * fem, 29.71 * fem, 18.29 * fem),
                              width: 333 * fem,
                              height: 58 * fem,
                              decoration: BoxDecoration(
                                color: const Color(0xe5adbace),
                                borderRadius: BorderRadius.circular(100 * fem),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    nombre,
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

                            // Positioned(
                            //   left: 0 * fem,
                            //   top: 135 * fem,
                            //   child: Container(
                            //     padding: EdgeInsets.fromLTRB(29.71 * fem,
                            //         20.71 * fem, 29.71 * fem, 18.29 * fem),
                            //     width: 333 * fem,
                            //     height: 58 * fem,
                            //     decoration: BoxDecoration(
                            //       color: Color(0xe5adbace),
                            //       borderRadius:
                            //           BorderRadius.circular(100 * fem),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text(
                            //           '$sistema',
                            //           style: TextStyle(
                            //             fontFamily: 'Inria Sans',
                            //             fontSize: 22 * ffem,
                            //             fontWeight: FontWeight.w700,
                            //             height: 0.8636363636 * ffem / fem,
                            //             color: Color(0xff0f1370),
                            //           ),
                            //         ),
                            //         Switch(
                            //           value: estado,
                            //           onChanged: toggleSwitch,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   left: 248 * fem,
                            //   top: 2 * fem,
                            //   child: Align(
                            //     child: SizedBox(
                            //       width: 71 * fem,
                            //       height: 59 * fem,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            4 * fem, 0 * fem, 0 * fem, 20 * fem),
                        padding: EdgeInsets.fromLTRB(
                            0 * fem, 5 * fem, 0 * fem, 0 * fem),
                        width: 329 * fem,
                        height: 330 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xf2fec49a),
                          borderRadius: BorderRadius.circular(0 * fem),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      initialDate:
                                          fechaInicio ?? DateTime.now(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                            Container(
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
                            // Positioned(
                            //   left: 110,
                            //   top: 200,
                            //   child: Container(
                            //     width: 325,
                            //     decoration: const ShapeDecoration(
                            //       color: Color.fromARGB(255, 0, 0, 0),
                            //       shape: RoundedRectangleBorder(
                            //         side: BorderSide(
                            //           width: 1.50,
                            //           strokeAlign:
                            //               BorderSide.strokeAlignCenter,
                            //           color: Color.fromARGB(255, 0, 0, 0),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    filtrarRegistrosPorFechaYSistema().length,
                                itemBuilder: (context, index) {
                                  final registrosFiltrados =
                                      filtrarRegistrosPorFechaYSistema();
                                  return Registro(
                                    marcaTemporal:
                                        registrosFiltrados[index].marcaTemporal,
                                    sistema: registrosFiltrados[index].sistema,
                                    accion: registrosFiltrados[index].accion,
                                    vivienda:
                                        registrosFiltrados[index].vivienda,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 33.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40), // NEW
                          ),
                          onPressed: _descargarReporte,
                          child: const Text(
                            'DESCARGAR REPORTE',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
