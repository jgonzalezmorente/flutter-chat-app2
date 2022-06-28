import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat/models/models.dart';


class UsuariosScreen extends StatefulWidget {

  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final RefreshController _refreshController = RefreshController( initialRefresh: false );

  final usuarios = [
    Usuario( uid: '1', nombre: 'María', email: 'test1@test.com', online: true ),
    Usuario( uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false ),
    Usuario( uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'Mi nombre', style: TextStyle( color: Colors.black87 ) ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue[400]),
            // child: Icon( Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue[400]!,
        ),
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(), 
      ),
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
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
      );
  }

  _cargarUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}