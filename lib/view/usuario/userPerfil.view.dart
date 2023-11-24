import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/agregarVivienda.dart';
import 'package:login_v1/view/usuario/alarmaUser.view.dart';
import 'package:login_v1/view/usuario/monitoreoSistemaUser.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class UserPerfilPage extends StatefulWidget {
  final String userEmail;
  final String vivienda;
  const UserPerfilPage(
      {required this.userEmail, required this.vivienda, super.key});

  @override
  State<UserPerfilPage> createState() => _UserPerfilPageState();
}

class _UserPerfilPageState extends State<UserPerfilPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late DatabaseReference _dbref;

  var nombre = '';
  var email = '';
  var address = '';
  var clave = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userSnapshot = await _dbref
            .child(widget.vivienda)
            .orderByChild("Email")
            .equalTo(user.email)
            .once();

        if (userSnapshot.snapshot.value != null) {
          final userData = (userSnapshot.snapshot.value as Map).values.first;
          setState(() {
            nombreController.text = userData['Nombre'];
            emailController.text = userData['Email'];
            passwordController.text = userData['Password'].toString();
            addressController.text = userData['Direccion'].toString();
          });
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Perfil',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlarmaUserPage(
                    userEmail: widget.userEmail, vivienda: widget.vivienda),
              ),
            );
          }
          if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Perfil',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 0.9,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24),
              child: Column(
                children: [
                  _crearBotonGuardar(),
                  _crearBotonDescartar(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _crearBotonDescartar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
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
              title: Text('Confirmar descarte'),
              content: Text(
                  '¿Seguro que deseas descartar los cambios en el perfil?'),
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
        minimumSize: const Size.fromHeight(40),
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

  void _guardarViviendaEnFirebase() async {
    var clienteName = nombreController.text;
    var correo = emailController.text;
    var password = passwordController.text;
    var direccion = addressController.text;

    if (clienteName == "") {
      clienteName = nombre;
    }
    if (correo == "") {
      correo = email;
    }
    if (password == "") {
      password = clave;
    }
    if (direccion == "") {
      direccion = address;
    }

    final userData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': correo,
        'Password': password,
        'Direccion': direccion,
      },
    };

    try {
      await _dbref.child(widget.vivienda).update(userData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Perfil Editado Exitosamente'),
            content: Text('El perfil se ha editado exitosamente.'),
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

  Widget _buildTextFormFields() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: nombreController,
              labelText: 'Nombre y apellido del habitante',
              keyboardType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: emailController,
              labelText: 'Correo electrónico de habitante',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: 'Código de acceso a la vivienda',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: addressController,
              labelText: 'Dirección de la vivienda',
              keyboardType: TextInputType.visiblePassword,
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
}
