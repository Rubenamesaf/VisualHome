import 'package:flutter/material.dart';
//import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class Vivienda {
  final String nombre;
  Vivienda(this.nombre);
}

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  List<Vivienda> viviendas = []; // Lista de viviendad

  // Funcion para agregar viviendas
  void agregarVivienda(String nombre) {
    setState(() {
      viviendas.add(Vivienda(nombre));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
          body: ListView(
        children: [
          AdminPrincipal(viviendas,
              agregarVivienda), //Pasa la lista y la funcion a admin principal
        ],
      )),
    );
  }
}
