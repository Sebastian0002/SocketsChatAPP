import 'package:flutter/material.dart';
import 'package:real_time_chat/ui/dimensions.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.enabled,
    this.buttonText,
    this.paddingButton,
  });

  final Function()? onPressed;
  final String? buttonText;
  final EdgeInsets? paddingButton;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: paddingButton ?? const EdgeInsets.all(0),
          child: MaterialButton(
            disabledColor: Colors.grey,
            shape: const StadiumBorder(),
            color: Colors.blueAccent,
            onPressed: enabled??true ? onPressed : null,
            child: SizedBox(
              width: double.infinity,
              height: 50*responsive.scaleHeight,
              child: Center(
                child: Text( 
                  buttonText ?? 'login', 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16
                    )
                  )
                ),
              ),
          ),
        ),
      ],
    );
  }
}
