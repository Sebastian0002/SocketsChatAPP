import 'package:real_time_chat/domain/models/user.dart';

abstract class LoginSignUpGateway {
  Future<dynamic> loginUser({required String email,required String password});
  Future<dynamic> signUpUser({required UserSignUp userSignUp});
  Future<dynamic> checkTokenStatus({required String token});
}