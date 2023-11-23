import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

List<String> sistemas = [
  'Timbre',
  'Ruido',
  'Incendio',
  'Movimiento',
  'Pánico',
  'Teléfono',
  'Alarmas',
  'Perímetro',
  'Acceso',
  'Armado',
  'Visitantes',
  'Estatus'
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
  DatabaseReference _dbref = FirebaseDatabase.instance.ref();

  var contador = 3;
  List<String> viviendas = [];
  var cantidadViviendas;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    passwordController.dispose();
    direccionController.dispose();
    super.dispose();
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

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 0,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_home_work),
            label: 'Agregar Vivienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            Navigator.pop(context);
          }
          if (index == 2) {
            await _signOut(context);
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AdminPerfilView(userEmail: widget.userEmail),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'NUEVA VIVIENDA',
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 0.9,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0,
                      left: 25.0,
                      bottom:
                          0), // Ajusta el valor izquierdo según sea necesario
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Datos del habitante:',
                      style: TextStyle(
                        color: Color(0xFF0F1370),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                        controller: nombreController,
                        labelText: 'Nombre y apellido',
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                        controller: emailController,
                        labelText: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                          controller: passwordController,
                          labelText: 'Código de acceso a la vivienda',
                          keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                          controller: direccionController,
                          labelText: 'Dirección de la vivienda',
                          keyboardType: TextInputType.text),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 15.0,
                      left: 25.0,
                      bottom:
                          0), // Ajusta el valor izquierdo según sea necesario
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Módulos de la vivienda:',
                      style: TextStyle(
                        color: Color(0xFF0F1370),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 10.0, left: 24, right: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    onPressed: () {
                      _mostrarDialogoSistemas(context);
                    },
                    child: Text('+ AGREGAR MÓDULOS'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1.0, horizontal: 24),
                  child: _crearBotonGuardar(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1.0, horizontal: 24),
                  child: _crearBotonDescartar(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearBotonDescartar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(30), //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Color.fromARGB(209, 255, 0, 0),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        // Muestra un cuadro de diálogo de confirmación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar cancelacion'),
              content: Text(
                  '¿Seguro que deseas cancelar la creación de esta vivienda?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                    Navigator.of(context).pop(); // Regresa a la página anterior
                  },
                  child: Text('Sí'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                    // Puedes agregar aquí cualquier acción adicional
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
      },
      label: Text('CANCELAR'),
      icon: Icon(Icons.cancel),
    );
  }

  Widget _crearBotonGuardar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(30), //
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: labelText == 'Password' ? true : false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText,
      ),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: GlobalColors.textColor,
      ),
      keyboardType: keyboardType,
    );
  }

  void _guardarViviendaEnFirebase() async {
    String code = generarCodigoAleatorio();
    final viviendaCode = "Vivienda $code";
    final clienteName = nombreController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final direccion = direccionController.text;
    final codigoPin = "123456";

    if (clienteName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        direccion.isEmpty ||
        codigoPin.isEmpty) {
      // Muestra un cuadro de diálogo informando que los campos están vacíos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campos Vacíos'),
            content:
                Text('Por favor, completa todos los campos antes de guardar.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro informativo
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return; // Sale de la función si los campos están vacíos
    }

    if (password.length != 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contraseña muy corta'),
            content: Text('Por favor, poner una clave de 6 digitos.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro informativo
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final viviendaData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': email,
        'Password': password,
        'Direccion': direccion,
        'CodigoPIN': codigoPin,
        'CodigoVerificador': '',
        // Agrega más campos de usuario si es necesario
      },
    };

    for (String sistema in sistemasSeleccionados) {
      viviendaData[sistema] = 0;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: codigoPin,
      );
      await _dbref.child(viviendaCode).set(viviendaData);
      await _dbref.child(viviendaCode).update({"Estatus": 1});
      // La vivienda se ha guardado en Firebase
      print('Vivienda guardada en Firebase');
      print(viviendaData);

      // Puedes redirigir a otra pantalla o realizar otras acciones aquí
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Vivienda Guardada Exitosamente'),
            content: Text('La vivienda se ha guardado exitosamente.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro informativo
                  // Puedes agregar aquí cualquier acción adicional
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Manejar errores si es necesario
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Este correo ya existe'),
                content:
                    Text('Este correo ya esta registrado en una vivienda.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Cierra el cuadro informativo
                      // Puedes agregar aquí cualquier acción adicional
                    },
                    child: Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }
      }
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
      title: Text('Lista de módulos'),
      content: Container(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
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
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Si "Estatus" no está en la lista, agrégalo con valor 1
            if (!sistemasSeleccionados.contains("Estatus")) {
              sistemasSeleccionados.add("Estatus");
            }
            // Devuelve la lista actualizada
            Navigator.of(context).pop(sistemasSeleccionados);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
