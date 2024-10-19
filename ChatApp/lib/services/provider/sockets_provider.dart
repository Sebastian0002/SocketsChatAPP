import 'package:flutter/material.dart';
import 'package:real_time_chat/constants/envarioments.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerSatus{
  online,
  offline,
  connecting
}

class SocketsProvider extends ChangeNotifier{

  ServerSatus _satus = ServerSatus.connecting;
  ServerSatus get status => _satus;

  late io.Socket _socket;
  io.Socket get socket => _socket;

  Future<void> connect() async{

    final token = await AuthProvider.getToken();

    _socket = io.io(Enviroment.socketsBaseUrl,{
      'transports' : ['websocket'],
      'autoConnect' : true,
      'forceNew' : true,
      'extraHeaders': {
        'x-token' : token
      }
    });
    _socket.onConnect((_) {
      _satus = ServerSatus.online;
      notifyListeners();
    });
    _socket.onDisconnect((_){
      _satus = ServerSatus.offline;
      notifyListeners();
    });
  }

  void disconnect(){
    _socket.disconnect();
  }


}