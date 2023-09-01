import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:login_v1/view/login.view.dart';
import 'package:login_v1/view/widgets/desing_splash.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Get.to(LoginView());
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: const Center(
        child: DesingSplashContainer(),
      ),
    );
  }
}
