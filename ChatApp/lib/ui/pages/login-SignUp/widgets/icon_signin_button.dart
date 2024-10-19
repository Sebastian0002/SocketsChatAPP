import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/dimensions.dart';

class ButtonSingIn extends StatelessWidget {
  const ButtonSingIn({super.key, required this.childIcon, this.onTap});
  final IconData childIcon;
  final Function()? onTap;

  static const double _sizeButton = 45;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      focusColor: Colors.white,
      onTap: onTap,
      child: SizedBox(
        width: _sizeButton,
        height: _sizeButton,
        child: Icon(childIcon, color: Colors.blueAccent, size: 30*responsive.scaleAverage),
      ),
    );
  }
}

