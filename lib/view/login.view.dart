import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'widgets/admin_principal.dart';

import 'homeAdmin.view.dart';
import 'homeUser.view.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger _logger = Logger();
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _logger.i("que éxito");
      // Obtener el usuario actualmente autenticado
      User? userInstance = FirebaseAuth.instance.currentUser;

      if (userInstance != null) {
        // Obtener la lista de administradores
        final administradoresEmailList = await _getAdministradores();

        // Validar si el correo pertenece a un administrador
        if (administradoresEmailList.contains(emailController.text)) {
          // El correo pertenece a un administrador
          // Redirige a la pantalla de administrador
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeAdminPage(userEmail: userInstance.email ?? ""),
            ),
          );
        } else {
          // El correo no es de un administrador, redirige a la pantalla de usuario
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeUserPage(userEmail: userInstance.email ?? ""),
            ),
          );
        }
      }
      // Aquí puedes manejar la navegación a la siguiente pantalla después del inicio de sesión exitoso.
    } catch (e) {
      // Aquí puedes manejar los errores de inicio de sesión.
      _logger.i("Un mensaje de información");
      _logger.e("Error en el inicio de sesión: $e");
    }
  }

  // Obtener la lista de administradores desde la base de datos
  Future<List<String>> _getAdministradores() async {
    try {
      final DatabaseEvent event = await _dbref.child("Administradores").once();

      if (event.snapshot != null) {
        final Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;

        final List<String> administradoresEmailList = [];

        if (data != null) {
          data.forEach((key, value) {
            final email = value["Email"];
            if (email != null) {
              administradoresEmailList.add(email.toString());
            }
            print("Email encontrado: $email");
          });
        }

        return administradoresEmailList;
      }

      // Si no hay datos disponibles, regresa una lista vacía
      return [];
    } catch (error) {
      print("Error al obtener datos de Administradores: $error");
      // Manejar errores aquí
      return [];
    }
  }

  // DISEÑO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(248, 93, 95, 168),
              HexColor('#ee8133'),
              Color(0xF2FEC49A),
              Color(0xD1FBE288),
            ],
            stops: const [0.19, 0.25, 0.8, 0.9],
            begin: const AlignmentDirectional(-1.0, 1.0),
            end: const AlignmentDirectional(1.0, -1.0),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 392,
                        height: 89.18,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF19756),
                          border: Border.all(width: 0.50),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'VisualHome',
                          style: TextStyle(
                            color: Color(0xFF0F1370),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 45, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 45, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextFormField(
                                controller: emailController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Your email...',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0x9AFFFFFF),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xD1FBE288),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: HexColor('#FFFFFF'),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: HexColor('#FFFFFF'),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: HexColor('#4B39EF'),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(126, 103, 138, 207),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF0F1370),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: HexColor('#101470'),
                                  fontFamily: 'Outfit',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password here...',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0x9AFFFFFF),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xD1FBE288),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF678ACF),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF678ACF),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xD1FBE288),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        126, 103, 138, 207),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF0F1370),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 250, 0, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _signInWithEmailAndPassword(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            65, 25, 65, 25),
                                    backgroundColor: HexColor('#F29757DB'),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    'Continuar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0F1370),
                                      fontSize: 22,
                                      fontFamily: 'Inria Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0.86,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
