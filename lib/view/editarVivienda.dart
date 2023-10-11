import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/viviendaEsecificaAdmin.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'dart:math';

class Sistema {
  final String nombre;
  final bool estado;

  Sistema(this.nombre, this.estado);
}

List<String> sistemas = [
  "BotonPanico",
  "Perimetro",
  "TelefonoFijo",
  "RuidoAlto",
  "DisparoAlarma",
  "Incendio",
  "Despertador",
  "ActivacionAlarma",
  "Acceso",
  "Timbre"
];

class EditarVivienda extends StatefulWidget {
  final String userEmail;
  EditarVivienda({required this.userEmail, Key? key}) : super(key: key);

  @override
  _EditarViviendaState createState() => _EditarViviendaState();
}

class _EditarViviendaState extends State<EditarVivienda> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  late _SistemasDialog sistemasDialog;

  DatabaseReference _dbref = FirebaseDatabase.instance.reference();

  List<String> datosUsuario = [];
  List<Sistema> sistemasList = [];
  late List<String> sistemasSeleccionados = [];
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
    sistemasList = Get.arguments['sistemasList'];
    _setupDatabaseListener();

    sistemasSeleccionados =
        sistemasList.map((sistema) => sistema.nombre).toList();

    print(sistemasSeleccionados);

    sistemasDialog = _SistemasDialog(
      sistemas: sistemas,
      sistemasSeleccionados: sistemasSeleccionados,
    );
  }

  void _setupDatabaseListener() {
    _dbref.child("$viviendaName").onValue.listen((event) {
      final dynamic data = event.snapshot.value;

      if (data == null) {
        return;
      }

      if (mounted) {
        setState(() {
          nombre = data['Usuario']['Nombre'];
          email = data['Usuario']['Email'];
          clave = data['Usuario']['Password'];
          direccion = data['Usuario']['Direccion'];
        });

        print(nombre);
        print(email);
        print(clave);
        print(direccion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
                      'Editar:    $viviendaName',
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
                  top: 160,
                  child: Container(
                    width: 270,
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
                _buildTextFormFields(),
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
        ),
      ),
    );
  }

  Widget _buildTextFormFields() {
    return Positioned(
      left: 10,
      right: 10,
      top: 200,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTextFormField(
              controller: nombreController,
              labelText: nombre.isNotEmpty ? nombre : 'Nombre',
              keyboardType: TextInputType.name,
            ),
            _buildTextFormField(
              controller: emailController,
              labelText: email.isNotEmpty ? email : 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextFormField(
              controller: passwordController,
              labelText: clave.toString().isNotEmpty ? clave : 'Clave',
              keyboardType: TextInputType.visiblePassword,
            ),
            _buildTextFormField(
              controller: direccionController,
              labelText: direccion.isNotEmpty ? direccion : 'Direccion',
              keyboardType: TextInputType.streetAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: false,
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
              title: Text('Descartando cambios'),
              content: Text('¿Seguro que deseas descartar los cambios?'),
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
        Navigator.of(context).pop();
      },
      label: Text('GUARDAR'),
      icon: Icon(Icons.save),
    );
  }

  Future<void> _mostrarDialogoSistemas(BuildContext context) async {
    // Verificar si el widget está montado antes de mostrar el diálogo
    if (mounted) {
      // Crear una instancia del widget de diálogo de sistemas
      sistemasDialog = sistemasDialog;

      // Mostrar el diálogo y obtener los sistemas seleccionados
      sistemasSeleccionados = await showDialog<List<String>>(
            context: context,
            builder: (BuildContext context) {
              return sistemasDialog;
            },
          ) ??
          [];

      // Aquí puedes utilizar sistemasSeleccionados como lo necesites
      if (sistemasSeleccionados != null) {
        setState(() {
          this.sistemasSeleccionados = sistemasSeleccionados;
        });
        print('Sistemas seleccionados: $sistemasSeleccionados');
      }
    }
  }

  void _guardarViviendaEnFirebase() async {
    final viviendaCode = viviendaName;
    var clienteName = nombreController.text;
    var correo = emailController.text;
    var password = passwordController.text;
    var location = direccionController.text;

    if (clienteName == "") {
      clienteName = nombre;
    }
    if (correo == "") {
      correo = email;
    }
    if (password == "") {
      password = clave;
    }
    if (location == "") {
      location = direccion;
    }

    final viviendaData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': correo,
        'Password': password,
        'Direccion': location,
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
            title: Text('Vivienda Editada Exitosamente'),
            content: Text('La vivienda se ha editado exitosamente.'),
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
  final List<String> sistemasSeleccionados;

  _SistemasDialog(
      {required this.sistemas, required this.sistemasSeleccionados});

  @override
  _SistemasDialogState createState() =>
      _SistemasDialogState(sistemasSeleccionados);
}

class _SistemasDialogState extends State<_SistemasDialog> {
  List<String> sistemasSeleccionados;

  _SistemasDialogState(List<String> sistemasSeleccionados)
      : sistemasSeleccionados = List.from(sistemasSeleccionados);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Lista de Sistemas'),
      content: Container(
        height: 300, // Ajusta la altura del contenido según tus necesidades
        child: SingleChildScrollView(
          child: Column(
            children: widget.sistemas.map((sistema) {
              var isSelected = sistemasSeleccionados.contains(sistema);
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
