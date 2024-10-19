import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/domain/models/message.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/pages/chats/provider/chat_provider.dart';
import 'package:real_time_chat/ui/pages/chats/widgets/chat_messages.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';

class ScreenChat extends StatefulWidget {
  const ScreenChat({super.key});

  static const String route = '/screen_chat';

  @override
  State<ScreenChat> createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> with TickerProviderStateMixin {

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<WchatMessages> _messages =[];
  bool _isWriting = false;
  late AuthProvider authProvider;
  late ChatProvider chatProvider;
  late SocketsProvider socketsProvider;
  

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    chatProvider = context.read<ChatProvider>();
    socketsProvider = context.read<SocketsProvider>();
    socketsProvider.socket.on('personal-message', _listenMessage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{ 
      final res = await chatProvider.getMessages();
      if(res == Typechat.messagesRecived){
        _historyOfMessages(chatProvider.messages);
      }
    });
  }

  @override
  void dispose() {
    for (var e in _messages) {
      e.animationController.dispose();
    }
    socketsProvider.socket.off('personal-message');
    super.dispose();
  }

  _historyOfMessages(List<Message> messages){
    final history = messages.map((e) => 
      WchatMessages(
      txt: e.message, 
      uuid: e.from, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic data){
    WchatMessages message = WchatMessages(
      txt: data['message'], 
      uuid: data['from'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueAccent,
        elevation: 1,
        backgroundColor: Colors.black38,
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Image(image: AssetImage('assets/image_user.png'))),
            ),
            const SizedBox(width: 10),
            Text(chatProvider.userDestination.nombre, 
              style: TextStyle( color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16*responsive.scaleAverage),)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 23*responsive.scaleAverage,),
          onPressed: (){
            Navigator.pop(context);
          },
          ),
      ),
      body: Column(
        children: [
          Flexible(child: Padding(
            padding: EdgeInsets.only(top: 10*responsive.scaleHeight),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          )),
          const Divider(height: 1),
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
        padding: EdgeInsets.only(bottom: Platform.isAndroid ? 10*responsive.scaleHeight : 0),
        margin: EdgeInsets.only(left: 20*responsive.scaleWidth, right: 8.0*responsive.scaleWidth),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin:  EdgeInsets.only(top: 10*responsive.scaleHeight),
                padding: EdgeInsets.symmetric(horizontal: 20*responsive.scaleWidth),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  color: Colors.white

                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: (txt){
                    setState(() {
                      txt.isNotEmpty?_isWriting = true : _isWriting = false;
                    });
                  },
                  maxLines: 5,
                  minLines: 1,
                  autocorrect: true,
                  cursorColor: Colors.black45,
                  style: const TextStyle(
                      color: Colors.black54, 
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ))
            ),
            IconButton(
              onPressed: _isWriting
              ?_sendMessage
              :null, 
              icon: const Icon(Icons.send_rounded)
            )
          ],
        ),
      ),
    );
  } 

  void _sendMessage() {
    final newMessage = WchatMessages(
      txt: _textController.text, 
      uuid: authProvider.credentialsUser.uid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    socketsProvider.socket.emit('personal-message',{
      'from' : authProvider.credentialsUser.uid,
      'to' : chatProvider.userDestination.uid,
      'message' : _textController.text 
    });
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    FocusManager.instance.primaryFocus?.unfocus();
    _isWriting = false;
    _textController.clear();
    setState(() {});
  } 

}