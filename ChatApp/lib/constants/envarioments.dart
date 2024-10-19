import 'dart:io';

final bool _isAndroid = Platform.isAndroid;
final String _ipAddress = _isAndroid ? "192.168.1.72" : "localhost";

class Enviroment {
  static String apiBaseUrl = 'http://$_ipAddress:3000/api';
  static String socketsBaseUrl = 'http://$_ipAddress:3000/';
}