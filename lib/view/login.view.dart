//import 'dart:html';

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:login_v1/view/nuevoPin.view.dart';
import 'package:login_v1/view/usuario/homeUser.view.dart';
//import 'widgets/admin_principal.dart';
import 'package:flutter/gestures.dart';

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

  Future<void> _sendEmail(String destinationEmail, String codigo) async {
    final url =
        'https://us-central1-domotica-sordos.cloudfunctions.net/sendEmail?dest=$destinationEmail&codigo=$codigo';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Correo enviado exitosamente');
    } else {
      print('Error al enviar el correo: ${response.body}');
    }
  }

  int generarNumeroAleatorio() {
    Random random = Random();
    // Genera un número aleatorio entre 100000 y 999999 (ambos inclusive)
    int numeroAleatorio = 100000 + random.nextInt(900000);
    return numeroAleatorio;
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      // Muestra un diálogo de éxito o redirige a una pantalla de éxito
      // Puedes agregar un AwesomeDialog o usar Navigator para navegar a otra pantalla.
      // Por ejemplo:
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Éxito",
        desc:
            "Se ha enviado un correo electrónico para restablecer tu contraseña.",
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      // Maneja los errores aquí
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Error",
        desc:
            "Hubo un problema al enviar el correo electrónico. Inténtalo de nuevo más tarde. \n\n Asegurate de ingresar un correo electrónico válido",
        btnOkOnPress: () {},
      ).show();
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
    double deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                              labelText: 'Correo Electrónico',
                              labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(181, 0, 0, 255)),
                              hintText: '',
                              hintStyle: const TextStyle(
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
                            ),
                            keyboardType: TextInputType.emailAddress,
                            //validacion
                            validator: (Value) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(Value!);

                              if (Value.isEmpty) {
                                return "Ingrese su correo electrónico";
                              } else if (!emailValid) {
                                return "Ingrese un correo de electrónico válido";
                              }
                              return null;
                            },
                            // fin validacion
                          ),
                          //pegado
                          const SizedBox(height: 30),

                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !showPassword,
                              keyboardType: TextInputType.number, // true,
                              decoration: InputDecoration(
                                // el beta de la clave oculta
                                suffixIcon: IconButton(
                                  color: Color(0xFF0F1370),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: Icon(showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                //fin del beta
                                labelText: 'Código PIN',
                                labelStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(181, 0, 0, 255)),
                                hintText: '',
                                hintStyle: const TextStyle(
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: HexColor('#101470'),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese su código de acceso";
                                } else if (passwordController.text.length < 6) {
                                  return "Su código debe contener 6 números";
                                }
                              },
                            ),
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
                                  const Size(200, 50)),
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
                                fontWeight: FontWeight.w700,
                                height: 0.95,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 40), // Ajusta el valor según sea necesario
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      '¿Olvidaste tu código PIN?\n    \n     ',
                                  style: const TextStyle(
                                    color: Color(0xFF0F1370),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    height: 0.95,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Restaurar código PIN',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 33, 72, 243),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        height: 0.95,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final codigo =
                                              generarNumeroAleatorio();
                                          await _sendEmail(emailController.text,
                                              codigo.toString());
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => NuevoPinView(
                                              userEmail: emailController.text,
                                              codigo: codigo.toString(),
                                            ),
                                          ));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //aqui se agrega el form
            ),
          ),
        ],
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
