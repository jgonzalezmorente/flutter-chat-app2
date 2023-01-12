
import 'dart:convert';
import 'models.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(str);

String loginResponseToJson(LoginResponse data) => data.toJson();

class LoginResponse {
    bool ok;
    Usuario usuario;
    String token;

    LoginResponse({
        required this.ok,
        required this.usuario,
        required this.token,
    });

    factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json['ok'],
        usuario: Usuario.fromMap(json['usuario']),
        token: json['token'],
    );

    Map<String, dynamic> toMap() => {
        'ok': ok,
        'usuario': usuario.toMap(),
        'token': token,
    };
}