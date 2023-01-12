
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/services.dart';
import 'package:chat/models/models.dart';


class UsuariosScreen extends StatefulWidget {

  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  
  final usuarioService = UsuariosService();
  
  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario!.nombre , style: const TextStyle( color: Colors.black87 ) ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () async {
            await AuthService.deleteToken();
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: ( socketService.serverStatus == ServerStatus.online )
              ? Icon( Icons.check_circle, color: Colors.blue[400])
              : Icon( Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarUsuarios,
        color: Colors.blue[400]!,
        child: _listViewUsuarios()        
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: ( _, i ) => _usuarioListTile( usuarios[i] ), 
      separatorBuilder: ( _, i) => const Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile( Usuario usuario ) {
    return ListTile(
        title: Text( usuario.nombre ),
        subtitle: Text( usuario.email ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( usuario.nombre.substring( 0,2 ) )
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {

          final chatService = Provider.of<ChatService>( context, listen: false );
          chatService.usuarioPara = usuario;
          Navigator.pushNamed( context, 'chat' );

        },
      );
  }

  Future<void> _cargarUsuarios() async {    
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
  }
}