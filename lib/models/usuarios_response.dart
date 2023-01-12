
import 'dart:convert';
import 'package:chat/models/models.dart';


class UsuariosResponse {
    UsuariosResponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<Usuario> usuarios;

    factory UsuariosResponse.fromJson(String str) => UsuariosResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UsuariosResponse.fromMap(Map<String, dynamic> json) => UsuariosResponse(
        ok: json['ok'],
        usuarios: List<Usuario>.from(json['usuarios'].map((x) => Usuario.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        'ok': ok,
        'usuarios': List<dynamic>.from(usuarios.map((x) => x.toMap())),
    };
}
