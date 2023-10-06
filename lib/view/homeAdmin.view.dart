import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'agregarVivienda.dart';
import 'viviendaEsecificaAdmin.dart';
import 'widgets/admin_principal.dart';

class HomeAdminPage extends StatefulWidget {
  final String userEmail;
  HomeAdminPage({required this.userEmail, Key? key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  List<String> viviendas = [];
  var cantidadViviendas;
  String adminName = "";

  @override
  @override
  void initState() {
    super.initState();

    // Leer las viviendas de la base de datos
    _leerViviendas();

    // Escuchar eventos de la base de datos
    _dbref.onChildAdded.listen((event) {
      // Un nuevo hijo (vivienda) se agregó a la base de datos.
      // Actualiza la lista de viviendas y el estado.
      final viviendaName = event.snapshot.key;

      // Verificar si viviendaName no es nulo antes de agregarlo a la lista
      if (viviendaName != null) {
        viviendas.add(viviendaName);
        setState(() {});
      }
    });
  }

  Future<void> _leerViviendas() async {
    _dbref.child("").once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        final dynamic data = dataSnapshot.value;
        if (data is Map<Object?, Object?>) {
          viviendas.clear();
          data.forEach((key, value) {
            if (key is String && key != "Administradores") {
              viviendas.add(key);
            }
            if (key == "Administradores") {
              /*// Buscar el administrador con el email del usuario
              Admin? admin = await getAdminByEmail(widget.userEmail);

              // Si el administrador existe, actualizar el estado
              if (admin != null) {
                setState(() {
                  // Guardar el nombre del administrador
                  adminName = admin.nombre;
                });*/
            }
          }
              // }
              );
          setState(() {});
          cantidadViviendas = viviendas.length;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(administratorName: widget.userEmail),
            const Positioned(
              left: 134,
              top: 135,
              child: SizedBox(
                width: 132,
                height: 38,
                child: Text(
                  'VIVIENDAS',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.76,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 128,
              top: 160,
              child: Container(
                width: 134,
                decoration: const ShapeDecoration(
                  color: GlobalColors.azulColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: GlobalColors.azulColor,
                    ),
                  ),
                ),
              ),
            ),

            // Lista de Viviendas
            Positioned(
              left: 50,
              top: 180, // Ajusta la posición según sea necesario
              child: Container(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 350, // Ajusta la altura según sea necesario
                child: ListView.builder(
                  itemCount: viviendas.length,
                  itemBuilder: (context, index) {
                    return _buildViviendaItem(viviendas[index]);
                  },
                ),
              ),
            ),
            // TEXTO AGREGAR VIVIENDA
            Positioned(
              left: 80,
              top: 585,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('Botón presionado ...');
                  Get.to(() => AgregarVivienda(userEmail: widget.userEmail),
                      arguments: cantidadViviendas);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 18, 145, 24), // Fondo azul
                  onPrimary: Colors.white, // Texto en blanco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white, // Icono en blanco
                ),
                label: Text(
                  'AGREGAR VIVIENDA',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // FIN TEXTO AGREGAR VIVIENDA
          ],
        ),
      ),
    );
  }

  Widget _buildViviendaItem(String viviendaName) {
    return InkWell(
      onTap: () {
        if (viviendaName != null) {
          Get.to(
            () => ViviendaEspecificaAdmin(userEmail: widget.userEmail),
            arguments: viviendaName,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xbaf19756), // Color de fondo azul
          borderRadius: BorderRadius.circular(30), // Esquinas redondeadas
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            viviendaName,
            style: const TextStyle(
              color: Color(0xFF0F1370), // Color del texto blanco
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class GlobalColors {
  static const azulColor =
      Color(0xFF0000FF); // Cambia este color según tus preferencias
  static const naranjaClaritoColor =
      Color(0xFFFFD700); // Cambia este color según tus preferencias
}
