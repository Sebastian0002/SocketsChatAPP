
import 'package:real_time_chat/domain/models/user.dart';

abstract class UserGateway{

  Future<List<User>> getUsers({required String token});

}
