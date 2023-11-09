import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/editAdminInfo.dart';
import 'package:login_v1/view/usuario/alarmaUser.view.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/sistemaUsuario.dart';

class MonitoreoSistemaUser extends StatefulWidget {
  final String userEmail;
  final String vivienda;
  const MonitoreoSistemaUser(
      {required this.userEmail, required this.vivienda, super.key});

  @override
  State<MonitoreoSistemaUser> createState() => _MonitoreoSistemaUserState();
}

class _MonitoreoSistemaUserState extends State<MonitoreoSistemaUser> {
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  String databasejson = "";
  List<Sistema> sistemasList = [];

  @override
  void initState() {
    super.initState();
    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _dbref.child(widget.vivienda).onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null && mounted) {
        print("Datos actualizados - " + dataSnapshot.value.toString());
        setState(() {
          databasejson = dataSnapshot.value.toString();

          // Eliminar los corchetes iniciales y finales
          databasejson = databasejson.substring(1, databasejson.length - 1);

          // Dividir la cadena en pares clave-valor
          final keyValuePairs = databasejson.split(', ');

          // Limpiar la lista actual antes de agregar los nuevos sistemas
          sistemasList.clear();

          // Recorrer los pares clave-valor y agregarlos a sistemasList
          for (var pair in keyValuePairs) {
            final parts = pair.split(': ');
            final nombre = parts[0].trim(); // Eliminar espacios en blanco

            if (nombre != "Usuario") {
              final estado = int.tryParse(parts[1].trim());
              if (estado != null) {
                sistemasList.add(Sistema(nombre, estado == 1));
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 2,
        //  color: const Color.fromARGB(234,154,94),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Monitoreo',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlarmaUserPage(
                  userEmail: widget.userEmail,
                  vivienda: widget.vivienda,
                ),
              ),
            );
          }
          if (index == 1) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         AdminPerfilView(userEmail: widget.userEmail),
            //   ),
            // );
          }
        },
      ),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(
                administratorName: widget.userEmail, pageName: 'monitoreo'),
            Positioned(
              left: 120,
              top: 135,
              child: SizedBox(
                width: 200,
                height: 38,
                child: Text(
                  widget.vivienda,
                  style: const TextStyle(
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
              left: 113,
              top: 160,
              child: Container(
                width: 180,
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
            Positioned(
              left: 55,
              top: 170,
              child: SizedBox(
                width: 285,
                height: 500,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: sistemasList.length,
                  itemBuilder: (context, index) {
                    final sistema = sistemasList[index];
                    return SistemaUsuario(
                      nombreSistema: sistema.nombre,
                      activo: sistema.estado,
                      icon: const Icon(
                        Icons.abc,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                // child: ListView.builder(
                //   itemCount: sistemasList.length,
                //   itemBuilder: (context, index) {
                //     final sistema = sistemasList[index];
                //     return SistemaUsuario(
                //         nombreSistema: sistema.nombre, activo: sistema.estado);
                //   },
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
