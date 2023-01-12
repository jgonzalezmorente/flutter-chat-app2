
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/services/services.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';


class ChatService with ChangeNotifier {
  
  Usuario? usuarioPara;

  Future<List<Mensaje>?> getChat( String usuarioID ) async {    
    
    final resp = await http.get( Uri.parse( '${ Environment.apiUrl }/mensajes/$usuarioID' ),
      headers: {
        'Content-Type': 'application/json',
        'x-token': (await AuthService.getToken())!
      }
    );

    final mensajesResp = mensajesResponseFromJson( resp.body );

    return mensajesResp.mensajes;


  }

}