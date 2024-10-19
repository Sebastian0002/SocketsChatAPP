import 'package:flutter/material.dart';

import 'package:real_time_chat/domain/gateways/users_gateway.dart';
import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/domain/usecases/users_usecase.dart';
import 'package:real_time_chat/interface/repositories/user_repository.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';

class UsersProvider extends ChangeNotifier{

  late UserGateway _gateway;
  late UserUsecase _userUsecase;
  UsersProvider(){
    _gateway = UserRepository();
    _userUsecase = UserUsecase(userGateway: _gateway);
  }

  final List<User> _users = [];
  List<User> get users => _users;

  bool _loading = false;
  bool get loading => _loading;

  Future getUsers() async{
    _users.clear();
    _loading = true;
    notifyListeners();
    final token = await AuthProvider.getToken();
    final res = await _userUsecase.getUsers(token: token);
    _loading = false;
    notifyListeners();
    if(res.isNotEmpty){
      _users.addAll(res);
      return TypeUsers.hasUsers;
    }
    else{
      return TypeUsers.notHasUsers;
    }
  }
}

enum TypeUsers{
  hasUsers,
  notHasUsers
}
