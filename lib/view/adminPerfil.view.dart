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
  //final TextEditingController direccionController = TextEditingController();
  late DatabaseReference _dbref;

  var nombre = '';
  var email = '';
  var direccion = '';
  var clave = '';
  var admin = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.reference();

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

        // Verifica si adminSnapshot.snapshot.value es null antes de acceder a 'values'
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
            // Asumo que también tienes un campo 'Direccion' en tu base de datos
            //direccionController.text = adminData['Direccion'];
          });
        }
      }
    } catch (e) {
      print("Error loading admin data: $e");
    }
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
        fontFamily: 'Outfit',
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
              //labelText: nombre.isNotEmpty ? nombre : 'Nombre',
              labelText: 'Nombre',
              keyboardType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: emailController,
              //labelText: email.isNotEmpty ? email : 'Email',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              // labelText: clave.toString().isNotEmpty ? clave : 'Clave',
              labelText: 'Clave',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: direccionController,
              // labelText: direccion.isNotEmpty ? direccion : 'Direccion',
              labelText: 'Direccion',
              keyboardType: TextInputType.streetAddress,
            ),
          ),*/
        ],
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

    if (clienteName == "") {
      clienteName = nombre;
    }
    if (correo == "") {
      correo = email;
    }
    if (password == "") {
      password = clave;
    }

    final viviendaData = <String, dynamic>{
      'Usuario': {
        'Nombre': clienteName,
        'Email': correo,
        'Password': password,
        // Agrega más campos de usuario si es necesario
      },
    };

    try {
      final adminSnapshot = await _dbref
          .child("Administradores")
          .orderByChild("Email")
          .equalTo(correo);

      await _dbref.child("Administradores/" + admin).set(viviendaData);
      // La vivienda se ha guardado en Firebase
      print('Perfil guardado en Firebase');
      print(viviendaData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: HexColor('#ED9A5E'),
          selectedItemColor: const Color(0xFF0F1370),
          currentIndex: 1,
          //  color: const Color.fromARGB(234,154,94),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_home_work),
              label: 'Agregar Vivienda',
            ),
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
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AgregarVivienda(userEmail: widget.userEmail),
                ),
              );
            }
            if (index == 2) {
              await _signOut(context);
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SplashView(),
                ),
              );
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
        ));
  }
}
