import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/view/widgets/registroAlarma.dart';

class AlarmaUserPage extends StatefulWidget {
  final String userEmail;
  const AlarmaUserPage({required this.userEmail, super.key});

  @override
  State<AlarmaUserPage> createState() => _AlarmaUserPageState();
}

class _AlarmaUserPageState extends State<AlarmaUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor('#ED9A5E'),
        selectedItemColor: const Color(0xFF0F1370),
        currentIndex: 0,
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
            icon: Icon(Icons.logout),
            label: 'Cerrar Sesión',
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         AdminPerfilView(userEmail: widget.userEmail),
            //   ),
            // );
          }
          if (index == 2) {
            // viviendas.clear();
            // await _signOut(context);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const SplashView(),
            //   ),
            // );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(
                administratorName: widget.userEmail, pageName: 'alarma'),
            const Positioned(
              left: 150,
              top: 135,
              child: SizedBox(
                width: 132,
                height: 38,
                child: Text(
                  'Alarmas',
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
              left: 129,
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
            Positioned(
              left: 55,
              top: 170, // Ajusta la posición según sea necesario
              child: SizedBox(
                width: 285, // Ajusta el ancho de acuerdo a tu diseño
                height: 480, // Ajusta la altura según sea necesario
                child: ListView(
                  children: [
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                    RegistroAlarma(textoHora: "10:00", switchAlarma: true),
                  ],
                ),
              ),
            ),
            // TEXTO AGREGAR VIVIENDA
            /*Positioned(
              left: 80,
              top: 585,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('IconButton pressed ...');
                  Get.to(() => AgregarVivienda(userEmail: widget.userEmail),
                      arguments: cantidadViviendas);
                },
              ),
            ),*/
            // FIN TEXTO AGREGAR VIVIENDA
          ],
        ),
      ),
    );
  }
}
