import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';
//import 'package:login_v1/utils/global.colors.dart';
//import 'dart:async';
//import 'package:get/get.dart';
//import 'package:login_v1/view/login.view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            '-Or sing in with-',
            style: TextStyle(
              color: GlobalColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1), blurRadius: 10)
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/images/bxs-home.svg',
                  height: 30,
                ),
              ),
            )
          ],
        ),
        // ajustes aqui feo feos
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 44, 0, 30),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 6),
                child: Text(
                  'Dont have an account yet? ',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.black,
                  ),
                ),
              ),
              //PEGAR EL PADING AQUIIIIII
            ],
          ),
        ),
      ],
    );
  }
}
