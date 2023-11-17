import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_v1/utils/global.colors.dart';
import 'package:login_v1/view/widgets/admin_principal.dart';

class NuevoPinView extends StatefulWidget {
  const NuevoPinView({super.key});

  @override
  State<NuevoPinView> createState() => _NuevoPinViewState();
}

class _NuevoPinViewState extends State<NuevoPinView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 252, 227, 210),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            AdminPrincipal(),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Camdio de codigo PIN',
                style: TextStyle(
                  color: Color(0xFF0F1370),
                  fontSize: 24,
                  fontFamily: 'Inria Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  top: 20.0,
                  left: 25.0,
                  bottom: 0), // Ajusta el valor izquierdo según sea necesario
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Datos del habitante:',
                  style: TextStyle(
                    color: Color(0xFF0F1370),
                    fontSize: 17,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.9,
                  ),
                ),
              ),
            ),
            _buildTextFormFields(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24),
              child: Column(
                children: [
                  _crearBotonConfirmar(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildTextFormFields() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: emailController,
              labelText: 'Correo electronico',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: passwordController,
              labelText: 'Nuevo Codigo PIN',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: _buildTextFormField(
              controller: confirmPasswordController,
              labelText: 'Confirmar Codigo PIN',
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText,
      ),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: GlobalColors.textColor,
        fontFamily: 'Outfit',
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _crearBotonConfirmar() {
    return ElevatedButton(
      onPressed: () async {
        //Enviar correo
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        padding: MaterialStateProperty.all(
            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 235, 133, 55)
                // Color(0xFFF19756),
                ),
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
        'Confirmar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF0F1370),
          fontSize: 20,
          fontFamily: 'Inria Sans',
          fontWeight: FontWeight.w700,
          height: 0.95,
        ),
      ),
    );
  }
}
