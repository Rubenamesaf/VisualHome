import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'dart:math';

List<String> sistemas = [
  'Timbre',
  'RuidoAlto',
  'Incendio',
  'DisparoAlarma',
  'BotonPanico',
  'TelefonoFijo',
  'Despertador',
  'Perimetro',
  'Acceso',
  'ActivacionAlarma',
  'PresenciaPuerta'
];

class AgregarVivienda extends StatefulWidget {
  final String userEmail;
  AgregarVivienda({required this.userEmail, Key? key}) : super(key: key);

  @override
  _AgregarViviendaState createState() => _AgregarViviendaState();
}

class _AgregarViviendaState extends State<AgregarVivienda> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();

  var contador = 3;
  List<String> viviendas = [];
  var cantidadViviendas;
  @override
  void initState() {
    super.initState();
  }

  String generarCodigoAleatorio() {
    final random = Random();
    const caracteresPermitidos = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final codigo = List.generate(4, (index) {
      final randomIndex = random.nextInt(caracteresPermitidos.length);
      return caracteresPermitidos[randomIndex];
    }).join('');
    return codigo;
  }

  List<String> sistemasSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.azulColor,
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),

            Positioned(
              left: 40,
              top: 135,
              child: SizedBox(
                width: 600,
                height: 380,
                child: Text(
                  'NUEVA VIVIENDA',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.9,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 170,
              child: Container(
                width: 200,
                decoration: ShapeDecoration(
                  color: GlobalColors.azulColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      color: GlobalColors.azulColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 200,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Nombre del cliente',
                        hintStyle: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0x9AFFFFFF),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.amarilloColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.moradoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(126, 103, 138, 207),
                        prefixIcon: Icon(
                          Icons.abc,
                          color: GlobalColors.logoazulColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: GlobalColors.textColor,
                        fontFamily: 'Outfit',
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 270,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Correo del cliente',
                        hintStyle: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0x9AFFFFFF),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.amarilloColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.moradoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(126, 103, 138, 207),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: GlobalColors.logoazulColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: GlobalColors.textColor,
                        fontFamily: 'Outfit',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 340,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: passwordController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Código de acceso',
                        hintStyle: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0x9AFFFFFF),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.amarilloColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.moradoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(126, 103, 138, 207),
                        prefixIcon: Icon(
                          Icons.password,
                          color: GlobalColors.logoazulColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: GlobalColors.textColor,
                        fontFamily: 'Outfit',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 410,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: direccionController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Dirección de la vivienda',
                        hintStyle: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0x9AFFFFFF),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.amarilloColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.blancoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: GlobalColors.moradoColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color(0x7D678ACF),
                        prefixIcon: Icon(
                          Icons.home,
                          color: Color(0xFF0F1370),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: GlobalColors.textColor,
                        fontFamily: 'Outfit',
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 595,
              width: 310,
              child: _crearBotonDescartar(),
            ),
            Positioned(
              left: 40,
              top: 550,
              width: 310,
              child: _crearBotonGuardar(),
            ),
            // Botón "Agregar Sistemas"
            Positioned(
              left: 40,
              top: 490,
              width: 310,
              child: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoSistemas(context);
                },
                child: Text('+   AGREGAR SISTEMAS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearBotonDescartar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Color.fromARGB(209, 255, 0, 0),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        print('DESCARTANDO CREACION');
      },
      label: Text('DESCARTAR'),
      icon: Icon(Icons.cancel),
    );
  }

  Widget _crearBotonGuardar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Color.fromARGB(209, 15, 179, 0),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        _guardarViviendaEnFirebase();
      },
      label: Text('GUARDAR'),
      icon: Icon(Icons.save),
    );
  }

  Future<void> _mostrarDialogoSistemas(BuildContext context) async {
    // Crear una instancia del widget de diálogo de sistemas
    final sistemasDialog = _SistemasDialog(sistemas: sistemas);

    // Mostrar el diálogo y obtener los sistemas seleccionados
    final List<String>? sistemasSeleccionados = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return sistemasDialog;
      },
    );

    // Aquí puedes utilizar sistemasSeleccionados como lo necesites
    if (sistemasSeleccionados != null) {
      setState(() {
        this.sistemasSeleccionados = sistemasSeleccionados;
      });
      print('Sistemas seleccionados: $sistemasSeleccionados');
    }
  }

  void _guardarViviendaEnFirebase() async {
    String code = generarCodigoAleatorio();
    final viviendaCode = "Vivienda $code";
    final clienteName = nombreController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final direccion = direccionController.text;

    if (clienteName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        direccion.isEmpty) {
      print("ESTA VACIO, NO HAY MONSTRUOS AQUI");
      return;
    }

    final viviendaData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': email,
        'Password': password,
        'Direccion': direccion,
        // Agrega más campos de usuario si es necesario
      },
    };

    for (String sistema in sistemasSeleccionados) {
      viviendaData[sistema] = 0;
    }

    try {
      await _dbref.child(viviendaCode).set(viviendaData);
      // La vivienda se ha guardado en Firebase
      print('Vivienda guardada en Firebase');
      print(viviendaData);
      // Puedes redirigir a otra pantalla o realizar otras acciones aquí
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al guardar la vivienda en Firebase: $e');
    }
  }
}

class _SistemasDialog extends StatefulWidget {
  final List<String> sistemas;

  _SistemasDialog({required this.sistemas});

  @override
  _SistemasDialogState createState() => _SistemasDialogState();
}

class _SistemasDialogState extends State<_SistemasDialog> {
  List<String> sistemasSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Lista de Sistemas'),
      content: Column(
        children: widget.sistemas.map((sistema) {
          final isSelected = sistemasSeleccionados.contains(sistema);
          return ListTile(
            title: Text(sistema),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    sistemasSeleccionados.remove(sistema);
                    print("CANCELANDO SISTEMA DE $sistema");
                    print(sistemasSeleccionados);
                  } else {
                    sistemasSeleccionados.add(sistema);
                    print("AGREGANDO SISTEMA DE $sistema");
                    print(sistemasSeleccionados);
                  }
                });
              },
              child: Text(isSelected ? 'Cancelar' : 'Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.red : null,
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
                sistemasSeleccionados); // Devuelve los sistemas seleccionados
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
