import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/constants/envarioments.dart';
import 'package:real_time_chat/domain/gateways/loginsignup_gateway.dart';
import 'package:real_time_chat/domain/models/user.dart';

class LoginSignUpRepository extends LoginSignUpGateway {

 final Map<String, String> _headers = {'content-type' : 'application/json'}; 

@override
Future<dynamic> loginUser({required String email,required String password})async{
  final Map<String, dynamic> data ={
    "email": email,
    "password": password
  };

  try {
    final res = await http.post(Uri.parse('${Enviroment.apiBaseUrl}/login'),
      body: jsonEncode(data), 
      headers: _headers
    );
    return _authResponseTreatment(res);
  } catch (_) {
    return _authResponseTreatment(http.Response("", 500));
  }

}

@override
Future<dynamic> signUpUser({required UserSignUp userSignUp})async{
  try {
    final http.Response res = await http.post(Uri.parse('${Enviroment.apiBaseUrl}/login/new'),
    body: userSignUpToMap(userSignUp), 
    headers: _headers
    );
    return _authResponseTreatment(res);
  } catch (_) {
      return _authResponseTreatment(http.Response("", 500));
  }
}

@override
Future<dynamic> checkTokenStatus({required String token}) async{
  if(token.isEmpty) return;
  _headers.putIfAbsent('x-token', () => token);
  final res = await http.get(Uri.parse('${Enviroment.apiBaseUrl}/login/renew'),
    headers: _headers
  );
  if(res.statusCode == 200){
    final resMap = jsonDecode(res.body) as Map<String, dynamic>;
    if(resMap['usuario'] !=null){
      final Map<String, dynamic> userData = resMap['usuario'];
      final token = resMap['token'];
      userData.putIfAbsent("token", () => token);
      return User.fromMap(userData);
    }
  }
}

Future<dynamic> googleAuth({required String token})async{
  final Map<String, dynamic> data ={'token': token};
  try {
    final res = await http.post(Uri.parse('${Enviroment.apiBaseUrl}/login/google'),
      body: jsonEncode(data), 
      headers: _headers
    );
    return _authResponseTreatment(res);
  } catch (e) {
    return _authResponseTreatment(http.Response("", 500));
  }
}

dynamic _authResponseTreatment(http.Response res){
  final Map<String, dynamic> wrongResponse = {};
  final resMap = jsonDecode(res.body) as Map<String, dynamic>;
  if(res.statusCode == 200){
    final Map<String, dynamic> userData = resMap['user'];
    final token = resMap['token'];
    userData.putIfAbsent("token", () => token);
    return User.fromMap(userData);
  }
  else{
    if(resMap['msg'] == null && resMap['errors'] != null){
      final Map mapErrors = resMap['errors'];
      wrongResponse.putIfAbsent("message", () => mapErrors.values.first['msg']);
    }
    else{
      wrongResponse.putIfAbsent("message", () => resMap['msg'] ?? "Server crashed");
    }
    return wrongResponse;
 }
}
} 