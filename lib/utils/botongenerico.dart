import 'package:flutter/material.dart';

class BotonGenerico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: ElevatedButton(
            onPressed: () {
              // ignore: avoid_print
              print('Button pressed ...');
              //  Get.to(LoginView());
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(325, 72)),
              padding: MaterialStateProperty.all(
                  const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
              //    backgroundColor:
              //         MaterialStateProperty.all(GlobalColors.naranjaFUERTE),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontWeight: FontWeight.w600,
              )),
              elevation: MaterialStateProperty.all(3),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            child: const Text(
              'Iniciar Sección',
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
      ],
    );
  }
}
