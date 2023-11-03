//import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:login_v1/view/usuario/homeUser.view.dart';
//import 'widgets/admin_principal.dart';

import 'homeAdmin.view.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  // DISEÑO

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false; // este es para que la clave se oculte
  bool signInSuccess =
      false; // variable para rastrear el exito del inicio de sesion

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger _logger = Logger();
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();

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
      // si el inicio de sesion es exitoso
      setState(() {
        signInSuccess = true;
      });
      // Aquí puedes manejar la navegación a la siguiente pantalla después del inicio de sesión exitoso.
    } catch (e) {
      // Aquí puedes manejar los errores de inicio de sesión.
      setState(() {
        signInSuccess = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            BackgroundContainer(),
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 500,
                        height: 100,
                        child: SvgPicture.asset(
                          'assets/images/VisualHome.svg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            //inicio pega
                            const SizedBox(height: 60),
                            TextFormField(
                              controller: emailController,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Correo Electronico',
                                labelStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(181, 0, 0, 255)),
                                hintText: 'Tu correo...',
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
                              //validacion
                              validator: (Value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(Value!);

                                if (Value.isEmpty) {
                                  return "Ingrese su Correo Electrónico";
                                } else if (!emailValid) {
                                  return "Ingrese un correo de electrónico valido";
                                }
                                return null;
                              },
                              // fin validacion
                            ),
                            //pegado
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: passwordController,
                              obscureText: !showPassword, // true,
                              decoration: InputDecoration(
                                // el beta de la clave oculta
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: Icon(showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                //fin del beta
                                labelText: 'Contraseña',
                                labelStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(181, 0, 0, 255)),
                                hintText: 'Ingrese su Contraseña aqui...',
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
                                  borderSide: const BorderSide(
                                    color: Color(0xFF678ACF),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF678ACF),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xD1FBE288),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(126, 103, 138, 207),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF0F1370),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese la contraseña";
                                } else if (passwordController.text.length < 6) {
                                  return "La contraseña debe ser mayor a 6 ";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _signInWithEmailAndPassword(context);

                                  if (!signInSuccess) {
                                    // Si la autenticación no es válida, muestra el AwesomeDialog de advertencia
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      title: "Error",
                                      desc:
                                          "Credenciales de inicio de sesión inválidas.",
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else {
                                    emailController
                                        .clear(); //OJO YO CREO QUE ESTO NI EL PASSWORD HACEN FALTA
                                    passwordController.clear();
                                  }
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(325, 72)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 24, 0)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 235, 133, 55)
                                    // Color(0xFFF19756),
                                    ),
                                textStyle:
                                    MaterialStateProperty.all(const TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                                elevation: MaterialStateProperty.all(3),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0F1370),
                                  fontSize: 20,
                                  fontFamily: 'Inria Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0.95,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), //aqui se agrega el form
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(159, 124, 153, 211),
            Color.fromARGB(230, 231, 177, 138),
            Color.fromARGB(235, 233, 126, 49),
            Color.fromARGB(209, 248, 220, 117),
          ],
          stops: [0.19, 0.25, 0.8, 0.9],
          begin: AlignmentDirectional(-1.0, 1.0),
          end: AlignmentDirectional(1.0, -1.0),
        ),
      ),
    );
  }
}

void showWarningDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.topSlide,
    showCloseIcon: true,
    title: "Advertencia",
    desc: "Solo los administradores pueden registrar cuentas",
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  ).show();
}
