import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/pages/init_loading/transition_routes.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  static const String route = '/screen_loading';

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {

  void _navigateToPage(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      
      void navigateToWithAnimation(Route<dynamic> route){
        Navigator.pushReplacement(context, route);
      }

      final AuthProvider authProvider = context.read<AuthProvider>();
      final SocketsProvider socketsProvider = context.read<SocketsProvider>();
      final response = await authProvider.isLoggedIn();
      if(response == TypesAuth.redirectHome){
        await socketsProvider.connect();
        if(context.mounted){ 
          navigateToWithAnimation(homeTransition());
        }
      }
      if(response == TypesAuth.redirectLogin){
        if(context.mounted){ 
          navigateToWithAnimation(loginTransition());
        }
      }
      return response;      
    });
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.read<AuthProvider>().loading;
    if(!loading) _navigateToPage();
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.discreteCircle(color: Colors.blueAccent, size: 100*responsive.scaleAverage),
      ),
    );
  }
}