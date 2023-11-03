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
    } catch (e) {
      print("Error loading admin data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 1,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Monitoreo',
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
          if (index == 2) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MonitoreoSistemaUser(
                    userEmail: widget.userEmail, vivienda: widget.vivienda),
              ),
            );
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
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                ),
              ),
            ),
            Container(
              width: 60,
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
            _buildTextFormFields(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24),
              child: _crearBotonGuardar(),
            ),
          ],
        )),
      ),
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
        // Agrega más campos de usuario si es necesario
      },
    };

    try {
      await _dbref.child(widget.vivienda).update(userData);
      // La vivienda se ha guardado en Firebase
      print('Perfil guardado en Firebase');
      print(userData);
      // Puedes redirigir a otra pantalla o realizar otras acciones aquí
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
    } catch (e) {
      // Manejar errores si es necesario
      print('Error al guardar la vivienda en Firebase: $e');
    }
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
              labelText: 'Nombre',
              keyboardType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: 'Clave',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: addressController,
              labelText: 'Direccion',
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
        fontFamily: 'Outfit',
      ),
      keyboardType: keyboardType,
    );
  }
}
