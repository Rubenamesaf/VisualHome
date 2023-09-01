// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed; // Agrega esta propiedad

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      // llama a la funcion autenticacion fire base
      //print('Login');
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
