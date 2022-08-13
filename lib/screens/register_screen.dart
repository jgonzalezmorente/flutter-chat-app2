import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/helpers/helpers.dart';
import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';


class RegisterScreen extends StatelessWidget {

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color( 0xfff2f2f2 ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of( context ).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
      
                Logo( titulo: 'Registro' ),
                
                _Form(),
                
                Labels(
                  ruta: 'login',
                  titulo: '¿Ya tienes cuenta?',
                  subtitulo: 'Ingrese ahora!',
                ),
                
                Text( 'Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w300 ) ),
      
              ],
            ),
          ),
        ),
      ),
   );
  }
}


class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    
    return Container(
      margin: const EdgeInsets.only( top: 40 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(
            text: 'Crear cuenta',
            onPressed: authService.autenticando ? null : () async {
              FocusScope.of( context ).unfocus();
              final registroOk = await authService.register( 
                nameCtrl.text.trim(), 
                emailCtrl.text.trim(), 
                passCtrl.text.trim()
              );
              if ( registroOk == true ) {

                Navigator.pushReplacementNamed( context, 'usuarios' );
              } else {
                mostrarAlerta(context, 'Registro incorrecto', registroOk );
              }
            },
          )


        ],
      ),
    );
  }
}

