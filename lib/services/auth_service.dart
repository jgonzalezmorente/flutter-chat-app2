import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';



class AuthService with ChangeNotifier {

  static const _storage = FlutterSecureStorage();

  Usuario? usuario;
  bool _autenticando = false;

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  static Future<String?> getToken() async => await _storage.read( key: 'token' );
  static Future<void> deleteToken() async => await _storage.delete( key: 'token' );

  Future<bool> login( String email, String password ) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post( Uri.parse('${ Environment.apiUrl }/login'),
      body: jsonEncode( data ),
      headers: { 'Content-Type': 'application/json' }
    ); 

    autenticando = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      _guardarToken( loginResponse.token );
      return true;
    } else {
      return false;
    }

  }

  Future register( String nombre, String email, String password ) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final resp = await http.post( Uri.parse('${ Environment.apiUrl }/login/new' ),
      body: jsonEncode( data ),
      headers: { 'Content-Type': 'application/json' }
    );

    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      _guardarToken( loginResponse.token );
      return true;      
    } else {
      final respBody = jsonDecode( resp.body );
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read( key: 'token' );
    final resp = await http.get( Uri.parse('${ Environment.apiUrl }/login/renew' ),      
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      _guardarToken( loginResponse.token );
      return true;      
    } else {
      logout();
      return false;
    }

  }

  Future _guardarToken( String token ) async => await _storage.write( key: 'token', value: token );
  
  Future logout() async => await _storage.delete( key: 'token' ); 

}