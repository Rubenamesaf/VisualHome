import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:login_v1/utils/global.colors.dart';
//import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:login_v1/view/editHomeAdmin.dart';

class AdminPrincipal extends StatelessWidget {
  String? administratorName;
  String? pageName;

  AdminPrincipal({this.administratorName, this.pageName, Key? key})
      : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Widget showBackButton(BuildContext context) {
    if (pageName == 'home') {
      return Container();
    } else {
      return Positioned(
        left: 0,
        top: 25,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF0F1370),
          iconSize: 35,
          onPressed: (() => Navigator.pop(context)),
        ),
      );
    }
  }

  Widget showLogoutButton(BuildContext context) {
    if (pageName != 'home') {
      return Container();
    } else {
      return Positioned(
        left: 335,
        top: 25,
        child: IconButton(
          icon: const Icon(Icons.logout),
          color: const Color(0xFF0F1370),
          iconSize: 35,
          onPressed: (() {
            _signOut(context);
            Navigator.pop(context);
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //width: 392.7,
          height: 90,
          clipBehavior: Clip.antiAlias,
          decoration:
              const BoxDecoration(color: Color.fromARGB(240, 252, 227, 210)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    width: 412,
                    height: 89.18,
                    decoration: BoxDecoration(
                      color: HexColor('#ED9A5E'),
                      border: Border.all(width: 0.50),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 100,
                top: 21,
                child: SizedBox(
                  width: 200,
                  height: 63,
                  child: SvgPicture.asset(
                    'assets/images/VisualHome.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              showBackButton(context),
              showLogoutButton(context),
            ],
          ),
        )
      ],
    );
  }
}
