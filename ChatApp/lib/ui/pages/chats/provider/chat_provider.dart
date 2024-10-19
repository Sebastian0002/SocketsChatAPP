import 'package:flutter/material.dart';
import 'package:real_time_chat/domain/gateways/message_gateway.dart';
import 'package:real_time_chat/domain/models/message.dart';
import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/domain/usecases/chat_use_case.dart';
import 'package:real_time_chat/interface/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier{  

  late MessageGateway _gateway;
  late ChatUseCase _chatUsecase;
  ChatProvider(){
    _gateway = ChatRepository();
    _chatUsecase = ChatUseCase(chatGateway: _gateway);
  }

  User _userDestination = User.empty();
  User get userDestination => _userDestination;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  String _token = "";
  String _fromId = "";

  void setToken(String token){
    _token = token;
  }
  void setFromId(String fromId){
    _fromId = fromId;
  }


  void setUserDestination( User user ){
    _userDestination = user;
    notifyListeners();
  } 

  Future getMessages () async{
    _messages.clear();
    final res = await _chatUsecase.getMessages(token: _token, fromId: _fromId);
    if(res is List<Message>){
      _messages.addAll(res);
      return Typechat.messagesRecived;
    }
    else{
      return Typechat.messagesNotRecived;
    }
  }


}

enum Typechat{
  messagesRecived,
  messagesNotRecived
}

