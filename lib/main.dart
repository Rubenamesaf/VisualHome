import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_v1/api/firebase_api.dart';
import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:login_v1/view/splash.view.dart';
//import 'package:login_v1/view/viviendaEsecificaAdmin.dart';
//import 'package:login_v1/view/widgets/admin_principal.dart';
//import 'package:login_v1/view/widgets/admin_principal.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los widgets esten inicializados

  FirebaseApp firebaseApp =
      await Firebase.initializeApp(); // Inicializa Firebase2

  await FirebaseApi().initNotifications();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  //final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      //SplashView(), // se pone esto -- SplashView(),
    );
  }
}

//home: HomeAdminPage(
//   userEmail: 'ruben@gmail.com'),
