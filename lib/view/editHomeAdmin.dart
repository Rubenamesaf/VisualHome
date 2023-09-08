import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/sistemaEspecificoAdmin.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';
import 'package:login_v1/models/vivienda_model.dart';

class editHomeAdmin extends StatelessWidget {
  editHomeAdmin({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ViviendaModel vivienda = new ViviendaModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.azulColor,
      body: Center(
        child: Stack(
          children: [
            AdminPrincipal(),
            const Positioned(
              left: 50,
              top: 135,
              child: SizedBox(
                width: 600,
                height: 380,
                child: Text(
                  'CREAR VIVIENDAS',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 25,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.9,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 170,
              child: Container(
                width: 235,
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
            //inicio formulario
            //nombre
            Positioned(
              left: 10,
              right: 30,
              top: 200,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        //controller: emailController,
                        //textInputType: TextInputType.emailAddress,
                        //controller: _model.emailTextController,
                        obscureText: false,
                        initialValue: vivienda.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Your Name...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0x9AFFFFFF),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: GlobalColors.amarilloColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.moradoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(126, 103, 138, 207),
                          prefixIcon: const Icon(
                            Icons.abc,
                            color: GlobalColors.logoazulColor,
                          ),
                        ),
                        // aqui se pone EL VALIDATOR
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: GlobalColors.textColor,
                            fontFamily: 'Outfit'),
                        keyboardType: TextInputType.name,
                        //validator: _model.emailTextControllerValidator
                        //    .asValidator(context),
                      ),
                    ],
                  )),
            ),
            //fin nombre
            // email
            Positioned(
              left: 10,
              right: 30,
              top: 270,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        controller: emailController,
                        //textInputType: TextInputType.emailAddress,
                        //controller: _model.emailTextController,
                        obscureText: false,
                        initialValue: vivienda.pasword,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Your email...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0x9AFFFFFF),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: GlobalColors.amarilloColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.moradoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(126, 103, 138, 207),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: GlobalColors.logoazulColor,
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: GlobalColors.textColor,
                            fontFamily: 'Outfit'),
                        keyboardType: TextInputType.emailAddress,
                        //validator: _model.emailTextControllerValidator
                        //    .asValidator(context),
                      ),
                    ],
                  )),
            ),
            // fin email
            //password
            Positioned(
              left: 10,
              right: 30,
              top: 340,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        controller: passwordController,
                        //textInputType: TextInputType.emailAddress,
                        //controller: _model.emailTextController,
                        obscureText: false,
                        initialValue: vivienda.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password here...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0x9AFFFFFF),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: GlobalColors.amarilloColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.moradoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(126, 103, 138, 207),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: GlobalColors.logoazulColor,
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: GlobalColors.textColor,
                            fontFamily: 'Outfit'),
                        keyboardType: TextInputType.visiblePassword,
                        //validator: _model.emailTextControllerValidator
                        //    .asValidator(context),
                      ),
                    ],
                  )),
            ),
            //fin password
            // direccion
            Positioned(
              left: 10,
              right: 30,
              top: 410,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        //controller: emailController,
                        //textInputType: TextInputType.emailAddress,
                        //controller: _model.emailTextController,
                        obscureText: false,
                        initialValue: vivienda.address,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Your Adress...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0x9AFFFFFF),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: GlobalColors.amarilloColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.blancoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: GlobalColors.moradoColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(126, 103, 138, 207),
                          prefixIcon: const Icon(
                            Icons.home,
                            color: GlobalColors.logoazulColor,
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: GlobalColors.textColor,
                            fontFamily: 'Outfit'),
                        keyboardType: TextInputType.streetAddress,
                        onSaved: (Value) => vivienda.address = Value,
                        validator: (Value) {
                          if (Value.contains('hola')) {
                            return 'ingrese una direccion';
                          } else {
                            return null;
                          }
                        },
                        //validator: _model.emailTextControllerValidator
                        //    .asValidator(context),
                      ),
                    ],
                  )),
            ),
            //fin direccion
            // fin de formulario
            Positioned(left: 280, top: 120, child: _crearBotonGuardar())
          ],
        ),
      ),
    );
  }
}

Widget _crearBotonGuardar() {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: GlobalColors.amarilloColor,
      foregroundColor: GlobalColors.logoazulColor,
    ),
    onPressed: () {
      print('IconButton pressed ...');
      Get.to(const SistemaEspecificoAdmin());
    },
    label: const Text('Guardar'),
    icon: const Icon(Icons.save),
  );
}
