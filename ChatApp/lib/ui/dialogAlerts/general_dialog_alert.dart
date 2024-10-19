

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/dimensions.dart';

void generalDialogAlert ({
  required BuildContext context,
  required String title,
  required String subtitle,
  String? buttonText,
  Widget? content,
  Function()? onPressed
}){

  if(Platform.isIOS){
    showCupertinoDialog(
      context: context, 
      builder: (_){
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(subtitle),
              if(content != null)
              Padding(
                padding: EdgeInsets.only(top: 10*responsive.scaleWidth),
                child: content,
                )
            ],
          ),
          actions: [
             CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: onPressed ?? ()=> Navigator.pop(context),
              child: Text( buttonText ??'Ok'),
              )
          ],
        );
      }
    );
  }
  else {

    showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(subtitle),
              if(content != null)
              Padding(
                padding: EdgeInsets.only(top: 10*responsive.scaleWidth),
                child: content,
              )
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: onPressed ?? ()=> Navigator.pop(context),
              child: Text( buttonText ?? 'Ok'),
              )
          ],
        );
      }
      
      );

  }

}

