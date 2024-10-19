import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:real_time_chat/constants/environments.dart';

import 'package:real_time_chat/domain/gateways/users_gateway.dart';
import 'package:real_time_chat/domain/models/user.dart';

class UserRepository extends UserGateway{

  @override
  Future<List<User>> getUsers({required String token}) async {
    final List<User> users = []; 
    final res = await http.get(Uri.parse('${Environment.apiBaseUrl}/users/'),
    headers: {
      'content-type' : 'application/json',
      'x-token': token
      }
  );
  final resMap = jsonDecode(res.body) as Map<String, dynamic>;

  if(res.statusCode == 200){
    final List usersResponse = resMap['users'] as List;
    for (var user in usersResponse) {
      users.add(User.fromMap(user));
    }
    return users;
  }
  else{
    return [];
  }
  }

}
