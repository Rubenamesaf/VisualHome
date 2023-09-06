import 'package:flutter/material.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.azulColor,
      body: Center(
        child: AdminPrincipal(),
      ),
    );
  }
}
