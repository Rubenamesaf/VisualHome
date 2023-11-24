import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class Sistema {
  final String nombre;
  final bool estado;

  Sistema(this.nombre, this.estado);
}

List<String> sistemas = ['Timbre', 'Puerta', 'Alarma', 'Acceso', 'Pánico'];

class EditarVivienda extends StatefulWidget {
  final String userEmail;
  EditarVivienda({required this.userEmail, Key? key}) : super(key: key);

  @override
  _AgregarViviendaState createState() => _AgregarViviendaState();
}

class _AgregarViviendaState extends State<EditarVivienda> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();

  List<String> datosUsuario = [];
  List<Sistema> sistemasList = [];
  String databasejson = "";
  String viviendaName = "";
  var nombre = '';
  var email = '';
  var direccion = '';
  var clave = '';

  @override
  void initState() {
    super.initState();
    viviendaName = Get.arguments['viviendaName'];

    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _dbref.child("$viviendaName").onValue.listen((event) {
      final dynamic data = event.snapshot.value;

      if (data == null) {
        return;
      }

      setState(() {
        nombre = data['Usuario']['Nombre'];
        email = data['Usuario']['Email'];
        clave = data['Usuario']['Password'];
        direccion = data['Usuario']['Direccion'];
      });
    });
  }

  var contador;

  List<String> sistemasSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
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
                  'EDITAR: $viviendaName',
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
                        labelText: nombre,
                        hintText: nombre,
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
                        labelText: email,
                        hintText: email,
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
                        labelText: clave.toString(),
                        hintText: clave.toString(),
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
                        labelText: direccion,
                        hintText: direccion,
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
            Positioned(
              left: 40,
              top: 490,
              width: 310,
              child: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoSistemas(context);
                },
                child: Text('+   EDITAR SISTEMAS'),
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
      onPressed: () {},
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
    final sistemasDialog = _SistemasDialog(sistemas: sistemas);

    final List<String>? sistemasSeleccionados = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return sistemasDialog;
      },
    );

    if (sistemasSeleccionados != null) {
      setState(() {
        this.sistemasSeleccionados = sistemasSeleccionados;
      });
    }
  }

  void _guardarViviendaEnFirebase() async {
    final viviendaCode = viviendaName;
    final clienteName = nombreController.text;
    final correo = emailController.text;
    final password = passwordController.text;
    final location = direccionController.text;

    if (clienteName == "") {
      final clienteName = nombre;
    }
    if (email == "") {
      final correo = email;
    }
    if (password == "") {
      final password = clave;
    }
    if (direccion == "") {
      final location = direccion;
    }

    final viviendaData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': correo,
        'Password': password,
        'Direccion': location,
      },
    };

    for (String sistema in sistemasSeleccionados) {
      viviendaData[sistema] = 0;
    }

    try {
      await _dbref.child(viviendaCode).set(viviendaData);
    } catch (e) {}
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
                  } else {
                    sistemasSeleccionados.add(sistema);
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
            Navigator.of(context).pop(sistemasSeleccionados);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
