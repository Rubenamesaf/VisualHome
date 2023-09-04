import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          AdminPrincipal(),
        ]),
      ),
    );
  }
}

class AdminPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration:
              const BoxDecoration(color: GlobalColors.naranjaClaritoColor),
          child: Stack(
            children: [
              Positioned(
                left: 41,
                top: 219,
                child: Container(
                  width: 313,
                  height: 69,
                  decoration: ShapeDecoration(
                    color: const Color(0xF2FEC49A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Opacity(
                  opacity: 0.85,
                  child: Container(
                    width: 393,
                    height: 89.18,
                    decoration: BoxDecoration(
                      color: const Color(0xDBF19756),
                      border: Border.all(width: 0.50),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 764,
                child: Opacity(
                  opacity: 0.85,
                  child: Container(
                    width: 393,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFCFC),
                      border: Border.all(width: 0.50),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 24,
                top: 13,
                child: SizedBox(
                  width: 187,
                  height: 63,
                  child: Text(
                    'VisualHome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 35,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.54,
                    ),
                  ),
                ),
              ),
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
                top: 173,
                child: Container(
                  width: 134,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFF19756),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.50,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFF19756),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 152,
                top: 731,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const ShapeDecoration(
                    color: Color(0xDBF19756),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 172,
                top: 751,
                child: Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  //child: Stack(children: [
                  //,
                  //]),
                ),
              ),
              const Positioned(
                left: 70,
                top: 235,
                child: SizedBox(
                  width: 255,
                  height: 38,
                  child: Text(
                    'Vivienda 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 30,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      height: 0.50,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41,
                top: 301,
                child: Container(
                  width: 313,
                  height: 69,
                  decoration: ShapeDecoration(
                    color: const Color(0xF2FEC49A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 70,
                top: 317,
                child: SizedBox(
                  width: 255,
                  height: 38,
                  child: Text(
                    'Vivienda 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 30,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      height: 0.50,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41,
                top: 383,
                child: Container(
                  width: 313,
                  height: 69,
                  decoration: ShapeDecoration(
                    color: const Color(0xF2FEC49A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 70,
                top: 399,
                child: SizedBox(
                  width: 255,
                  height: 38,
                  child: Text(
                    'Vivienda 3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 30,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      height: 0.50,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41,
                top: 465,
                child: Container(
                  width: 313,
                  height: 69,
                  decoration: ShapeDecoration(
                    color: const Color(0xF2FEC49A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 70,
                top: 481,
                child: SizedBox(
                  width: 255,
                  height: 38,
                  child: Text(
                    'Vivienda 4',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 30,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      height: 0.50,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 327,
                top: 47,
                child: SizedBox(
                  width: 54,
                  height: 38,
                  child: Text(
                    'Karla',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 20,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.95,
                    ),
                  ),
                ),
              ),
              Positioned(
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
                        left: 6.14,
                        top: 10.90,
                        child: Container(
                          width: 35.16,
                          height: 39.01,
                          //  child: Stack(children: [
                          //  ,
                          //  ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 78,
                top: 587,
                child: SizedBox(
                  width: 215,
                  height: 37,
                  child: Text(
                    'AGREGAR VIVIENDA',
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 22,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.86,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 274,
                top: 587,
                child: Container(
                  width: 39,
                  height: 41,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/39x41"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
