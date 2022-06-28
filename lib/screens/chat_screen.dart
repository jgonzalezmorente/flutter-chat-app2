import 'dart:io';

import 'package:chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  
  final List<ChatMessage> _messages = [
  ];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: const Text('Te', style: TextStyle( fontSize: 12 )),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox( height: 3 ),
            const Text( 'Melissa Flores', style: TextStyle( color: Colors.black87, fontSize: 12 ) )
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
      uid: '123', 
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
    
  }

  @override
  void dispose() {
    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }    
    super.dispose();
  }
}
