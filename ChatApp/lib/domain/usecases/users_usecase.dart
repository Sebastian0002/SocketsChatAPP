
import 'package:real_time_chat/domain/gateways/users_gateway.dart';

import '../models/user.dart';

class UserUsecase{
  UserUsecase({required UserGateway userGateway}) : _userGateway = userGateway;
  final UserGateway _userGateway;

  Future<List<User>> getUsers({required String token}) async{
    return _userGateway.getUsers(token: token);
  }
}

