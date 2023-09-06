import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_v1/utils/global.colors.dart';
//import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminPrincipal extends StatelessWidget {
  // final List<Vivienda> viviendas;
  // final Function(String) agregarVivienda;

  // const AdminPrincipal(this.viviendas, this.agregarVivienda);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: 393,
          height: 780,
          clipBehavior: Clip.antiAlias,
          decoration:
              const BoxDecoration(color: GlobalColors.naranjaClaritoColor),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    width: 393,
                    height: 89.18,
                    decoration: BoxDecoration(
                      color: GlobalColors.naranjaColor,
                      border: Border.all(width: 0.50),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 698,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: 393,
                    height: 88,
                    decoration: BoxDecoration(
                      color: GlobalColors.blancoColor,
                      border: Border.all(width: 0.05),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 24,
                top: 46,
                child: SizedBox(
                  width: 200,
                  height: 63,
                  child: Text(
                    'VisualHome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1370),
                      fontSize: 34,
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
              ),
              Positioned(
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
              ),
              const Positioned(
                left: 200,
                top: 65,
                child: SizedBox(
                  width: 170,
                  height: 500,
                  child: Text(
                    // aqui hay que buscar le nombre la persona OJO
                    'Karla',
                    textAlign: TextAlign.end,
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
                        left: 0.14,
                        top: 13.90,
                        child: Container(
                          width: 35.16,
                          height: 39.01,
                          child: SvgPicture.asset(
                            'assets/images/undraw_profile_pic.svg',
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // BOTON AGREGAR
              Positioned(
                left: 50,
                top: 500,
                child: ElevatedButton(
                  onPressed: () {
                    // ignore: avoid_print
                    print('Button pressed ...');
                    //  Get.to(LoginView());
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 60)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                    backgroundColor:
                        MaterialStateProperty.all(GlobalColors.naranjaFUERTE),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'AGREGAR VIVIENDA',
                    textAlign: TextAlign.center,
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
              // FIN BOTON AGREGAR
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
