import 'dart:convert';

import 'package:real_time_chat/constants/environments.dart';
import 'package:real_time_chat/domain/gateways/message_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/domain/models/message.dart';

class ChatRepository extends MessageGateway{

  @override
  Future getMessages({required String token, required String fromId})async{
    final List<Message> messages = [];
    final res = await http.get(Uri.parse('${Environment.apiBaseUrl}/messages/$fromId'),
    headers: {
      'content-type' : 'application/json',
      'x-token': token
      }
    );
      final resMap = jsonDecode(res.body) as Map<String, dynamic>;
    if(res.statusCode == 200){
      final List messageList = resMap['messages'] as List;
      for (var e in messageList) {
        messages.add(Message.fromMap(e));
      }
      return messages;
    }
    return [];
  }
}

