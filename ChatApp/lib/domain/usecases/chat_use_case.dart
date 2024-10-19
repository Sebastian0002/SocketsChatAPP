
import 'package:real_time_chat/domain/gateways/message_gateway.dart';

class ChatUseCase {
  ChatUseCase({required MessageGateway chatGateway}) : _chatGateway = chatGateway;
  final MessageGateway _chatGateway;

  Future getMessages({required String token, required String fromId})async{
    return _chatGateway.getMessages(token: token, fromId: fromId);
  }
}
