import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';

class CustomTextButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String buttonText;
  final VoidCallback? onPressed;

  const CustomTextButton({
    super.key,
    this.width = 350,
    this.height = 50,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: bColor,
            // backgroundColor: const Color.fromARGB(255, 222, 217, 217),
            backgroundColor: appbarColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
