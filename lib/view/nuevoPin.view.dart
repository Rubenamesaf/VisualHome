import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class NuevoPinView extends StatefulWidget {
  final String userEmail;
  final String codigo;
  const NuevoPinView({required this.userEmail, required this.codigo, Key? key})
      : super(key: key);

  @override
  State<NuevoPinView> createState() => _NuevoPinViewState();
}

class _NuevoPinViewState extends State<NuevoPinView> {
  final TextEditingController verificadorController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String vivienda = '';
  String direccion = '';
  String email = '';
  String nombre = '';
  String password = '';
  String codigoPin = '';
  DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getVivienda();
  }

  Future<void> _getVivienda() async {
    final userSnapshot = await _dbref.child("").once();
    if (userSnapshot.snapshot.value != null) {
      final dynamic data = userSnapshot.snapshot.value;
      data.forEach((key, value) {
        if (key is String && key != "Administradores") {
          if (value["Usuario"]["Email"] == widget.userEmail) {
            direccion = value["Usuario"]["Direccion"];
            email = value["Usuario"]["Email"];
            nombre = value["Usuario"]["Nombre"];
            codigoPin = value["Usuario"]["CodigoPIN"];
            password = value["Usuario"]["Password"];
            vivienda = key;
          }
        }
      });
    }
    _setCodigoVerificador();
  }

  Future<void> _setCodigoVerificador() async {
    await _dbref.child(vivienda).update({
      'Usuario': {
        'Direccion': direccion,
        'Email': email,
        'Nombre': nombre,
        'CodigoPIN': codigoPin,
        'Password': password,
        'CodigoVerificador': widget.codigo,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            AdminPrincipal(),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Cambio de código PIN',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 25.0, bottom: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingresa el código de recuperación enviado a tu correo electrónico:',
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
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24),
              child: Column(
                children: [
                  _crearBotonConfirmar(),
                ],
              ),
            ),
          ],
        )),
      ),
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
              controller: verificadorController,
              labelText: 'Código de recuperación',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 0.0, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ingresa tu nuevo código PIN de acceso a tu app VisualHome:',
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
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: 'Nuevo código PIN',
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: confirmPasswordController,
              labelText: 'Confirmar Código PIN',
              keyboardType: TextInputType.number,
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
      keyboardType: TextInputType.number,
    );
  }

  Widget _crearBotonConfirmar() {
    return TextButton(
      onPressed: () async {
        if (passwordController.text == confirmPasswordController.text &&
            verificadorController.text == widget.codigo &&
            passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty &&
            passwordController.text.length == 6 &&
            confirmPasswordController.text.length == 6) {
          await _dbref.child(vivienda).update({
            'Usuario': {
              'CodigoPIN': passwordController.text,
              'Direccion': direccion,
              'Email': email,
              'Nombre': nombre,
              'Password': password,
              'CodigoVerificador': widget.codigo,
            },
          });

          await _auth.signInWithEmailAndPassword(
            email: email,
            password: codigoPin,
          );

          User? user = _auth.currentUser!;

          await user.updatePassword(passwordController.text);
          _auth.signOut();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Código guardado con éxito'),
                content: Text(
                    'El cóigo de acceso a tu app VisualHome ha sido cambiado.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Campos inválidos'),
                content: Text(
                    'Debe completar los campos con los códigos correspondientes.\n\n1. Código de recuperación enviado a su correo.\n2. Nuevo código de acceso a su app.\n3. Repetir el nuevo código de acceso.'),
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
        }
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        padding: MaterialStateProperty.all(
          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        ),
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 235, 133, 55),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: MaterialStateProperty.all(3),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      child: Text(
        'Confirmar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF0F1370),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 0.95,
        ),
      ),
    );
  }
}
