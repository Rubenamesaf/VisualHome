import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Importa la librería de autenticación de Firebase
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/homeUser.view.dart';
import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:login_v1/view/widgets/button.global.dart';
import 'package:login_v1/view/widgets/text.form.global.dart';
import 'package:login_v1/view/widgets/social.login.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                'VisualHome',
                style: TextStyle(
                  color: GlobalColors.mainColor,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Login to your account',
              style: TextStyle(
                color: GlobalColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),

            //// Email input
            TextFormGlobal(
              controller: emailController,
              text: 'Email',
              obscure: false,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),

            //// Password input
            TextFormGlobal(
                controller: passwordController,
                text: 'password',
                textInputType: TextInputType.text,
                obscure: true),
            const SizedBox(height: 10),
            ButtonGlobal(onPressed: () async {
              await _signInWithEmailAndPassword(
                  context); //  Pasa la función al botón
            }),
            const SizedBox(height: 25),
            const SocialLogin()
          ],
        ),
      ))),
    );
  }
}
