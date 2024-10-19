import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/dialogAlerts/general_dialog_alert.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/icon_signin_button.dart';

import '../../screens.dart';

class Labels extends StatelessWidget {
  const Labels({super.key, required this.redirectText, required this.title, required this.enabledRedirectText, this.onTap});

  final String title;
  final String redirectText;
  final bool enabledRedirectText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),),
        SizedBox(height: 10*responsive.scaleHeight),
        InkWell(
          onTap: enabledRedirectText ? onTap : null,
          child: Text(
            redirectText, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: enabledRedirectText ? Colors.blueAccent : Colors.grey,
              fontSize: 16
            )
          )
        ),
        SizedBox(height: 20*responsive.scaleHeight),
        _singinMethods(context),
        SizedBox(height: 20*responsive.scaleHeight),
        const Text('terminos y condiciones', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
      ],
    );
  }


  //Method for the future. to add apple and google sigin
  
  Row _singinMethods(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final SocketsProvider socketsProvider = context.read<SocketsProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonSingIn(
            childIcon: FontAwesomeIcons.google,
            onTap: ()async{
              await authProvider.getGoogleToken();
              final response = await authProvider.googleLoginUser();
              if(response == TypesAuth.loginSucces){
              socketsProvider.connect();
              if(context.mounted) {Navigator.pushReplacementNamed(context, ScreenUser.route);}
            }
            if(response == TypesAuth.loginFailed){
              if(context.mounted){
                generalDialogAlert(
                  context: context, 
                  title: "Incorrect credentials to login", 
                  subtitle: authProvider.messageErrorLogin);
              } 
            }
            },
          ),
          SizedBox(width: 20*responsive.scaleWidth),
          ButtonSingIn(
            childIcon: FontAwesomeIcons.apple,
            onTap: (){},
          ),
        ],
      );
  }
}