import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:login_v1/utils/global.colors.dart';
//import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:login_v1/view/editHomeAdmin.dart';

class AdminPrincipal extends StatelessWidget {
  String administratorName;
  String? pageName;

  AdminPrincipal({required this.administratorName, this.pageName, Key? key})
      : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Widget showBackButton(BuildContext context) {
    if (pageName == 'home') {
      return Container();
    } else {
      return Positioned(
        left: 0,
        top: 25,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF0F1370),
          iconSize: 35,
          onPressed: (() => Navigator.pop(context)),
        ),
      );
    }
  }

  Widget showLogoutButton(BuildContext context) {
    if (pageName != 'home') {
      return Container();
    } else {
      return Positioned(
        left: 335,
        top: 25,
        child: IconButton(
          icon: const Icon(Icons.logout),
          color: const Color(0xFF0F1370),
          iconSize: 35,
          onPressed: (() {
            _signOut(context);
            Navigator.pop(context);
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //width: 392.7,
          height: 90,
          clipBehavior: Clip.antiAlias,
          decoration:
              const BoxDecoration(color: Color.fromARGB(240, 252, 227, 210)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    width: 400,
                    height: 89.18,
                    decoration: BoxDecoration(
                      color: HexColor('#ED9A5E'),
                      border: Border.all(width: 0.50),
                    ),
                  ),
                ),
              ),
              //FoNDO BLANCO DE LA PAGINA  CAMBIO 1
              /*Positioned(
                left: 0,
                top: 698,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: 393,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.amber, //HexColor('#FFFFFF'),
                      border: Border.all(width: 0.05),
                    ),
                  ),
                ),
              ),*/
              Positioned(
                left: 100,
                top: 21,
                child: SizedBox(
                  width: 200,
                  height: 63,
                  child: SvgPicture.asset(
                    'assets/images/VisualHome.svg',
                    fit: BoxFit.cover,
                  ),
                  // child: Text(
                  //   'VisualHome',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Color(0xFF0F1370),
                  //     fontSize: 34,
                  //     fontFamily: 'Inria Sans',
                  //     fontWeight: FontWeight.w700,
                  //     height: 0.54,
                  //   ),
                  // ),
                ),
              ),
              // CIRCULO NARANJA DE ABAJO C. 2
              // aqui va VIVIENDAS
              /*Positioned(
                left: 152,
                top: 655,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const ShapeDecoration(
                    color: Color(0xDBF19756),
                    shape: OvalBorder(),
                  ),
                ),
              ),*/
              /*Positioned(
                left: 172,
                top: 676,
                child: Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: SvgPicture.asset(
                    'assets/images/bxs-user 1.svg',
                    height: 40,
                  ),
                ),
              ),*/
              showBackButton(context),
              showLogoutButton(context),
              /*Positioned(
                left: 331,
                top: 4,
                child: Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.14,
                        top: 13.90,
                        child: Container(
                          width: 35.16,
                          height: 39.01,
                          /*child: SvgPicture.asset(
                            'assets/images/undraw_profile_pic.svg',
                            height: 40,
                          ),*/
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        )
      ],
    );
    // cambio loco
  }
}
