import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

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

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
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
                    AdminPerfilView(userEmail: widget.userEmail),
              ),
            );
          }
          if (index == 1) {
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
      //   /*
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => const SplashView(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => const SplashView(),
      //         ),
      //       );
      //     }
      //   },
      //   */
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'NUEVA VIVIENDA',
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 24,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.9,
                    ),
                  ),
                ),

                Container(
                  width: 190,
                  decoration: const ShapeDecoration(
                    color: GlobalColors.azulColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.50,
                        color: GlobalColors.azulColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                        controller: nombreController,
                        labelText: 'Nombre',
                        keyboardType: TextInputType.name,
                      ),
                      // TextFormField(
                      //   controller: nombreController,
                      //   obscureText: false,
                      //   decoration: InputDecoration(
                      //     labelText: 'Nombre',
                      //     hintText: 'Nombre del cliente',
                      //     hintStyle: const TextStyle(
                      //       fontFamily: 'Outfit',
                      //       color: Color(0x9AFFFFFF),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: const BorderSide(
                      //         color: GlobalColors.amarilloColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.moradoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     filled: true,
                      //     fillColor: const Color.fromARGB(126, 103, 138, 207),
                      //     prefixIcon: const Icon(
                      //       Icons.abc,
                      //       color: GlobalColors.logoazulColor,
                      //     ),
                      //   ),
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.normal,
                      //     color: GlobalColors.textColor,
                      //     fontFamily: 'Outfit',
                      //   ),
                      //   keyboardType: TextInputType.name,
                      // ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 10, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                        controller: emailController,
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      // TextFormField(
                      //   controller: emailController,
                      //   obscureText: false,
                      //   decoration: InputDecoration(
                      //     labelText: 'Email Address',
                      //     hintText: 'Correo del cliente',
                      //     hintStyle: const TextStyle(
                      //       fontFamily: 'Outfit',
                      //       color: Color(0x9AFFFFFF),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: const BorderSide(
                      //         color: GlobalColors.amarilloColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.moradoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     filled: true,
                      //     fillColor: const Color.fromARGB(126, 103, 138, 207),
                      //     prefixIcon: const Icon(
                      //       Icons.email_outlined,
                      //       color: GlobalColors.logoazulColor,
                      //     ),
                      //   ),
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.normal,
                      //     color: GlobalColors.textColor,
                      //     fontFamily: 'Outfit',
                      //   ),
                      //   keyboardType: TextInputType.emailAddress,
                      // ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 10, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                          controller: passwordController,
                          labelText: 'Password',
                          keyboardType: TextInputType.number),
                      // TextFormField(
                      //   controller: passwordController,
                      //   obscureText: false,
                      //   decoration: InputDecoration(
                      //     labelText: 'Password',
                      //     hintText: 'Código de acceso',
                      //     hintStyle: const TextStyle(
                      //       fontFamily: 'Outfit',
                      //       color: Color(0x9AFFFFFF),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: const BorderSide(
                      //         color: GlobalColors.amarilloColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.moradoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     filled: true,
                      //     fillColor: const Color.fromARGB(126, 103, 138, 207),
                      //     prefixIcon: const Icon(
                      //       Icons.password,
                      //       color: GlobalColors.logoazulColor,
                      //     ),
                      //   ),
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.normal,
                      //     color: GlobalColors.textColor,
                      //     fontFamily: 'Outfit',
                      //   ),
                      //   keyboardType: TextInputType.visiblePassword,
                      // ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 10, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildTextFormField(
                          controller: direccionController,
                          labelText: 'Address',
                          keyboardType: TextInputType.text),
                      // TextFormField(
                      //   controller: direccionController,
                      //   obscureText: false,
                      //   decoration: InputDecoration(
                      //     labelText: 'Address',
                      //     hintText: 'Dirección de la vivienda',
                      //     hintStyle: TextStyle(
                      //       fontFamily: 'Outfit',
                      //       color: Color(0x9AFFFFFF),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.amarilloColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.blancoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: GlobalColors.moradoColor,
                      //         width: 1,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     filled: true,
                      //     fillColor: Color(0x7D678ACF),
                      //     prefixIcon: Icon(
                      //       Icons.home,
                      //       color: Color(0xFF0F1370),
                      //     ),
                      //   ),
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.normal,
                      //     color: GlobalColors.textColor,
                      //     fontFamily: 'Outfit',
                      //   ),
                      //   keyboardType: TextInputType.streetAddress,
                      // ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 5.0, left: 24, right: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    onPressed: () {
                      _mostrarDialogoSistemas(context);
                    },
                    child: Text('+ AGREGAR SISTEMAS'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24),
                  child: _crearBotonGuardar(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24),
                  child: _crearBotonDescartar(),
                ),

                // Botón "Agregar Sistemas"
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
        minimumSize: const Size.fromHeight(40), //
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
      label: Text('CANCLAR'),
      icon: Icon(Icons.cancel),
    );
  }

  Widget _crearBotonGuardar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40), //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Color.fromARGB(209, 15, 179, 0),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        _guardarViviendaEnFirebase();
        Navigator.of(context).pop();
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
        fontFamily: 'Outfit',
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

    if (clienteName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        direccion.isEmpty) {
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
      content: Container(
        height: 300, // Ajusta la altura del contenido según tus necesidades
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
            Navigator.of(context).pop(sistemasSeleccionados);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
