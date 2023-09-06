import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_v1/view/homeAdmin.view.dart';
//import 'package:login_v1/view/splash.view.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los widgets esten inicializados

  await Firebase.initializeApp(); // Inicializa Firebase

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  //final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeAdminPage() // se pone esto -- SplashView(),
        );
  }
}
