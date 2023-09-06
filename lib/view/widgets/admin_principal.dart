import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/homeAdmin.view.dart';

class AdminPrincipal extends StatelessWidget {
  final List<Vivienda> viviendas;
  final Function(String) agregarVivienda;

  const AdminPrincipal(this.viviendas, this.agregarVivienda);

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
              for (var vivienda in viviendas)
                ListTile(
                  title: Text(vivienda.nombre),
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
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 6.14,
                        top: 10.90,
                        child: SizedBox(
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
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String nombreVivienda = '';
                      return AlertDialog(
                        title: Text('Agregar Vivienda'),
                        content: TextField(
                          onChanged: (nombre) {
                            nombreVivienda = nombre;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // cierra el cuadro del diálogo
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // agrega la nueva vivienda a la lista
                              // y cierra el cuadro de diálogo
                              agregarVivienda(nombreVivienda);
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Texto del boton'),
              ),
              Positioned(
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
            ], // Fin de los hijos del Stack
          ), // Fin del Stack
        ), // Fin del Container
      ], // Fin de los hijos de la Column
    ); // Fin de la Column
  }
}
