import 'package:real_time_chat/domain/gateways/loginsignup_gateway.dart';
import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/interface/repositories/loginsignup_repository.dart';

class LoginSignUpUsecase {
  LoginSignUpUsecase({required LoginSignUpGateway loginSignUpGateway}) : _loginSignUpGateway = loginSignUpGateway;  
  final LoginSignUpGateway _loginSignUpGateway;
  final LoginSignUpRepository _repository = LoginSignUpRepository();

  Future<dynamic> loginUser({required String email,required String password}){
    return _loginSignUpGateway.loginUser(email: email, password: password);
  }

  Future<dynamic> signUpUser({required UserSignUp userSignUp}){
    return _loginSignUpGateway.signUpUser(userSignUp: userSignUp);
  }

  Future<dynamic> checkTokenStatus({required String? token}){
    return _loginSignUpGateway.checkTokenStatus(token: token ?? "");
  }

  Future<dynamic> googleLoginUser({required String token}){
    return _repository.googleAuth(token: token);
  }

}

