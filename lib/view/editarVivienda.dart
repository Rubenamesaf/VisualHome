import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/adminPerfil.view.dart';
import 'package:login_v1/view/agregarVivienda.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/viviendaEsecificaAdmin.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class Sistema {
  final String nombre;
  final bool estado;

  Sistema(this.nombre, this.estado);
}

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
  int? currentIndex;

  @override
  void initState() {
    super.initState();
    viviendaName = Get.arguments['viviendaName'];
    sistemasList = Get.arguments['sistemasList'];
    _setupDatabaseListener();

    sistemasSeleccionados =
        sistemasList.map((sistema) => sistema.nombre).toList();

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
      }
    });
  }

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Editar vivienda',
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
          if (index == 0) {}
          if (index == 1) {
            Navigator.pop(context);
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AdminPerfilView(userEmail: widget.userEmail),
              ),
            );
          }
          setState(() {
            currentIndex = index;
          });
        },
      ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              AdminPrincipal(administratorName: widget.userEmail),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 600,
                child: Center(
                  child: Text(
                    'Editar:    $viviendaName',
                    style: const TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 25.0, bottom: 0),
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
              _buildTextFormFields(),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 25.0, bottom: 0),
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
                    top: 15.0, bottom: 1.0, left: 24, right: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {
                    _mostrarDialogoSistemas(context);
                  },
                  child: Text('+   EDITAR MÓDULOS'),
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
        ),
      ),
    );
  }

  Widget _buildTextFormFields() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildTextFormField(
              controller: nombreController,
              labelText: nombre.isNotEmpty ? nombre : 'Nombre',
              keyboardType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildTextFormField(
              controller: emailController,
              labelText: email.isNotEmpty ? email : 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: clave.toString().isNotEmpty ? clave : 'Clave',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: _buildTextFormField(
              controller: direccionController,
              labelText: direccion.isNotEmpty ? direccion : 'Direccion',
              keyboardType: TextInputType.streetAddress,
            ),
          ),
        ],
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
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _crearBotonDescartar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Color.fromARGB(209, 255, 0, 0),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Descartando cambios'),
              content: Text('¿Seguro que deseas descartar los cambios?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Sí'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
        minimumSize: const Size.fromHeight(30),
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
    if (mounted) {
      sistemasDialog = sistemasDialog;

      sistemasSeleccionados = await showDialog<List<String>>(
            context: context,
            builder: (BuildContext context) {
              return sistemasDialog;
            },
          ) ??
          [];

      if (sistemasSeleccionados != null) {
        setState(() {
          this.sistemasSeleccionados = sistemasSeleccionados;
        });
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
      },
    };

    try {
      await _dbref.child(viviendaCode).update(viviendaData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Vivienda Editada Exitosamente'),
            content: Text('La vivienda se ha editado exitosamente.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {}
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
      title: Text('Lista de módulos'),
      content: Container(
        height: 300,
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
