import 'package:flutter/material.dart';
import 'package:chat/widgets/widgets.dart';


class LoginScreen extends StatelessWidget {

  const LoginScreen({Key? key}) : super(key: key);

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
      
                Logo( titulo: 'Messenger' ),
                
                _Form(),
                
                Labels(
                  ruta: 'register',
                  titulo: '¿No tienes cuenta?',
                  subtitulo: 'Crea una ahora!',
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

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 40 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [
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
            text: 'Ingrese',
            onPressed: () {
              print( emailCtrl.text );
              print( passCtrl.text );
            },
          )


        ],
      ),
    );
  }
}

