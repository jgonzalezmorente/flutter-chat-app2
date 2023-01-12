import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/models.dart';
import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';


class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;
  
  final List<ChatMessage> _messages = [
  ];

  bool _estaEscribiendo = false;

  @override
  void initState() {

    super.initState();
    
    authService   = Provider.of<AuthService>( context, listen: false );
    chatService   = Provider.of<ChatService>( context, listen: false );
    socketService = Provider.of<SocketService>( context, listen: false );

    socketService.socket.on( 'mensaje-personal', _escucharMensaje );

    _cargarHistorial( chatService.usuarioPara!.uid );

  }

  void _cargarHistorial( String usuarioID ) async {

    List<Mensaje>? chat = await chatService.getChat( usuarioID );

    final history = chat!.map( (m) => ChatMessage(
      uid: m.de!, 
      texto: m.mensaje!, 
      animationController: AnimationController( vsync: this, duration: const Duration( milliseconds: 0))..forward()
    ));

    setState(() {
      _messages.insertAll( 0, history );
    });


  }
  
  void _escucharMensaje( dynamic payload ) {

    if ( payload['de'] != chatService.usuarioPara?.uid ) {
      return;
    }

    ChatMessage newMessage = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this, 
        duration: const Duration( milliseconds: 200 )
      ),
    );

    setState(() {
      _messages.insert( 0, newMessage );
    });

    newMessage.animationController.forward();

  } 


  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text( usuarioPara!.nombre.substring(0, 2), style: const TextStyle( fontSize: 12 )),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox( height: 3 ),
            Text( usuarioPara.nombre, style: const TextStyle( color: Colors.black87, fontSize: 12 ) )
        ]),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: ( _ , i ) => _messages[ i ],
              itemCount: _messages.length,
              reverse: true,
            ),
          ),
          const Divider( height: 1 ),
          Container(
            color: Colors.white,    
            child: _inputChat(),
          )
        ],
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: ( String texto ) {
                  setState(() {
                    if ( texto.trim().isNotEmpty ) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),
            
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
              child: Platform.isIOS 
                ? CupertinoButton(
                  child: const Text( 'Enviar' ), 
                  onPressed: _estaEscribiendo 
                    ? () => _handleSubmit( _textController.text.trim() )
                    : null 
                )
                
                : Container(
                  margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                  child: IconTheme(
                    data: IconThemeData( color: Colors.blue[400] ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon( Icons.send ),
                      onPressed: _estaEscribiendo 
                        ? () => _handleSubmit( _textController.text.trim() )
                        : null 
                    ),
                  ),
                )
            )
          ]
        ),
      )
    );
  }

  
  _handleSubmit( String texto ) {
    if ( texto.isEmpty ) return;
    final newMessage = ChatMessage(
      uid: authService.usuario!.uid, 
      texto: texto,
      animationController: AnimationController( vsync: this, duration: const Duration( milliseconds: 200 ) ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    _textController.clear();
    _focusNode.requestFocus();

    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit( 'mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatService.usuarioPara!.uid,
      'mensaje': texto
    });
    
  }

  @override
  void dispose() {
    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }
    socketService.socket.off( 'mensaje-personal' );

    super.dispose();
  }
}
