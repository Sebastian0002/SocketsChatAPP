import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/dimensions.dart';

class WTop extends StatelessWidget {
  const WTop({super.key, this.topText});

  final String? topText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/tag-logo.png', 
            width: 150*responsive.scaleWidth, 
            height: 150*responsive.scaleHeight, 
            alignment: Alignment.center
          )
        ),
        Text(
          topText ?? 'Wellcome', 
          style: TextStyle(fontSize: 30*responsive.scaleAverage)
        ),
      ],
    );
  }
}