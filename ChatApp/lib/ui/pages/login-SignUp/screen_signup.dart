import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/colors/colors.dart';
import 'package:real_time_chat/ui/dialogAlerts/general_dialog_alert.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/ui/pages/home/screen_users.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/bottom_widget.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/textinput_login.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/top_widget.dart';
import 'package:real_time_chat/ui/pages/widgets/buttons.dart';

class ScreenSignUp extends StatelessWidget {
  const ScreenSignUp({super.key});

  static const String route = '/screen_signup';

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: responsive.screenHeight * .89,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const WTop(topText: 'Register',),
                const _FormRegister(),
                Labels(
                  enabledRedirectText: !authProvider.loading,
                  title: '¿Already have an account?',
                  redirectText: 'login',
                  onTap: (){
                    Navigator.pop(context);
                  },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormRegister extends StatelessWidget {
  const _FormRegister();
  @override
  Widget build(BuildContext context) {
    TextEditingController textController1 = TextEditingController(); 
    TextEditingController textController2 = TextEditingController(); 
    TextEditingController textController3 = TextEditingController();  
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final SocketsProvider socketsProvider = context.watch<SocketsProvider>();

    void clearControllers(){
    textController1.clear();
    textController2.clear();
    textController3.clear();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextInputFieldLogin(
          controller: textController1,
          inputType: TextInputType.text,
          prefixIcon: const Icon(Icons.person_2_outlined, color: Colors.blueAccent),
          hintText: 'Name',
        ),
        SizedBox(height: 20*responsive.scaleHeight),
        TextInputFieldLogin(
          controller: textController2,
          inputType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.mail_outline, color: Colors.blueAccent),
          hintText: 'Email',
        ),
        SizedBox(height: 20*responsive.scaleHeight),
        TextInputFieldLogin(
          controller: textController3,
          inputType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
          hintText: 'Password',
          isHidenText: true,
        ),
        SizedBox(height: 30*responsive.scaleHeight),
        PrimaryButton(
          enabled: !authProvider.loading,
          buttonText: 'SignUp',
          paddingButton: EdgeInsets.symmetric(horizontal: 40*responsive.scaleWidth),
          onPressed: () async{
            authProvider.setUserSignUp(
              UserSignUp(
                email: textController2.text, 
                nombre: textController1.text, 
                password: textController3.text
              ));
            final response = await authProvider.signUpUser();
            clearControllers();
             if(response == TypesAuth.signUpSucces){
              socketsProvider.connect();
              if(context.mounted){
                 Navigator.pushNamedAndRemoveUntil(context, ScreenUser.route, (Route<dynamic> route) => false);
              }
            }
            if(response == TypesAuth.signUpFailed){
              if(context.mounted){
                generalDialogAlert(
                  context: context, 
                  title: "An error was ocurred", 
                  subtitle: authProvider.messageErrorSignUp);
              } 
            }
          }),
      ],
    );
  }
}




