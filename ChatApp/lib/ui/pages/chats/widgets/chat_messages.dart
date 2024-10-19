import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';

class WchatMessages extends StatelessWidget {
  const WchatMessages({super.key, required this.txt, required this.uuid, required this.animationController});

  final String txt;
  final String uuid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.read<AuthProvider>();
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut) ,
        child: Container(
          child: uuid == authProvider.credentialsUser.uid
            ?_myMessages()
            :_theirMessages()
        ),
      ),
    );
  }
  
  Widget _myMessages() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10*responsive.scaleHeight,
          right: 10*responsive.scaleHeight,
          left: 50*responsive.scaleWidth
        ),
        padding: EdgeInsets.all(8*responsive.scaleAverage),
        decoration:  BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(11)
        ),
        child: Text(
          txt, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)
        ),
      ),
    );
  }
  
  Widget _theirMessages() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10*responsive.scaleHeight,
          right: 50*responsive.scaleWidth,
          left: 10*responsive.scaleWidth
        ),
        padding: EdgeInsets.all(8*responsive.scaleAverage),
        decoration:  BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(11)
        ),
        child: Text(
          txt, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)
        ),
      ),
    );
  }
}