import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Importa la librería de autenticación de Firebase
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/homeUser.view.dart';
import 'package:login_v1/view/homeAdmin.view.dart';
//import 'package:login_v1/view/widgets/button.global.dart';
//import 'package:login_v1/view/widgets/text.form.global.dart';
//import 'package:login_v1/view/widgets/social.login.dart';
import 'package:logger/logger.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger _logger = Logger();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _logger.i("que exito");
      // Obtener el usuario actualmente autenticado
      User? userInstance = FirebaseAuth.instance.currentUser;

      if (userInstance != null) {
        //Verificar el rol del usuario y dirigirlo a la pantalla
        if (userInstance.email == "admin@gmail.com") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeAdminPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeUserPage()),
          );
        }
      }
      // Aqui puedes manejar la navegacion a la siguiente pantalla despues del inicio de seccion exitoso.
    } catch (e) {
      // Aqui puedes manejar los errores de inicio de seccion.
      _logger.i("Un mensaje de información"); // i para información
      //_logger.d("Un mensaje de depuración"); // d para depuración
      _logger.e("Error en el inicio de sesión: $e"); // e para error
    }
  }

  //DISEÑO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: Colors.transparent,
      //backgroundColor: GlobalColors.naranjaClaritoColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GlobalColors.grayColor,
              GlobalColors.naranjaClaritoColor,
              GlobalColors.narajanOscuroColor,
              GlobalColors.amarilloColor,
            ],
            stops: const [0, 0, 1, 1],
            begin: const AlignmentDirectional(-0.34, 1),
            end: const AlignmentDirectional(0.34, -1),
          ),
        ),
        child: Center(
          //body: Form(
          // key: _model.formKey,
          // autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 392, //MediaQuery.sizeOf(context).width,
                        height: 89.18,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF19756),
                          border: Border.all(width: 0.50),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'VisualHome',
                          style: TextStyle(
                            color: GlobalColors.logoazulColor,
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
                                //textInputType: TextInputType.emailAddress,
                                //controller: _model.emailTextController,
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
                                      color: GlobalColors.amarilloColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: GlobalColors.blancoColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: GlobalColors.blancoColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: GlobalColors.moradoColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(126, 103, 138, 207),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: GlobalColors.logoazulColor,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: GlobalColors.textColor,
                                    fontFamily: 'Outfit'),
                                keyboardType: TextInputType.emailAddress,
                                //validator: _model.emailTextControllerValidator
                                //    .asValidator(context),
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
                                      borderSide: const BorderSide(
                                        color: GlobalColors.amarilloColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: GlobalColors.azulColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: GlobalColors.azulColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: GlobalColors.amarilloColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        126, 103, 138, 207),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: GlobalColors.logoazulColor,
                                    ),
                                    //    suffixIcon: InkWell(
                                    //      onTap: () => setState(
                                    //       () => _model.passwordVisibility =
                                    //            !_model.passwordVisibility,
                                    //      ),
                                    //      focusNode: FocusNode(skipTraversal: true),
                                    //      child: Icon(
                                    //        _model.passwordVisibility
                                    //            ? Icons.visibility_outlined
                                    //            : Icons.visibility_off_outlined,
                                    //        color: const Color(0x80FFFFFF),
                                    //        size: 22,
                                    //      ),
                                    //  ),
                                  ),

                                  // validator: _model
                                  //     .passwordTextControllerValidator
                                  //     .asValidator(context),
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
                                    backgroundColor:
                                        GlobalColors.narajanOscuroColor,
                                    //iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                    //    0, 0, 0, 0),
                                    // color: GlobalColors.negroColor,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    elevation: 3,
                                    // borderSide: const BorderSide(
                                    //   color: Colors.transparent,
                                    //   width: 1,
                                    //  ),
                                    //  borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Continuar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: GlobalColors.logoazulColor,
                                      fontSize: 22,
                                      fontFamily: 'Inria Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0.86,
                                    ),
                                  ),
                                ),
                              ),
                              // DESCOMENTAR ESTO
                              // const SocialLogin()
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
