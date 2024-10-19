import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/services/provider/providers.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/ui/routes/routes.dart';
void main() {
  runApp(MultiProvider(
    providers: providers,
    child: const MainApp()));
}

class MainApp extends StatefulWidget{
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      responsive.initResponsive(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: init,
      routes: routesApp,
    );
  }
}
