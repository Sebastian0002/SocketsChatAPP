import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:real_time_chat/domain/gateways/loginsignup_gateway.dart';
import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/domain/usecases/loginsignup_usecase.dart';
import 'package:real_time_chat/helpers/general_validators.dart';
import 'package:real_time_chat/interface/repositories/loginsignup_repository.dart';

class AuthProvider extends ChangeNotifier{

  late LoginSignUpGateway _gateway;
  late LoginSignUpUsecase _authUsecase;
  AuthProvider(){
    _gateway = LoginSignUpRepository();
    _authUsecase = LoginSignUpUsecase(loginSignUpGateway: _gateway);
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const List<String> scopes = <String>['email'];
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);


  User _credentialsUser = User.empty();
  User get credentialsUser => _credentialsUser;
  UserSignUp _infoUserSignUp = UserSignUp.empty();
  UserSignUp get infoUserSignUp => _infoUserSignUp;
  String _messageErrorLogin = "";
  String get messageErrorLogin => _messageErrorLogin;
  String _errorEmail = "";
  String  get errorEmail => _errorEmail;
  String _messageErrorSignUp = "";
  String _googleToken = "";
  String get messageErrorSignUp => _messageErrorSignUp;
  bool _loading = false;
  bool get loading => _loading;



  String _email = "";
  String _password = "";
  String _inputemail = "";
  String _inputpassword = "";

  void emailError(String txt){
    _errorEmail=GeneralValidators.validateEmail(txt);
    _inputemail = txt;
    notifyListeners();
  }

  void setInputPassword(String txt){
    _inputpassword = txt;
  }

  void setEmailUser(String email){
    _email = email;
  }

  void setPasswordUser(String password){
    _password = password;
  }
  
  void setUserSignUp(UserSignUp userSignUp){
    _infoUserSignUp = userSignUp;
  }

  bool isEnabletoLogin(){
    return 
    !_loading 
    && _errorEmail.isEmpty 
    && _inputemail.isNotEmpty 
    && _inputpassword.isNotEmpty;
  }

  Future _saveUserToken(String token) async{
    await _storage.write(key: "token", value: token);
  }
  
  Future getGoogleToken() async{
    final account = await _googleSignIn.signIn();
    final googleKey = await account?.authentication;
    _googleToken = googleKey?.idToken ?? "";
  }

  Future _googleSignOut() async{
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future getToken() async{
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  Future deleteToken() async{
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await _googleSignOut();
  }


  Future loginUser()async{
    _messageErrorLogin = "";
    _loading = true;
    notifyListeners();
    final res = await _authUsecase.loginUser(email: _email, password: _password);
    _loading = false;
    notifyListeners();
    if(res is User){
      _credentialsUser = res;
      await _saveUserToken(_credentialsUser.token!);
      return TypesAuth.loginSucces;
    }
    else{
      _messageErrorLogin = res["message"] ?? "Message not mapped from back";
      return TypesAuth.loginFailed;
    }
  }

  Future googleLoginUser()async{
    _messageErrorLogin = "";
    _loading = true;
    notifyListeners();
    final res = await _authUsecase.googleLoginUser(token: _googleToken);
    _loading = false;
    notifyListeners();
    if(res is User){
      _credentialsUser = res;
      await _saveUserToken(_credentialsUser.token!);
      return TypesAuth.loginSucces;
    }
    else{
      _messageErrorLogin = res["message"] ?? "Message not mapped from back";
      return TypesAuth.loginFailed;
    }
  }
  
  Future signUpUser()async{
    _messageErrorSignUp = "";
    _loading = true;
    notifyListeners();
    final res = await _authUsecase.signUpUser(userSignUp: _infoUserSignUp);
    _loading = false;
    notifyListeners();
    if(res is User){
      _credentialsUser = res;
      await _saveUserToken(_credentialsUser.token!);
      return TypesAuth.signUpSucces;
    }
    else{
      _messageErrorSignUp = res["message"] ?? "Missing data, try again.";
      return TypesAuth.signUpFailed;
    }
  }
  
  Future isLoggedIn() async{
    _loading = true;
    notifyListeners();
    final token = await getToken();
    final res = await _authUsecase.checkTokenStatus(token: token);
    _loading = false;
    notifyListeners();
    if(res is User){
      _credentialsUser = res;
      await _saveUserToken(_credentialsUser.token!);
      return TypesAuth.redirectHome;
    }
    else{
      deleteToken();
      return TypesAuth.redirectLogin;
    }
  }



}

enum TypesAuth {
  loginSucces,
  loginFailed,
  signUpSucces,
  signUpFailed,
  redirectHome,
  redirectLogin
}
