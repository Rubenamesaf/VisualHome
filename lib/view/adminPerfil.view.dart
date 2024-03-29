import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/agregarVivienda.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPerfilView extends StatefulWidget {
  final String userEmail;
  const AdminPerfilView({required this.userEmail, Key? key}) : super(key: key);

  @override
  State<AdminPerfilView> createState() => _AdminPerfilViewState();
}

class _AdminPerfilViewState extends State<AdminPerfilView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late DatabaseReference _dbref;

  var nombre = '';
  var email = '';
  var direccion = '';
  var clave = '';
  var admin = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();

    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        final adminSnapshot = await _dbref
            .child("Administradores")
            .orderByChild("Email")
            .equalTo(user.email)
            .once();

        if (adminSnapshot.snapshot.value != null) {
          final dynamic data = adminSnapshot.snapshot.value;

          data.forEach((key, value) {
            admin = key;
          });

          final adminData = (adminSnapshot.snapshot.value as Map).values.first;
          setState(() {
            nombreController.text = adminData['Nombre'];
            emailController.text = adminData['Email'];
            passwordController.text = adminData['Clave'].toString();
          });
        }
      }
    } catch (e) {}
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
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
        fontFamily: 'Raleway',
      ),
      keyboardType: keyboardType,
    );
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
              labelText: 'Nombre y apellido del administrador',
              keyboardType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: emailController,
              labelText: 'Correo electrónico del administrador',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: 'Código PIN de acceso a la app',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
        ],
      ),
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
        _guardarPerfilEnFirebase();
      },
      label: Text('GUARDAR'),
      icon: Icon(Icons.save),
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

  void _guardarPerfilEnFirebase() async {
    var clienteName = nombreController.text;
    var correo = emailController.text;
    var password = passwordController.text;

    if (clienteName == "") {
      clienteName = nombre;
    }
    if (correo == "") {
      correo = email;
    }
    if (password == "") {
      password = clave;
    }

    final adminData = <String, dynamic>{
      admin: {
        'Nombre': clienteName,
        'Email': correo,
        'Clave': password,
      },
    };

    try {
      await _dbref.child("Administradores").set(adminData);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 2,
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
          if (index == 0) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AgregarVivienda(userEmail: widget.userEmail),
              ),
            );
          }
          if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
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
                  fontFamily: 'Raleway',
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
                  'Datos del administrador:',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 17,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    height: 0.9,
                  ),
                ),
              ),
            ),
            _buildTextFormFields(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24),
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
}
