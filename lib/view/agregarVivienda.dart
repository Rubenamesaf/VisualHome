import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(219, 233, 100, 6),
        color: const Color.fromARGB(255, 252, 176, 122),
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_sharp, color: Color(0xFF0F1370)),
              Text(
                'Perfil',
                style: customTextStyle,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Color(0xFF0F1370)),
              Text(
                'Cerrar Sesión',
                style: customTextStyle,
              ),
            ],
          ),
        ],
        /*
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SplashView(),
              ),
            );
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SplashView(),
              ),
            );
          }
        },
        */
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                AdminPrincipal(administratorName: widget.userEmail),
                Positioned(
                  left: 130,
                  top: 120,
                  child: SizedBox(
                    width: 600,
                    height: 380,
                    child: Text(
                      'NUEVA VIVIENDA',
                      style: TextStyle(
                        color: Color(0xFF0F1370),
                        fontSize: 17,
                        fontFamily: 'Inria Sans',
                        fontWeight: FontWeight.w700,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 128,
                  top: 140,
                  child: Container(
                    width: 140,
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
                const Positioned(
                  left: 40,
                  top: 165,
                  child: SizedBox(
                    width: 600,
                    height: 380,
                    child: Text(
                      'INGRESAR DATOS DE USUARIO',
                      style: TextStyle(
                        color: Color(0xFF0F1370),
                        fontSize: 17,
                        fontFamily: 'Inria Sans',
                        fontWeight: FontWeight.w700,
                        height: 0.9,
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