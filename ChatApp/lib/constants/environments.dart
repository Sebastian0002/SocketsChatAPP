import 'dart:io';

final bool _isAndroid = Platform.isAndroid;
final String _ipAddress = _isAndroid ? "YOUR_IP_ADDRESS" : "localhost";

class Environment {
  static String apiBaseUrl = 'http://$_ipAddress:3000/api';
  static String socketsBaseUrl = 'http://$_ipAddress:3000/';
}