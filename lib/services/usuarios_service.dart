import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';


class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {
    try {
      
      final resp = await http.get( Uri.parse( '${ Environment.apiUrl }/usuarios' ),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final usuariosResponse = UsuariosResponse.fromJson( resp.body );
      return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];      
    }
  }

}