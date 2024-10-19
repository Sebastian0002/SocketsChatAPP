import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/dimensions.dart';

import 'package:real_time_chat/ui/pages/screens.dart';
import 'package:real_time_chat/ui/colors/colors.dart';
import 'package:real_time_chat/ui/dialogAlerts/general_dialog_alert.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/bottom_widget.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/textinput_login.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/widgets/top_widget.dart';
import 'package:real_time_chat/ui/pages/widgets/buttons.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  static const String route = '/screen_login';

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const WTop(),
                const _FormLogin(),
                Labels(
                  enabledRedirectText: !authProvider.loading,
                  title: "¿Don't have an account yet?",
                  redirectText: 'SignUp', 
                  onTap: (){
                  Navigator.pushNamed(context, ScreenSignUp.route);
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  const _FormLogin();

  @override
  State<_FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  late bool _isVisiblePassword;
  late bool _isEmptyPasswordInput;
  TextEditingController textController1 = TextEditingController(); 
  TextEditingController textController2 = TextEditingController(); 

   @override
  void initState() {
    _isVisiblePassword = false;
    _isEmptyPasswordInput = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final SocketsProvider socketsProvider = context.read<SocketsProvider>();
    void clearControllers(){
      setState(() {
        _isEmptyPasswordInput = true;
      });
      textController1.clear();
      textController2.clear();
    }

    void goToScreenUser(){
      Navigator.pushReplacementNamed(context, ScreenUser.route);
    }

    void failedLoginDialogAlert(){
      generalDialogAlert(
        context: context, 
        title: "Incorrect credentials to login", 
        subtitle: authProvider.messageErrorLogin
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextInputFieldLogin(
          enabled: !authProvider.loading,
          controller: textController1,
          inputType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline, color: Colors.blueAccent),
          hintText: 'Email',
          errorMessage: authProvider.errorEmail,
          onChanged: (val){
            authProvider.emailError(val);
          },
        ),
        SizedBox(height: 20*responsive.scaleHeight),
        TextInputFieldLogin(
          enabled: !authProvider.loading,
          controller: textController2,
          inputType: TextInputType.text,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
          suffixIcon: !_isEmptyPasswordInput
          ?_iconHidePassword()
            :null,
          hintText: 'Password',
          isHidenText: !_isVisiblePassword,
          onChanged: (val){
            authProvider.setInputPassword(val);
            val.isEmpty
            ?_isEmptyPasswordInput = true
            :_isEmptyPasswordInput = false;
            setState(() {});
          },
        ),
        SizedBox(height: 30*responsive.scaleHeight),
        PrimaryButton(
          enabled: authProvider.isEnabletoLogin(),
          paddingButton: EdgeInsets.symmetric(horizontal: 40*responsive.scaleWidth),
          onPressed: () async {
            authProvider.setEmailUser(textController1.text);
            authProvider.setPasswordUser(textController2.text);
            final response = await authProvider.loginUser();
            clearControllers();
            if(response == TypesAuth.loginSucces){
              socketsProvider.connect();
              if(mounted) goToScreenUser();
            }
            if(response == TypesAuth.loginFailed){
              if(mounted) failedLoginDialogAlert();
            }
          }),
      ],
    );
  }

  Widget _iconHidePassword() {
    return IconButton(
      icon: _isVisiblePassword
      ?Icon(FontAwesomeIcons.solidEyeSlash, color: Colors.blueAccent, size: 15*responsive.scaleAverage) 
      :Icon(Icons.remove_red_eye, color: Colors.blueAccent, size: 20*responsive.scaleAverage),
      onPressed: (){
        setState(() {_isVisiblePassword = !_isVisiblePassword;});
      }
    );
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

}