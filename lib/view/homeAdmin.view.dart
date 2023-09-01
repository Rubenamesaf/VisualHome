import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.narajanOscuroColor,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            'HOLA ADMIN TEST RUBEN',
            style: TextStyle(
              color: GlobalColors.mainColor,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
