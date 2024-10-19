import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/dimensions.dart';

class TextInputFieldLogin extends StatelessWidget {
  const TextInputFieldLogin({
    super.key,
    required this.controller,
    this.prefixIcon, this.suffixIcon,
    this.isHidenText,
    this.inputType,
    this.boxMargin,
    this.textPadding,
    this.hintText,
    this.onChanged,
    this.errorMessage,
    this.enabled = true
  });

  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isHidenText;
  final TextInputType? inputType;
  final EdgeInsets? textPadding;
  final EdgeInsets? boxMargin;
  final String? hintText;
  final Function(String str)? onChanged;
  final bool enabled;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: boxMargin ?? EdgeInsets.symmetric(horizontal: 40*responsive.scaleHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputText(),
          if(errorMessage != null && errorMessage!.isNotEmpty)_errorMessage()
        ],
      ),
    );
  }

  Column _errorMessage() {
    return Column(
          children: [
            SizedBox(height: 5*responsive.scaleHeight),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15*responsive.scaleWidth),
            child: Text(errorMessage??"", style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500),),
          )
          ],
        );
  }

  Container _inputText() {
    return Container(
        padding: textPadding ?? EdgeInsets.only(right: 15*responsive.scaleWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5
              ),
          ],
        ),
        child: TextField(
          controller: controller,
          autocorrect: false,
          keyboardType: inputType ?? TextInputType.text,
          obscureText: isHidenText ?? false,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabled: enabled,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: hintText
          ),
        ),
      );
  }
}