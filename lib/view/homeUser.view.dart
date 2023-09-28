import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';

class HomeUserPage extends StatelessWidget {
  final String
      userEmail; // Agrega un campo para almacenar el correo electrónico

  HomeUserPage({required this.userEmail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: GlobalColors.mainColor);
  }
}
