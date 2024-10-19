

import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/pages/screens.dart';

final Map<String, Widget Function(BuildContext)> routesApp = {
  ScreenChat.route : (_) => const ScreenChat(),
  ScreenLoading.route : (_) => const ScreenLoading(),
  ScreenLogin.route : (_) => const ScreenLogin(),
  ScreenSignUp.route : (_) => const ScreenSignUp(),
  ScreenUser.route : (_) => const ScreenUser()
};

const String init = ScreenLoading.route;


